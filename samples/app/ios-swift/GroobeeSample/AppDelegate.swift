import UIKit
import FirebaseCore
import FirebaseMessaging
import GroobeeKit
import UserNotifications

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private let logger = GroobeeSampleLogger()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // 0) (선택) SDK 로그 설정 ------------------------------------------------
        configureLogger()

        // 1) GroobeeConfig 구성 -------------------------------------------------
        let groobeeConfig = GroobeeConfig.GroobeeConfigBuilder()
            // [필수] 서비스키 + Bundle ID
            .setServiceKey(serviceKey: SampleConfig.serviceKey, bundleId: SampleConfig.bundleId)
            // 인앱메시지 상/하단 여백
            .setInAppMsgMarginTop(50)
            .setInAppMsgMarginBottom(17)
            // 푸시 알림 "알림 설정" 버튼 + 딥링크
            .setNotificationSettingsButton("알림 설정", SampleConfig.notificationSettingsDeeplink)
            .build()

        // 2) Groobee 초기화 -----------------------------------------------------
        Groobee.configure(groobeeConfig: groobeeConfig)
        AppLog.shared.log("Groobee.configure 완료 (bundleId=\(SampleConfig.bundleId))")

        // 3) 푸시 알림 응답 처리를 위해 UNUserNotificationCenter delegate 지정 -----
        UNUserNotificationCenter.current().delegate = self

        // 4) Firebase(FCM) 설정 + 권한 요청 -------------------------------------
        configureFirebaseIfPossible()
        requestPushAuthorization(application)

        return true
    }

    // MARK: - Scene lifecycle (iOS 13+)

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        GroobeeKitLifeCycle.sceneDidDisconnect()
    }

    // MARK: - 딥링크 (푸시 알림 설정 버튼 등)

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        AppLog.shared.log("딥링크 수신: \(url.absoluteString)")
        return true
    }

    // MARK: - Helpers

    private func configureLogger() {
        LoggerUtils.setLogLevel(GroobeeLogLevel.verbose.rawValue)
        LoggerUtils.setDetailLogEnabled(true)
        LoggerUtils.setTraceEnabled(true)
        LoggerUtils.setLogCallback(logger)
    }

    private func configureFirebaseIfPossible() {
        // GoogleService-Info.plist 가 번들에 없으면 FCM 설정을 건너뜁니다.
        guard Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist") != nil else {
            AppLog.shared.log("FCM 건너뜀: GoogleService-Info.plist 를 GroobeeSample 타깃에 추가하세요.")
            return
        }
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        AppLog.shared.log("Firebase 설정 완료")
    }

    private func requestPushAuthorization(_ application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, error in
            if let error = error {
                AppLog.shared.log("푸시 권한 요청 오류: \(error.localizedDescription)")
            } else {
                AppLog.shared.log("푸시 권한 요청 결과: granted=\(granted)")
            }
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
}

// MARK: - FCM / APNS / 알림 처리
extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // Firebase swizzling 을 끈 상태이므로 APNs 토큰을 직접 전달
        if FirebaseApp.app() != nil {
            Messaging.messaging().apnsToken = deviceToken
        }
        AppLog.shared.log("APNs 토큰 등록 (length=\(deviceToken.count))")
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        AppLog.shared.log("APNs 등록 실패: \(error.localizedDescription)")
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // 푸시 수신 이벤트를 Groobee 로 전달
        Groobee.getInstance().didReceiveRemoteNotification(userInfo: userInfo)
        completionHandler(.newData)
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken, !fcmToken.isEmpty else { return }
        // FCM 토큰을 Groobee 로 전달
        Groobee.getInstance().setPushToken(pushToken: fcmToken)
        AppLog.shared.log("FCM 토큰 → setPushToken(): \(String(fcmToken.prefix(24)))…")
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: ["token": fcmToken])
    }

    // 포그라운드에서 푸시가 도착했을 때 표시 방식
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if #available(iOS 14.0, *) {
            completionHandler([.badge, .sound, .banner, .list])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }

    // 푸시 본문 탭 / "알림 설정" 버튼 액션 처리 (SDK 1.1.5+)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if Groobee.getInstance().userNotificationCenter(response: response) {
            AppLog.shared.log("Groobee 푸시 응답 처리됨 (action=\(response.actionIdentifier))")
        } else {
            AppLog.shared.log("비-Groobee 푸시 응답 (action=\(response.actionIdentifier))")
        }
        completionHandler()
    }
}

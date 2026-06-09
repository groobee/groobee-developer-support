package io.groobee.sample

import android.app.Application
import android.app.NotificationManager
import android.os.Build
import android.util.Log
import com.google.firebase.FirebaseApp
import io.groobee.message.Groobee
import io.groobee.message.GroobeeConfig
import io.groobee.message.utils.LoggerUtils

/**
 * Groobee SDK 초기화는 반드시 Application.onCreate() 에서 수행합니다.
 *
 * 설치 가이드: docs/installation/installation-android-sdk.md
 */
class SampleApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        // 1) GroobeeConfig 구성 ------------------------------------------------
        val groobeeConfig = GroobeeConfig.Builder()
            // [필수] 어드민에서 발급받은 서비스키
            .setApiKey(GroobeeSampleConfig.SERVICE_KEY)
            // [필수] 푸시 알림 small icon (흰색 단색 권장)
            .setSmallNotificationIcon(resources.getResourceName(R.drawable.ic_push))
            // 푸시 딥링크 처리 활성화
            .setHandlePushDeepLinks(true)
            // 푸시 클릭 시 이동할 Activity
            .setPushMoveActivityEnabled(true)
            .setPushMoveActivityClassName(MainActivity::class.java)
            // 푸시 알림에 "알림 설정" 버튼 노출 + 클릭 시 이동할 딥링크
            .setNotificationSettingsButton(
                R.string.txt_notification_setting,
                GroobeeSampleConfig.NOTIFICATION_SETTINGS_DEEPLINK
            )
            // 인앱메시지 상/하단 여백(dp)
            .setInAppMsgMarginTop(30)
            .setInAppMsgMarginBottom(40)
            // 최초 인증 실패 시 재시도
            .setRetryAuthConnection(true)

        // Android 7.1(N) 초과에서는 푸시 채널 중요도 설정
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.N) {
            groobeeConfig.setPushImportance(NotificationManager.IMPORTANCE_HIGH)
        }

        // 2) Groobee 초기화 ----------------------------------------------------
        Groobee.configure(this, groobeeConfig.build())

        // 3) 인앱메시지 표시를 위한 ActivityLifecycle 콜백 등록 [필수] ----------
        registerActivityLifecycleCallbacks(Groobee.getInstance().activityLifecycleCallbacks)

        // 4) (선택) SDK 로그 레벨 설정 -----------------------------------------
        LoggerUtils.setLogLevel(Log.VERBOSE)

        // 5) Firebase 초기화 (FCM 푸시 사용 시) --------------------------------
        //    google-services.json 이 있으면 FirebaseInitProvider 가 앱 시작 시
        //    default 앱을 자동 초기화하므로, 중복 초기화 크래시를 피하려면 가드가 필요합니다.
        //    app/google-services.json 을 본인 Firebase 프로젝트 파일로 교체해야
        //    실제 토큰 발급/푸시 수신이 동작합니다.
        if (FirebaseApp.getApps(this).isEmpty()) {
            FirebaseApp.initializeApp(this)
        }
    }
}

import Foundation

/// 샘플 전역 설정값.
///
/// 서비스키 / 추천 캠페인키는 소스가 아니라 `GroobeeSample/Secrets.plist` 에서 읽습니다.
/// (Secrets.plist 는 .gitignore 대상이며, 없으면 placeholder 로 동작합니다.)
/// 설정 방법은 README 의 "설정" 섹션을 참고하세요. 번들 ID 는 project.yml 에서 설정합니다.
enum SampleConfig {

    /// 어드민에서 발급받은 서비스키 (Secrets.plist 의 GROOBEE_SERVICE_KEY)
    static let serviceKey = secret("GROOBEE_SERVICE_KEY", fallback: "YOUR_GROOBEE_SERVICE_KEY")

    /// AI 추천 캠페인키 (Secrets.plist 의 GROOBEE_RECOMMEND_CAMPAIGN_KEY)
    static let recommendCampaignKey = secret("GROOBEE_RECOMMEND_CAMPAIGN_KEY", fallback: "YOUR_RECOMMEND_CAMPAIGN_KEY")

    /// 번들에 포함된 Secrets.plist 에서 값을 읽습니다. (없으면 fallback)
    private static func secret(_ key: String, fallback: String) -> String {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: url) as? [String: Any],
              let value = dict[key] as? String,
              !value.isEmpty else {
            return fallback
        }
        return value
    }

    /// 푸시 알림 설정 버튼 / 딥링크 스킴 (Info.plist 의 CFBundleURLSchemes 와 동일)
    static let notificationSettingsDeeplink = "groobeesample://setting/notification"

    /// 데모 회원 ID
    static let demoMemberId = "groobee_demo_user"

    /// Groobee 초기화 시 함께 전달하는 Bundle ID
    static var bundleId: String { Bundle.main.bundleIdentifier ?? "io.groobee.sample" }

    /// 서비스키가 placeholder 인지 여부 (상태 표시용)
    static var isServiceKeyConfigured: Bool { serviceKey != "YOUR_GROOBEE_SERVICE_KEY" }

    /// 행동 이력 수집 시 현재 화면을 구분하는 screenId
    enum Screen {
        static let home = "HOME"
        static let search = "SEARCH"
        static let productDetail = "PRODUCT_DETAIL"
        static let category = "CATEGORY"
        static let cart = "CART"
        static let order = "ORDER"
        static let orderComplete = "ORDER_COMPLETE"
        static let signUp = "SIGN_UP"
    }
}

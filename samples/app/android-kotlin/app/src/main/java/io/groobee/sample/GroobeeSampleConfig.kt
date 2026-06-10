package io.groobee.sample

/**
 * 샘플 전역 설정값.
 *
 * 서비스키 / 추천 캠페인키 / applicationId 는 루트의 `secrets.properties` 에서 주입됩니다.
 * (build.gradle 이 secrets.properties 를 읽어 BuildConfig 로 전달)
 * 설정 방법은 README 의 "설정" 섹션을 참고하세요.
 */
object GroobeeSampleConfig {

    /** Groobee 서비스키 (secrets.properties 의 groobee.serviceKey) */
    val SERVICE_KEY: String = BuildConfig.GROOBEE_SERVICE_KEY

    /** AI 추천 캠페인키 (secrets.properties 의 groobee.recommendCampaignKey) */
    val RECOMMEND_CAMPAIGN_KEY: String = BuildConfig.GROOBEE_RECOMMEND_CAMPAIGN_KEY

    /** 푸시 알림 설정 버튼 / 푸시 딥링크용 스킴 (AndroidManifest.xml 의 intent-filter 와 동일) */
    const val NOTIFICATION_SETTINGS_DEEPLINK = "groobeesample://setting/notification"

    /** 데모 회원 ID */
    const val DEMO_MEMBER_ID = "groobee_demo_user"

    // ── 화면 식별자(screenId) ───────────────────────────────────────────
    // 행동 이력 수집 시 "어느 화면에서 발생했는지"를 구분하는 값입니다.
    const val SCREEN_HOME = "HOME"
    const val SCREEN_SEARCH = "SEARCH"
    const val SCREEN_PRODUCT_DETAIL = "PRODUCT_DETAIL"
    const val SCREEN_CATEGORY = "CATEGORY"
    const val SCREEN_CART = "CART"
    const val SCREEN_ORDER = "ORDER"
    const val SCREEN_ORDER_COMPLETE = "ORDER_COMPLETE"
    const val SCREEN_SIGN_UP = "SIGN_UP"
}

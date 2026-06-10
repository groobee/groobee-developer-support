# Groobee Android SDK 샘플 (Kotlin)

Maven Central 에 배포된 **Groobee Android SDK** 를 사용하는 최소 동작 샘플입니다.
회원/로그인, 푸시, 행동 이력, AI 추천까지 SDK 의 주요 기능을 버튼 하나씩으로 호출해 볼 수 있습니다.

---

## 사용하는 SDK

| 항목 | 값 |
| --- | --- |
| 저장소 | `mavenCentral()` (별도 URL/인증 불필요) |
| 의존성 | `io.groobee.message:groobee-sdk-message:1.0.83` |
| 푸시 | Firebase Cloud Messaging (`firebase-bom:33.16.0`) |

빌드 도구 버전은 SDK 가 검증된 조합(AGP 7.4.2 / Kotlin 1.8.0 / Gradle 7.5)에 맞춰져 있습니다.

---

## 프로젝트 구조

```
android-kotlin/
├── settings.gradle              # mavenCentral 저장소 선언
├── build.gradle                 # 플러그인 버전 (AGP / Kotlin / google-services)
├── gradle/ , gradlew            # Gradle Wrapper (7.5)
└── app/
    ├── build.gradle             # ★ Groobee SDK 의존성 선언
    ├── google-services.json     # ⚠️ placeholder — 본인 Firebase 파일로 교체
    ├── proguard-rules.pro       # release 난독화용 keep 규칙
    └── src/main/
        ├── AndroidManifest.xml  # 권한 + FCM 서비스 등록
        ├── java/io/groobee/sample/
        │   ├── SampleApplication.kt              # ★ SDK 초기화 (Groobee.configure)
        │   ├── MainActivity.kt                   # ★ 전체 기능 데모 화면
        │   ├── GroobeeSampleConfig.kt            # 서비스키 / 캠페인키 / screenId
        │   ├── DemoData.kt                       # 샘플 Goods 데이터
        │   ├── LogBus.kt                         # 화면 로그 (데모 전용)
        │   └── push/SampleFirebaseMessagingService.kt  # ★ 푸시 수신
        └── res/layout/activity_main.xml
```

`★` 표시가 실제 연동 시 참고할 핵심 파일입니다.

---

## 시작하기

### 1. 설정 파일 작성 (`secrets.properties`)

서비스키·캠페인키·applicationId 는 소스 코드가 아니라 **`secrets.properties`** 에 넣습니다.
(이 파일은 `.gitignore` 에 등록되어 커밋되지 않습니다. 파일이 없으면 placeholder 로 빌드만 됩니다.)

```bash
cp secrets.properties.example secrets.properties
```

복사한 `secrets.properties` 를 열어 값을 채우세요:

```properties
groobee.serviceKey=발급받은_서비스키
groobee.recommendCampaignKey=추천_캠페인키
groobee.applicationId=io.groobee.sample
```

| 키 | 설명 |
| --- | --- |
| `groobee.serviceKey` | 어드민에서 발급받은 서비스키 |
| `groobee.recommendCampaignKey` | AI 추천 캠페인키 (어드민 > 추천 캠페인) |
| `groobee.applicationId` | 앱 패키지(applicationId). 변경 시 `app/google-services.json` 의 `package_name` 도 일치시키세요. |

> 동작 원리: `app/build.gradle` 이 `secrets.properties` 를 읽어 `applicationId` 설정과
> `BuildConfig.GROOBEE_SERVICE_KEY` / `BuildConfig.GROOBEE_RECOMMEND_CAMPAIGN_KEY` 로 전달하고,
> [`GroobeeSampleConfig.kt`](app/src/main/java/io/groobee/sample/GroobeeSampleConfig.kt) 가 이를 사용합니다.

### 2. (푸시 사용 시) google-services.json 교체

`app/google-services.json` 은 **빌드만 되도록 만든 placeholder** 입니다.
실제 FCM 푸시를 받으려면 본인 Firebase 프로젝트의 `google-services.json` 으로 교체하세요.
이때 Firebase 프로젝트의 Android 앱 패키지명은 `io.groobee.sample` 과 일치해야 합니다.
(패키지명을 바꾸려면 `app/build.gradle` 의 `applicationId` / `namespace` 도 함께 수정)

> 어드민에 Firebase 비공개키를 등록하는 방법은
> [어드민 푸시 설정 가이드](https://docs.groobee.ai/new-admin/settings/push)를 참고하세요.

### 3. 빌드 / 실행

Android Studio 로 `android-kotlin` 폴더를 열고 `app` 구성을 실행하거나, 터미널에서:

```bash
./gradlew :app:assembleDebug      # APK 빌드
./gradlew :app:installDebug       # 연결된 기기/에뮬레이터에 설치
```

---

## 데모 화면에서 확인할 수 있는 SDK 호출

화면을 4개 섹션으로 나눠, 버튼을 누르면 해당 SDK 메소드가 호출되고 하단 로그에 기록됩니다.

| 섹션 | 버튼 | 호출 메소드 |
| --- | --- | --- |
| ① 회원/로그인 | 로그인 | `setServiceLogin(memberId)` |
| | 회원정보 설정 | `setMember(Map)` |
| | 회원가입 완료 | `setMemberJoin(activity, memberId, screenId)` |
| | 동의상태 동기화 | `syncMemberAgreed(memberId)` |
| | 로그아웃 | `setServiceLogout()` + `clearMemberData()` |
| ② 푸시 | FCM 토큰 조회/전송 | `setPushToken(token)` |
| | 전체/광고/야간 동의 | `setAgreedPush` / `setAgreedPushAdvertising` / `setAgreedPushNight` |
| | 동의 상태 조회 | `getPushAgreed(memberId, ResultAgreeds)` |
| ③ 행동 이력 | 검색 | `setSearchKeyword(...)` |
| | 상품 상세 | `setViewGoods(...)` |
| | 카테고리 | `setCategory(...)` |
| | 장바구니 | `setShoppingCart(...)` |
| | 주문서 / 주문완료 | `setGoodsOrder(...)` / `setGoodsOrderComplete(...)` |
| | 커스텀 이벤트 | `setCustomEvent(...)` |
| ④ AI 추천 | 추천 상품 요청 | `getRecommendGoods(campaignKey, ResultGoods)` → `setShowRecommendGoods` / `setClickRecommendGoods` |

> 서비스키가 placeholder 이거나 네트워크가 없으면 서버 전송은 실패할 수 있지만,
> **호출 코드와 흐름**은 그대로 확인할 수 있습니다. 실제 데이터 적재는 유효한 서비스키가 필요합니다.

---

## 관련 문서

- [Android SDK 설치 가이드](../../../docs/installation/installation-android-sdk.md)
- [Android 공통 추가 설정](../../../docs/installation/installation-android-common-settings.md)
- [회원 정보 및 푸시](../../../docs/detail/android-sdk-member-push.md) ·
  [행동 이력](../../../docs/detail/android-sdk-actions.md) ·
  [추천 상품](../../../docs/detail/android-sdk-recommend.md)
- [Android SDK 변경 로그](../../../docs/changelog/sdk-android-changelog.md)

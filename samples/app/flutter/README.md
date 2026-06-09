# Groobee Flutter 샘플

Flutter 앱에서 **Groobee SDK**(iOS `GroobeeKit`, Android `groobee-sdk-message`)를
`MethodChannel` 브리지로 호출하는 최소 동작 샘플입니다.

> Groobee 는 순수 Dart 패키지가 없으므로, Dart ↔ 네이티브 SDK 를 `MethodChannel` 로 연결합니다.

---

## 사용하는 SDK

| 플랫폼 | 정식 SDK |
| --- | --- |
| Android | `io.groobee.message:groobee-sdk-message:1.0.83` (Maven Central) |
| iOS | `pod 'GroobeeKit', '~> 1.1.6'` (CocoaPods) |
| 공통(Dart) | `firebase_core`, `firebase_messaging` (FCM 토큰 발급용) |

---

## 구조

```
flutter/
├── lib/
│   ├── main.dart                    # ★ 단일 화면 데모 UI + 로그
│   └── groobee/
│       ├── groobee_bridge.dart       # ★ MethodChannel 래퍼 (플랫폼 공통 API)
│       ├── goods.dart                # 상품 모델 (toMap)
│       └── push_helper.dart          # FCM 토큰 → setPushToken
├── android/app/src/main/kotlin/io/groobee/groobee_sample/
│   ├── GroobeeApplication.kt          # ★ Android SDK 초기화 (Groobee.configure)
│   └── MainActivity.kt                # ★ MethodChannel 핸들러 → Android SDK
├── android/app/google-services.json   # ⚠️ placeholder — 본인 Firebase 파일로 교체
└── ios/Runner/
    ├── AppDelegate.swift               # ★ iOS SDK 초기화 + MethodChannel 핸들러 + 푸시
    └── SceneDelegate.swift             # ★ GroobeeKitLifeCycle 연결
```

브리지 설계: Dart 는 **플랫폼 공통 메소드 이름**(`setServiceLogin`, `setViewGoods`, `setPushAgree` …)을
호출하고, 플랫폼별 차이(메소드명/인자 순서/타입)는 각 네이티브 핸들러가 흡수합니다.
채널 이름은 양쪽 모두 `io.groobee.sample/bridge` 입니다.

---

## 시작하기

### 1. 의존성 설치

```bash
cd samples/app/flutter
flutter pub get
```

### 2. 설정 파일 작성 (`groobee_config.json`)

서비스키·캠페인키는 소스 코드가 아니라 **`groobee_config.json`** 에 넣고 실행 시 주입합니다.
(이 파일은 `.gitignore` 대상이며, 없으면 placeholder 로 동작합니다.)

```bash
cp groobee_config.json.example groobee_config.json
```

복사한 `groobee_config.json` 을 열어 값을 채우세요:

```json
{
  "GROOBEE_SERVICE_KEY": "발급받은_서비스키",
  "GROOBEE_RECOMMEND_CAMPAIGN_KEY": "추천_캠페인키"
}
```

> 동작 원리: Dart 가 `--dart-define-from-file` 로 이 값들을 읽어, 앱 시작 시
> `bridge.configure(serviceKey)` 로 네이티브 Groobee 초기화를 수행합니다.
> (프로덕션에서 앱 종료 상태 푸시까지 처리하려면 네이티브 `Application.onCreate`/`didFinishLaunching`
> 에서 초기화하는 것을 권장합니다.)

**앱 번들 ID / 패키지 ID** 는 Flutter 표준 위치에서 변경합니다(Firebase/어드민 등록과 일치 필요):

- Android 패키지: [`android/app/build.gradle.kts`](android/app/build.gradle.kts) 의 `applicationId`
- iOS 번들 ID: Xcode > Runner 타깃 > General > Bundle Identifier (또는 `ios/Runner.xcodeproj`)

### 3. (푸시 사용 시) Firebase 설정

- Android: 본인 Firebase 프로젝트의 `google-services.json` 으로 `android/app/google-services.json` 을 교체
  (현재는 빌드용 placeholder). 패키지명은 위 `applicationId` 와 일치해야 합니다.
- iOS: `GoogleService-Info.plist` 를 `ios/Runner/` 에 추가하고 Xcode 에서 Runner 타깃에 포함
  + **Push Notifications / Background Modes(Remote notifications)** capability 활성화.

### 4. 실행

```bash
# 설정 파일을 주입해서 실행
flutter run --dart-define-from-file=groobee_config.json
```

> 설정 파일 없이 `flutter run` 만 해도 placeholder 로 빌드·실행됩니다(서버 전송은 동작 안 함).
> iOS 는 최초 1회 `cd ios && pod install` 이 필요합니다. (GroobeeKit 못 찾으면 `pod install --repo-update`)

---

## 데모 화면에서 확인할 수 있는 호출

| 섹션 | 동작 | 브리지 메소드 → 네이티브 |
| --- | --- | --- |
| ① 회원 | 로그인 / 회원정보 / 로그아웃 | `setServiceLogin` · `setMember` · `serviceLogout` |
| ② 푸시 | 동의 토글(AP/AA/AN), 동의 조회 | `setPushAgree` · `getPushAgreed` (FCM 토큰은 자동 전달) |
| ③ 행동 | 검색·상품·카테고리·장바구니·주문·구매완료·커스텀 | `setSearchKeyword` · `setViewGoods` · `setCategory` · `setShoppingCart` · `setGoodsOrder` · `setGoodsOrderComplete` · `setCustomEvent` |
| ④ 추천 | 추천 상품 요청(+노출/클릭 통계) | `getRecommendGoods` |

호출 결과는 화면 하단 로그에 표시됩니다.

> 서비스키가 placeholder 이거나 Firebase 미설정이면 서버 전송/푸시는 동작하지 않지만,
> 브리지 호출 흐름과 코드는 그대로 확인할 수 있습니다.

---

## 관련 문서

- [Android Flutter SDK 설치 가이드](../../../docs/installation/installation-android-flutter-sdk.md) ·
  [iOS Flutter SDK 설치 가이드](../../../docs/installation/installation-ios-flutter-sdk.md)
- [Android Flutter MethodChannel](../../../docs/detail/android-flutter-method-channel.md) ·
  [iOS Flutter MethodChannel](../../../docs/detail/ios-flutter-method-channel.md)

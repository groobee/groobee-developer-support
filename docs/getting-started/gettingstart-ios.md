# iOS SDK 설치 시작하기

이 문서는 iOS 앱에 Groobee SDK를 연동하기 전에 확인해야 할 준비사항과 문서 구조를 안내합니다. iOS 네이티브 앱과 Flutter 앱(iOS 빌드) 모두를 대상으로 합니다.

---

## 목차

1. [적용 대상](#target-scope)
2. [사전 준비](#prerequisites)
3. [구현 방식 선택](#implementation-choice)
4. [설치 문서](#installation-docs)
5. [상세 사용 문서](#detail-docs)
6. [다음 단계](#next-steps)

---

<a id="target-scope"></a>
## 적용 대상

- iOS 네이티브 앱 (Swift, Objective-C)
- Flutter 앱(iOS 빌드)
- WKWebView를 포함한 하이브리드 앱

---

<a id="prerequisites"></a>
## 사전 준비

연동을 시작하기 전에 아래 항목을 준비해주세요.

- Groobee 어드민 사이트 접속용 계정  
  계정이 없는 경우 영업팀에 문의해주세요.  
  👉 [Groobee 사이트 링크](https://groobee.net/)
- 앱에서 사용할 Groobee 서비스키
- 어드민 사이트에 앱 Bundle ID / 플랫폼 정보 등록  
  👉 [앱 정보 등록 가이드](../prerequisites/app-name-registration.md)
- 푸시를 사용할 경우 Firebase 프로젝트 설정과 Firebase 비공개키 등록
- APNS 인증 키(`.p8`), Key ID, Team ID
- Xcode에서 Push Notifications, Background Modes 설정 권한
- Rich Push를 사용할 경우 Notification Service Extension, Notification Content Extension 추가 계획
- Flutter 앱인 경우 `ios/Runner/GoogleService-Info.plist` 준비 및 iOS 모듈 편집 환경(Xcode, CocoaPods) 확인

---

<a id="implementation-choice"></a>
## 구현 방식 선택

### [1. iOS Native SDK 설치 가이드](../installation/installation-ios-sdk.md)

iOS 네이티브 앱(Swift, Objective-C)에서 Groobee SDK(`GroobeeKit`)를 직접 연동하는 경우의 상세 가이드입니다.

### [2. iOS Flutter SDK 설치 가이드](../installation/installation-ios-flutter-sdk.md)

Flutter 앱의 iOS 모듈에 Groobee SDK를 설치하고 `MethodChannel`로 연결하는 경우의 상세 가이드입니다.

---

<a id="installation-docs"></a>
## 설치 문서

Groobee iOS SDK 설치는 다음 순서로 진행하는 것을 권장합니다.

### 1. SDK 설치

네이티브 앱은 [iOS Native SDK 설치 가이드](../installation/installation-ios-sdk.md), Flutter 앱은 [iOS Flutter SDK 설치 가이드](../installation/installation-ios-flutter-sdk.md) 문서의 **SDK 설치** 섹션을 참고하세요.

`Podfile`에 `GroobeeKit`, `FirebaseMessaging` 등을 추가하고 `pod install`을 수행합니다. Flutter 앱은 `pubspec.yaml`에 Firebase 패키지를 추가한 뒤 `flutter pub get` → `pod install` 순서로 진행합니다.

### 2. AppDelegate 초기화 설정

네이티브 앱은 [iOS Native SDK 설치 가이드](../installation/installation-ios-sdk.md), Flutter 앱은 [iOS Flutter SDK 설치 가이드](../installation/installation-ios-flutter-sdk.md) 문서의 **AppDelegate 설정** 섹션을 참고하세요.

서비스키, `GroobeeConfig`, Firebase 초기화, 푸시 권한 요청을 `AppDelegate`에 설정합니다. Flutter 앱은 `FlutterAppDelegate` 상속과 `GeneratedPluginRegistrant` 등록이 추가로 필요합니다.

### 3. LifeCycle 설정

네이티브 앱은 [iOS Native SDK 설치 가이드](../installation/installation-ios-sdk.md), Flutter 앱은 [iOS Flutter SDK 설치 가이드](../installation/installation-ios-flutter-sdk.md) 문서의 **LifeCycle 설정** 섹션을 참고하세요.

iOS 13 미만과 iOS 13 이상에 맞춰 `GroobeeKitLifeCycle` 메소드를 연결합니다.

### 4. Push Messaging Service 설정

네이티브 앱은 [iOS Native SDK 설치 가이드](../installation/installation-ios-sdk.md), Flutter 앱은 [iOS Flutter SDK 설치 가이드](../installation/installation-ios-flutter-sdk.md) 문서의 **Push Messaging Service 설정** 섹션을 참고하세요.

Firebase 콘솔에서 APNS 인증 키를 업로드하고, `AppDelegate`에 FCM/APNS 연동 코드를 추가합니다.

### 5. Rich Push 설정

네이티브 앱은 [iOS Native SDK 설치 가이드](../installation/installation-ios-sdk.md), Flutter 앱은 [iOS Flutter SDK 설치 가이드](../installation/installation-ios-flutter-sdk.md) 문서의 **Rich Push 설정** 섹션을 참고하세요.

`Notification Service Extension`, `Notification Content Extension`, `Info.plist`, 알림 확장 코드를 설정합니다.

### 6. 주요 SDK 메소드 연동

Flutter 앱은 [Flutter MethodChannel 연동](../detail/ios-flutter-method-channel.md) 문서를 추가로 참고해 Dart와 iOS 모듈 사이 브리지를 구현합니다.

회원 정보, 푸시 동의, 상품 행동 이력, 하이브리드 동기화, 추천 상품 API를 서비스 흐름에 맞게 연동합니다.

---

<a id="detail-docs"></a>
## 상세 사용 문서

설치가 끝난 뒤 기능별 연동은 아래 문서를 참고하세요. 각 챕터는 그루비의 특정 기능을 활성화하기 위한 것이며, 연동하지 않으면 해당 기능을 사용할 수 없거나 데이터가 부정확하게 쌓일 수 있습니다.

### [iOS SDK 개요 및 지원 범위](../detail/ios-sdk-overview.md)

SDK 안내, 캠페인 설명, 어드민 체크리스트, iOS 버전 이슈를 정리한 문서입니다.

- **왜 필요한가**: 이후 연동할 기능들이 어떤 캠페인 시나리오와 연결되는지 전체 그림을 먼저 잡으면, 불필요한 연동 범위를 줄이고 필수 항목부터 우선순위를 정할 수 있습니다. iOS 13 이전/이후 푸시 수신 이벤트 차이도 여기서 확인하세요.

### [회원 정보 및 푸시 상태 연동](../detail/ios-sdk-member-push.md)

로그인, 유저정보, 회원가입, 푸시 토큰, 푸시 동의 상태 연동을 정리한 문서입니다.

- **왜 필요한가**: 그루비가 **회원을 식별**하고 개인화 메시지를 발송하기 위한 기본 연동입니다. 미연동 시 로그인 사용자도 비회원으로 집계되며, 푸시 토큰 미전달 시 해당 기기는 푸시 발송 대상에서 제외됩니다. 광고/야간 동의 같은 정책성 동의 상태도 함께 전달되어야 전송 규제(예: 21시 이후 야간 발송)를 위반하지 않습니다.

### [행동 이력 수집](../detail/ios-sdk-actions.md)

검색, 상품 상세, 장바구니, 주문, 카테고리, 커스텀 이벤트 연동을 정리한 문서입니다.

- **왜 필요한가**: 세그먼트, 트리거 인앱메시지, AI 추천, 전환 측정 모두 **사용자 행동 이력**을 기반으로 동작합니다. 미연동 시 "장바구니 이탈 사용자" 같은 시나리오성 캠페인이나 구매 전환 측정이 불가능합니다.

### [하이브리드 앱 데이터 동기화](../detail/ios-sdk-hybrid-sync.md)

`getGroobeeWebCookies()`, `setWebViewCookies()`로 앱과 웹의 사용자를 동일하게 식별하도록 동기화하는 방법을 정리한 문서입니다.

- **왜 필요한가**: 그루비는 자체 발급 쿠키로 사용자를 식별하는데, 하이브리드 앱에서는 앱 내부 저장소와 `WKWebView`의 `WKHTTPCookieStore`가 분리되어 있어 **동기화를 하지 않으면 같은 사용자가 두 명으로 집계**됩니다. 세그먼트·통계·추천이 모두 왜곡되므로 WKWebView를 포함한 하이브리드 앱이라면 필수입니다.

### [추천 상품 연동](../detail/ios-sdk-recommend.md)

추천 캠페인키 기반 상품 조회와 노출/클릭 통계 연동을 정리한 문서입니다.

- **왜 필요한가**: Groobee AI 추천을 앱 화면에 노출하려면 이 API를 통해 상품 리스트를 요청해야 합니다. 노출/클릭 통계를 함께 보내야 추천 알고리즘의 성능 지표가 집계되고 이후 추천 품질이 개선됩니다.

### [주의사항 및 로그 유틸리티](../detail/ios-sdk-cautions-log.md)

WebView에서 InAppMessage 사용 시 주의사항과 `LoggerUtils` 사용법을 정리한 문서입니다.

- **왜 필요한가**: `rootView`를 `WKWebView`로 직접 지정하면 InAppMessage와 WebView가 모두 검은 화면으로 표시되는 알려진 이슈가 있습니다. 연동 중 로그를 볼 때도 `LoggerUtils` 옵션을 알고 있어야 문제 원인을 빠르게 좁힐 수 있습니다.

### [Flutter MethodChannel 연동](../detail/ios-flutter-method-channel.md)

Flutter 앱에서 Dart와 iOS 모듈을 `MethodChannel`로 연결하는 브리지 구현 문서입니다.

- **왜 필요한가**: Flutter 앱은 `GroobeeKit`을 iOS 네이티브에서 직접 호출할 수 없기 때문에, Dart ↔ iOS 사이에 `MethodChannel` 브리지를 만들어야 위의 모든 기능(회원·행동·동기화·추천)을 Flutter 쪽에서 호출할 수 있습니다. 네이티브 앱이라면 이 챕터는 생략해도 됩니다.

---

<a id="next-steps"></a>
## 다음 단계

네이티브 앱은 [iOS Native SDK 설치 가이드](../installation/installation-ios-sdk.md), Flutter 앱은 [iOS Flutter SDK 설치 가이드](../installation/installation-ios-flutter-sdk.md)로 설치를 진행한 뒤, [상세 가이드 목록](../detail/README.md)에서 기능별 문서를 확인하는 흐름을 권장합니다.

버전별 변경 사항은 [iOS SDK 변경 로그](../changelog/sdk-ios-changelog.md)를 참고해주세요.

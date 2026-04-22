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

설치가 끝난 뒤 기능별 연동은 아래 문서를 참고하세요.

### [iOS SDK 개요 및 지원 범위](../detail/ios-sdk-overview.md)

SDK 안내, 캠페인 설명, 어드민 체크리스트, iOS 버전 이슈를 정리한 문서입니다.

### [회원 정보 및 푸시 상태 연동](../detail/ios-sdk-member-push.md)

로그인, 유저정보, 회원가입, 푸시 토큰, 푸시 동의 상태 연동을 정리한 문서입니다.

### [행동 이력 수집](../detail/ios-sdk-actions.md)

검색, 상품 상세, 장바구니, 주문, 카테고리, 커스텀 이벤트 연동을 정리한 문서입니다.

### [하이브리드 앱 데이터 동기화](../detail/ios-sdk-hybrid-sync.md)

`getGroobeeWebCookies()`, `setWebViewCookies()` 사용 방법을 정리한 문서입니다.

### [추천 상품 연동](../detail/ios-sdk-recommend.md)

추천 캠페인키, 추천 상품 조회, 노출/클릭 통계 연동을 정리한 문서입니다.

### [주의사항 및 로그 유틸리티](../detail/ios-sdk-cautions-log.md)

WebView에서 InAppMessage 사용 시 주의사항과 `LoggerUtils` 사용법을 정리한 문서입니다.

### [Flutter MethodChannel 연동](../detail/ios-flutter-method-channel.md)

Flutter 앱에서 Dart와 iOS 모듈을 `MethodChannel`로 연결하는 브리지 구현 문서입니다.

---

<a id="next-steps"></a>
## 다음 단계

네이티브 앱은 [iOS Native SDK 설치 가이드](../installation/installation-ios-sdk.md), Flutter 앱은 [iOS Flutter SDK 설치 가이드](../installation/installation-ios-flutter-sdk.md)로 설치를 진행한 뒤, [상세 가이드 목록](../detail/README.md)에서 기능별 문서를 확인하는 흐름을 권장합니다.

버전별 변경 사항은 [iOS SDK 변경 로그](../changelog/sdk-ios-changelog.md)를 참고해주세요.

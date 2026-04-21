# iOS SDK 설치 시작하기

이 문서는 iOS 앱에 Groobee SDK를 연동하기 전에 확인해야 할 준비사항과 문서 구조를 안내합니다. Swift, Objective-C, WKWebView 기반 하이브리드 앱을 대상으로 합니다.

---

## 적용 대상

- iOS 네이티브 앱
- Swift 기반 앱
- Objective-C 기반 앱
- WKWebView를 포함한 하이브리드 앱

---

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

---

## 설치 문서

iOS SDK 설치는 아래 순서로 진행합니다.

### 1. SDK 설치

[iOS SDK 설치 가이드](../installation/installation-ios-sdk.md#sdk-install)를 참고하세요.

`Podfile`에 `GroobeeKit`, `FirebaseMessaging` 등을 추가하고 `pod install`을 수행합니다.

### 2. AppDelegate 초기화 설정

[AppDelegate 설정](../installation/installation-ios-sdk.md#appdelegate-config)을 참고하세요.

서비스키, `GroobeeConfig`, Firebase 초기화, 푸시 권한 요청을 `AppDelegate`에 설정합니다.

### 3. LifeCycle 설정

[LifeCycle 설정](../installation/installation-ios-sdk.md#lifecycle-config)을 참고하세요.

iOS 13 미만과 iOS 13 이상에 맞춰 `GroobeeKitLifeCycle` 메소드를 연결합니다.

### 4. Push Messaging Service 설정

[Push Messaging Service 설정](../installation/installation-ios-sdk.md#push-service)을 참고하세요.

Firebase 콘솔에서 APNS 인증 키를 업로드하고, `AppDelegate`에 FCM/APNS 연동 코드를 추가합니다.

### 5. Rich Push 설정

[Rich Push 설정](../installation/installation-ios-sdk.md#rich-push)을 참고하세요.

`Notification Service Extension`, `Notification Content Extension`, `Info.plist`, 알림 확장 코드를 설정합니다.

---

## 상세 사용 문서

설치가 끝난 뒤 기능별 연동은 아래 문서를 참고하세요.

### [iOS SDK 개요 및 지원 범위](../detail/ios-sdk-overview.md)

SDK 안내, 캠페인 설명, 어드민 체크리스트, iOS 버전 이슈를 정리한 문서입니다.

### [회원 정보 및 푸시 상태 연동](../detail/ios-sdk-member-push.md)

로그인, 유저정보, 회원가입, 푸시 토큰, 푸시 동의 상태 연동을 정리한 문서입니다.

### [화면 이벤트 및 행동 이력 연동](../detail/ios-sdk-screen-events.md)

검색, 상품 상세, 장바구니, 주문, 카테고리, 커스텀 이벤트 연동을 정리한 문서입니다.

### [하이브리드 앱 데이터 동기화](../detail/ios-sdk-hybrid-sync.md)

`getGroobeeWebCookies()`, `setWebViewCookies()` 사용 방법을 정리한 문서입니다.

### [추천 상품 연동](../detail/ios-sdk-recommend.md)

추천 캠페인키, 추천 상품 조회, 노출/클릭 통계 연동을 정리한 문서입니다.

### [주의사항 및 로그 유틸리티](../detail/ios-sdk-cautions-log.md)

WebView에서 InAppMessage 사용 시 주의사항과 `LoggerUtils` 사용법을 정리한 문서입니다.

---

## 다음 단계

[iOS SDK 설치 가이드](../installation/installation-ios-sdk.md)로 설치를 진행한 뒤, [상세 가이드 목록](../detail/README.md)에서 기능별 문서를 확인하는 흐름을 권장합니다.

버전별 변경 사항은 [iOS SDK 변경 로그](../changelog/sdk-ios-changelog.md)를 참고해주세요.

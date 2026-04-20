# Android SDK 설치 시작하기

이 문서는 Android 앱에 Groobee SDK를 연동하기 전에 확인해야 할 준비사항과 문서 구조를 안내합니다. Android 네이티브 앱과 Flutter 앱(Android 빌드) 모두를 대상으로 합니다.

---

## 적용 대상

- Android 네이티브 앱
- Flutter 앱(Android 빌드)
- WebView를 포함한 하이브리드 앱

---

## 사전 준비

연동을 시작하기 전에 아래 항목을 준비해주세요.

- Groobee 어드민 사이트 접속용 계정  
  계정이 없는 경우 영업팀에 문의해주세요.  
  👉 [Groobee 사이트 링크](https://groobee.net/)
- 앱에서 사용할 Groobee 서비스키
- 어드민 사이트에 앱 패키지명 등록  
  👉 [앱 패키지명 등록 가이드](../prerequisites/app-name-registration.md)
- 어드민 사이트에 사용 플랫폼 정보 등록  
  👉 [사용 플랫폼 정보 등록 가이드](../prerequisites/app-platform-registration.md)
- 푸시를 사용할 경우 Firebase 프로젝트 설정과 Firebase 비공개키 등록
- Flutter 앱인 경우 `google-services.json` 준비 및 Android 모듈 편집 환경 확인
- 하이브리드 앱인 경우 데이터 동기화 방향 결정  
  웹뷰 중심 앱은 `syncWebToNative`, 네이티브 중심 앱은 `syncNativeToWeb`를 사용합니다.

---

## 구현 방식 선택

### [1. Android Native SDK 설치 가이드](../installation/installation-android-sdk.md)

Android 네이티브 앱에서 Groobee SDK를 직접 연동하는 경우의 상세 가이드입니다.

### [2. Android Flutter SDK 설치 가이드](../installation/installation-android-flutter-sdk.md)

Flutter 앱의 Android 모듈에 Groobee SDK를 설치하고 `MethodChannel`로 연결하는 경우의 상세 가이드입니다.

---

## 설치 문서

Groobee Android SDK 설치는 다음 순서로 진행하는 것을 권장합니다.

### 1. SDK 의존성 추가

네이티브 앱은 [Native SDK 설치](../installation/installation-android-sdk.md#sdk-install), Flutter 앱은 [Flutter SDK 설치](../installation/installation-android-flutter-sdk.md#flutter-install) 문서를 참고하세요.

프로젝트 구조에 맞게 Gradle 저장소, 앱 모듈 의존성, Flutter Firebase 의존성을 설정합니다.

### 2. Application 초기화 설정

네이티브 앱은 [Native Application 설정](../installation/installation-android-sdk.md#application-config), Flutter 앱은 [Flutter Application 설정](../installation/installation-android-flutter-sdk.md#application-config) 문서를 참고하세요.

`Application` 클래스에서 서비스키, 푸시 옵션, 라이프사이클 콜백, Firebase 초기화를 설정합니다.

### 3. Push Messaging Service 등록

네이티브 앱은 [Native Push Service 설정](../installation/installation-android-sdk.md#push-service), Flutter 앱은 [Flutter Push Service 설정](../installation/installation-android-flutter-sdk.md#push-service) 문서를 참고하세요.

기본 `GroobeeFirebaseMessagingService`를 `AndroidManifest.xml`에 등록하거나,
기존 `FirebaseMessagingService`가 있다면 Groobee 핸들러를 연결합니다.

### 4. 주요 SDK 메소드 연동

네이티브 앱은 [Native SDK 메소드](../installation/installation-android-sdk.md#sdk-methods), Flutter 앱은 [Flutter MethodChannel 연동](../installation/installation-android-flutter-sdk.md#method-channel)과 [Flutter SDK 메소드 적용](../installation/installation-android-flutter-sdk.md#sdk-methods) 문서를 참고하세요.

회원 정보, 푸시 동의, 상품 행동 이력, 하이브리드 동기화, 추천 상품 API를 서비스 흐름에 맞게 연동합니다.

### 5. Android 공통 추가 설정

Android 13 알림 권한, 잠금 상태 푸시 수신, ProGuard 설정은 [Android 공통 추가 설정](../installation/installation-android-common-settings.md)을 참고하세요.

Flutter 앱도 Android 빌드 결과물 기준으로 동일한 권한 및 난독화 설정이 적용됩니다.

---

## 상세 사용 문서

설치가 끝난 뒤 기능별 연동은 아래 문서를 참고하세요.

### [Android SDK 개요 및 캠페인](../detail/android-sdk-overview.md)

인앱메시지, 푸시 알림 캠페인, SDK 체크리스트, 어드민 설정 정보를 정리한 문서입니다.

### [회원 정보 및 푸시 상태 연동](../detail/android-sdk-member-push.md)

로그인, 로그아웃, 회원 속성, 푸시 토큰, 푸시 동의 상태 연동을 정리한 문서입니다.

### [화면 이벤트 및 행동 이력 연동](../detail/android-sdk-screen-events.md)

검색, 상품 상세, 장바구니, 주문, 카테고리, 커스텀 이벤트 연동을 정리한 문서입니다.

### [하이브리드 앱 데이터 동기화](../detail/android-sdk-hybrid-sync.md)

WebView 중심/네이티브 중심 앱에서의 데이터 동기화 방법을 정리한 문서입니다.

### [추천 상품 연동](../detail/android-sdk-recommend.md)

추천 캠페인키, 추천 상품 조회, 노출/클릭 통계 연동을 정리한 문서입니다.

### [Flutter MethodChannel 연동](../detail/android-flutter-method-channel.md)

Flutter 앱에서 Dart와 Android 모듈을 연결하는 브리지 구현 문서입니다.

---

## 다음 단계

네이티브 앱은 [Android Native SDK 설치 가이드](../installation/installation-android-sdk.md), Flutter 앱은 [Android Flutter SDK 설치 가이드](../installation/installation-android-flutter-sdk.md)로 설치를 진행한 뒤, [상세 가이드 목록](../detail/README.md)에서 기능별 문서를 확인하는 흐름을 권장합니다.

버전별 변경 사항은 [Android SDK 변경 로그](../changelog/sdk-android-changelog.md)를 참고해주세요.

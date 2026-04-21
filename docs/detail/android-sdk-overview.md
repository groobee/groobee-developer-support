# Android SDK 개요 및 캠페인

이 문서는 Android Native SDK와 Flutter Android SDK 공통 기준으로 Groobee Android SDK의 개요, 지원 캠페인, 어드민 설정 체크리스트를 정리한 문서입니다.

---

## 목차

1. [SDK가 제공하는 캠페인](#campaigns)
2. [SDK 기본 정보](#sdk-info)
3. [어드민 설정 체크리스트](#admin-checklist)
4. [어드민 설정 방법](#admin-setup)
5. [어떤 문서를 먼저 보면 되는가](#getting-started)

---

<a id="campaigns"></a>
## SDK가 제공하는 캠페인

Groobee Android SDK를 설치하면 모바일 앱에서 아래 두 가지 캠페인 영역을 사용할 수 있습니다.

### 온사이트 캠페인: 인앱메시지

- AI 세그먼트 또는 일반 세그먼트를 통해 선별된 사용자에게 앱 내부에서 실시간 인앱메시지를 노출할 수 있습니다.
- 화면 진입, 상품 조회, 주문 완료 같은 행동 데이터와 연결해 트리거 메시지를 구성할 수 있습니다.

### 오프사이트 캠페인: 푸시 알림

- AI 세그먼트 또는 일반 세그먼트를 통해 선별된 사용자에게 푸시 메시지를 발송할 수 있습니다.
- Android 푸시는 FCM(Firebase Cloud Messaging) 기반으로 동작합니다.

<a id="sdk-info"></a>
## SDK 기본 정보

| 항목 | 내용 |
| --- | --- |
| 플랫폼 | Android |
| SDK 버전 기준 문서 | 1.0.80 |
| 대략적인 SDK 크기 | 약 2MB |
| 최소 지원 버전 | API 16 (Jelly Bean) |
| 푸시 연동 방식 | FCM 기반 |

참고 문서:

- [Android Native SDK 설치 가이드](../installation/installation-android-sdk.md)
- [Android Flutter SDK 설치 가이드](../installation/installation-android-flutter-sdk.md)
- [Android SDK 변경 로그](../changelog/sdk-android-changelog.md)
- [Android SDK 기능 지원 범위](../changelog/sdk-android-feature-support.md)

<a id="admin-checklist"></a>
## 어드민 설정 체크리스트

PDF 원문 기준으로 Android SDK 연동 전에 아래 항목을 점검해야 합니다.

| 구분 | 항목 | 필수 여부 |
| --- | --- | --- |
| 어드민 설정 | 패키지명 등록 | 필수 |
| 어드민 설정 | Firebase 비공개키 등록 | 푸시 사용 시 필수 |
| 앱 기본 설정 | `Application` 초기화 | 필수 |
| 앱 기본 설정 | WebView 데이터 동기화 | WebView 기반 앱인 경우 필수 |
| 회원 데이터 | 유저 로그인 | 선택 |
| 회원 데이터 | 유저 정보 | 선택 |
| 회원 데이터 | 회원가입 완료 | 선택 |
| 푸시 데이터 | Push Token | 푸시 사용 시 필수 |
| 푸시 데이터 | 푸시 사용 동의 | 푸시 사용 시 필수 |
| 푸시 데이터 | 광고 수신 동의 | 푸시 사용 시 필수 |
| 푸시 데이터 | 야간 수신 동의 | 푸시 사용 시 필수 |
| 행동 데이터 | 검색 키워드 | 선택 |
| 행동 데이터 | 상품 상세 | 선택 |
| 행동 데이터 | 장바구니 | 선택 |
| 행동 데이터 | 주문하기 | 선택 |
| 행동 데이터 | 주문 완료 | 선택 |
| 행동 데이터 | 카테고리 | 선택 |
| 행동 데이터 | 기타 화면 정보 | 선택 |

<a id="admin-setup"></a>
## 어드민 설정 방법

### 1. SDK 설정 화면 진입

- Groobee 어드민에서 `설정 > SDK 설정` 메뉴로 이동합니다.

### 2. Firebase 비공개키 업로드

- 푸시 메시지를 사용할 경우 Firebase 비공개키를 업로드해야 합니다.
- 비공개키가 등록되지 않으면 푸시 캠페인을 정상적으로 운영할 수 없습니다.

### 3. 앱 패키지명 등록

- 연동할 앱의 패키지명을 입력합니다.
- 패키지명은 SDK 인증 과정에도 사용되므로 오타 없이 정확히 등록해야 합니다.
- 등록 방법은 [앱 패키지명 등록 가이드](../prerequisites/app-name-registration.md)를 참고하세요.

<a id="getting-started"></a>
## 어떤 문서를 먼저 보면 되는가

설치부터 시작하려면:

- [Android Native SDK 설치 가이드](../installation/installation-android-sdk.md)
- [Android Flutter SDK 설치 가이드](../installation/installation-android-flutter-sdk.md)
- [Android 공통 추가 설정](../installation/installation-android-common-settings.md)

설치 후 기능별 연동을 진행하려면:

- [회원 정보 및 푸시 상태 연동](./android-sdk-member-push.md)
- [화면 이벤트 및 행동 이력 연동](./android-sdk-screen-events.md)
- [하이브리드 앱 데이터 동기화](./android-sdk-hybrid-sync.md)
- [추천 상품 연동](./android-sdk-recommend.md)
- Flutter 앱인 경우 [Flutter MethodChannel 연동](./android-flutter-method-channel.md)

# iOS SDK 개요 및 지원 범위

---

## 목차

1. [SDK가 제공하는 캠페인](#campaigns)
2. [SDK 버전 / 사이즈](#sdk-version)
3. [SDK 설정 등록](#sdk-configuration)
4. [iOS 버전 이슈](#ios-version-issue)
5. [함께 보면 좋은 문서](#related-docs)

---

<a id="campaigns"></a>
## SDK가 제공하는 캠페인

그루비에서 제공하는 SDK를 설치하면 그루비 서비스 중 2가지 서비스를 추가하여 사용할 수 있습니다.

### 온사이트 캠페인: 인앱메시지

AI 세그먼트, 세그먼트를 통해 선별된 사용자에게 네이티브 영역에서 실시간 인앱메시지를 전송합니다.

### 푸시 알림 캠페인

AI 세그먼트, 세그먼트를 통해 선별된 사용자에게 푸시메시지를 전송합니다.

그루비는 FCM(Firebase Cloud Messaging) 기반의 Android, iOS 발송 시스템을 지원합니다.

<a id="sdk-version"></a>
## SDK 사이즈 및 지원 범위

그루비 SDK는 모바일 앱에 설치되어 사용자 행동패턴 분석과 전환율 측정, 마케팅을 위한 기능을 제공합니다.

| 플랫폼 | 대략적인 SDK 크기 | 최소 지원 버전 |
| --- | --- | --- |
| iOS | `4MB` | `iOS 10` |

현재 권장 SDK 버전은 [iOS SDK 변경 로그](../changelog/sdk-ios-changelog.md)에서 확인하세요.

<a id="sdk-configuration"></a>
## SDK 설정 등록

### SDK 연동 체크리스트

| 구분 | 항목 | 필수 여부 |
| --- | --- | --- |
| 그루비 어드민 설정 | Firebase 비공개키 등록 | 푸시 사용 시 필수 |
| 그루비 어드민 설정 | 패키지명 등록 | 필수 |
| 앱 기본 설정 | AppDelegate 설정 | 필수 |
| 앱 기본 설정 | 웹뷰 데이터 동기화 | WebView 기반 앱일 경우 필수 |
| 앱 메소드 설정 | 유저 로그인 | 선택 |
| 앱 메소드 설정 | 유저정보 | 선택 |
| 앱 메소드 설정 | 회원가입 완료 | 선택 |
| 앱 메소드 설정 | Push Token | 푸시 사용 시 필수 |
| 앱 메소드 설정 | 푸시 사용 동의 | 푸시 사용 시 필수 |
| 앱 메소드 설정 | 광고 수신 동의 | 푸시 사용 시 필수 |
| 앱 메소드 설정 | 야간 수신 동의 | 푸시 사용 시 필수 |
| 앱 메소드 설정 | 검색 키워드 | 선택 |
| 앱 메소드 설정 | 상품상세 | 선택 |
| 앱 메소드 설정 | 장바구니 | 선택 |
| 앱 메소드 설정 | 주문하기 | 선택 |
| 앱 메소드 설정 | 주문완료 | 선택 |
| 앱 메소드 설정 | 카테고리 | 선택 |
| 앱 메소드 설정 | 기타 화면 정보 | 선택 |

### 어드민 설정 방법

1. Admin 화면에서 `설정 > SDK 설정`을 선택해 SDK 설정 화면에 진입합니다.
2. Push Message를 이용할 경우 Firebase 비공개키를 업로드합니다.
3. 연동할 앱의 Bundle ID를 입력합니다.

참고:

- Firebase 설정 가이드: [Groobee Firebase 가이드](http://doc.groobee.io/article/3pek95zvoz-firebase)
- 앱 Bundle ID 등록 문서: [앱 정보 등록](../prerequisites/app-name-registration.md)

<a id="ios-version-issue"></a>
## iOS 버전 이슈

버전별 SDK 기능 이슈는 다음 표와 같습니다.

| SDK 연동 버전 | Push Open | Push Receive | InAppMessage |
| --- | --- | --- | --- |
| iOS 13 미만 | O | △ | O |
| iOS 13 이상 | O | O | O |

그루비 SDK의 인앱메시지는 iOS 버전에 상관없이 노출/클릭에 대한 서비스를 제공합니다.

### iOS 13 미만

iOS 13 미만 버전의 경우 Push Receive 이벤트를 지원하기 전 단계의 버전이므로 Background 모드인 경우와 Foreground 모드인 경우에 맞춰 이벤트 발생 여부가 결정됩니다.  
따라서 Push 메시지 수신 여부에 대한 정확한 값을 가질 수 없으며, 수신 여부 데이터의 유효성을 판단할 수 없습니다.

### iOS 13 이상

iOS 13 이상 버전은 Push 메시지 이벤트가 지원되는 버전이므로 수신/클릭 여부에 대해 보다 정확한 데이터를 얻을 수 있습니다.

<a id="related-docs"></a>
## 함께 보면 좋은 문서

- [iOS SDK 설치 가이드](../installation/installation-ios-sdk.md)
- [iOS SDK 회원 정보 및 푸시 상태 연동](./ios-sdk-member-push.md)
- [iOS SDK 행동 이력 수집](./ios-sdk-actions.md)
- [iOS SDK 하이브리드 앱 데이터 동기화](./ios-sdk-hybrid-sync.md)
- [iOS SDK 추천 상품 연동](./ios-sdk-recommend.md)

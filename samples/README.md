# Groobee 연동 샘플

Groobee SDK / 스크립트 적용 예제 모음입니다.
각 샘플은 설치 가이드 문서와 짝을 이루며, 실제 SDK 호출 코드를 그대로 확인할 수 있습니다.

## 앱 (`app/`)

| 샘플 | 설명 | 정식 SDK |
| --- | --- | --- |
| [android-kotlin](app/android-kotlin) | Android(Kotlin) 네이티브 데모 | `io.groobee.message:groobee-sdk-message:1.0.83` (Maven Central) |
| [ios-swift](app/ios-swift) | iOS(Swift) 네이티브 데모 | `pod 'GroobeeKit', '~> 1.1.6'` (CocoaPods) |
| [flutter](app/flutter) | Flutter(Dart) 데모 — MethodChannel 브리지 | 위 두 네이티브 SDK 를 그대로 사용 |

세 샘플 모두 단일 화면에서 다음을 버튼 단위로 시연합니다.

- **회원/로그인** — 로그인·로그아웃·회원정보·회원가입 완료·동의 동기화
- **푸시** — FCM 토큰 전달, 전체/광고/야간 동의, 동의 상태 조회
- **행동 이력** — 검색·상품 상세·카테고리·장바구니·주문·주문완료·커스텀 이벤트
- **AI 추천** — 추천 상품 요청 + 노출/클릭 통계

> 각 폴더의 `README.md` 에 서비스키 입력, 푸시(Firebase) 설정, 빌드/실행 방법이 정리되어 있습니다.

## 웹 (`web/`)

웹은 SDK 가 아닌 스크립트 방식으로 연동합니다.

| 샘플 | 설명 |
| --- | --- |
| [vanilla](web/vanilla) | 일반(비 SPA) 웹 데모 — 페이지 전체 로드마다 자동 실행, `groobee("행동코드", 데이터)` 직접 호출, 추천 DIV형/데이터요청형 |
| [react](web/react) | React SPA 데모 — `isSPA` 모드, 라우트 전환마다 `start()`/`action()`, 회원 메타, AI 추천(DI/CL) |

- [Web 스크립트 설치 가이드](../docs/installation/installation-web-common-script.md)

## 관련 문서

- [빠른 시작 — Android](../docs/getting-started/gettingstart-aos.md) ·
  [iOS](../docs/getting-started/gettingstart-ios.md) ·
  [Web](../docs/getting-started/gettingstart-web.md)
- [설치 가이드 개요](../docs/installation/README.md)

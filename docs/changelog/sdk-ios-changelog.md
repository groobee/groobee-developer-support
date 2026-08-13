# iOS SDK - 변경 로그 (Changelog)

이 문서는 Groobee iOS SDK의 버전별 변경 사항을 기록합니다.

## 현재 권장 버전 (Stable)

- 1.1.11

---

## [1.1.12] - 2026-08-13
* add: 네이티브 → 웹뷰 동기화 메소드 **`syncNativeToWeb(_ domain:)`** 신설.
* add: 하이브리드 동기화 메소드 호출시 최근 본 상품 목록을 함께 전달하도록 추가 (`syncWebToNative(webView:urlRequest:)`, `syncNativeToWeb(_ domain:)`)
* 관련 변경 페이지: [iOS SDK 하이브리드 앱 데이터 동기화](../detail/ios-sdk-hybrid-sync.md)
 
> ⚠️ **iOS 11 미만에서는 동작하지 않습니다.** `WKWebView`의 쿠키 저장소에 접근할 공개 API가 없어 쓰기(`syncNativeToWeb`)와 읽기(`syncWebToNative`) 모두 동작하지 않으며, SDK가 경고 로그를 남깁니다.

---

## [1.1.11] - 2026-07-27
* fix: 팝업 인앱 메시지의 이미지를 불러오지 못했을 때 앱이 종료되던 문제 수정
* fix: 인앱 메시지의 닫기 버튼 이미지를 불러오지 못했을 때 버튼이 보이지 않아 메시지를 닫을 수 없던 문제 수정 (기본 닫기 아이콘으로 대체)
* change: 인앱 메시지 노출 통계를 표시 시도 시점이 아니라 **실제 화면에 표시된 경우에만** 전송하도록 변경

변경 요약: 팝업 이미지 로드 실패 시 잘못된 레이아웃 계산으로 앱이 종료되던 문제를 수정했습니다. 이미지를 불러오지 못하면 팝업을 표시하지 않으며, 이 경우 노출 통계를 전송하지 않으므로 해당 캠페인은 이후 다시 발행됩니다. 앱 코드 수정 없이 SDK 버전만 올리면 적용됩니다.

> **통계 리포트 참고**: 이번 버전이 적용된 단말이 늘어남에 따라 인앱 메시지 **노출수와 클릭수가 감소**할 수 있습니다. 표시되지 않은 노출과 중복 집계된 클릭이 제외되면서 수치가 정확해지는 것이며, 실제 캠페인 성과가 하락한 것은 아닙니다.

---

## [1.1.10] - 2026-06-25
* fix: 배포 패키지에 누락되어 있던 dSYM 파일을 포함하도록 수정

---

## [1.1.8] - 2026-06-11
* fix: 알림 메시지에서 알림 설정 버튼을 눌렀을 떄 웹 브라우저 링크도 열 수 있도록 수정

---

## [1.1.6] - 2026-04-30
* fix: 웹-네이티브 동기화 중 입력되는 데이터는 동기화 이후에 처리되도록 변경

---

## [1.1.5] - 2026-04-20

* Add: 정보통신망법 7차 개정안 대응 기능 추가: 알림 메시지에서 바로 알림 설정 페이지로 이동하는 딥링크 지원 ([KISA 안내](https://www.kisa.or.kr/401/form?postSeq=3608&lang_type=KO))

관련 변경 페이지:

- [iOS Native SDK 설치 가이드 - AppDelegate 설정](../installation/installation-ios-sdk.md#appdelegate-config): `GroobeeConfigBuilder.setNotificationSettingsButton()` 예시와 주요 설정 항목 설명이 추가되었습니다. 버튼 텍스트와 앱 알림 설정 화면으로 이동할 딥링크를 설정합니다.
- [iOS Native SDK 설치 가이드 - FCM과 GroobeeKit 간 메시지 연동](../installation/installation-ios-sdk.md#ios-fcm-groobee-message-linkage): `UNNotificationResponse`를 SDK에 전달하면 일반 푸시 본체 탭과 알림 설정 액션 탭을 함께 처리할 수 있도록 예시가 변경되었습니다.
- [iOS Flutter SDK 설치 가이드 - AppDelegate 설정](../installation/installation-ios-flutter-sdk.md#appdelegate-config): Flutter iOS 앱의 `AppDelegate` 초기화 예시에 동일한 알림 설정 버튼/딥링크 설정이 추가되었습니다.
- [iOS SDK 기능 지원 범위](./sdk-ios-feature-support.md): 초기 설정 기능 목록에 `setNotificationSettingsButton` 기반의 `푸시 알림 수신 설정 버튼` 지원 항목이 추가되었습니다.

변경 요약: 푸시 알림 하단에 알림 수신 설정 버튼을 표시하고, 사용자가 버튼을 누르면 앱에서 정의한 알림 설정 화면 딥링크로 이동할 수 있도록 `setNotificationSettingsButton()` 설정이 추가되었습니다. v.1.1.5 이상에서는 알림 응답을 SDK에 전달해 일반 푸시 본체 탭과 알림 설정 액션 탭을 함께 처리할 수 있으며, 앱에서는 해당 딥링크 라우팅과 알림 수신 동의 화면/상태 동기화를 함께 구현해야 합니다.

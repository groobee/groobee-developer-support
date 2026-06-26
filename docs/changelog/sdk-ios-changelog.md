# iOS SDK - 변경 로그 (Changelog)

이 문서는 Groobee iOS SDK의 버전별 변경 사항을 기록합니다.

## 현재 권장 버전 (Stable)

- 1.1.10

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

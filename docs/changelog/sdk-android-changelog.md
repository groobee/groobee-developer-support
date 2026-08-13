# Android SDK - 변경 로그 (Changelog)

이 문서는 Groobee Android SDK의 버전별 변경 사항을 기록합니다.  

## 현재 권장 버전 (Stable)

- 1.0.83

---

## [1.0.86] - 2026-08-13
* improve: 하이브리드 앱 동기화 메소드 호출시 **최근 본 상품 목록**을 함께 전달하도록 변경 (`syncWebToNative`, `syncNativeToWeb`)
* 관련 변경 페이지: [Android SDK 하이브리드 앱 데이터 동기화](../detail/android-sdk-hybrid-sync.md):

---

## [1.0.85] - 2026-07-27
* fix: 인앱 메시지의 닫기 버튼 이미지를 불러오지 못했을 때 버튼이 보이지 않아 메시지를 닫을 수 없던 문제 수정 (기본 닫기 아이콘으로 대체)
* improve: 인앱 메시지 이미지를 불러오지 못했을 때 다시 시도하도록 개선

변경 요약: 인앱 메시지의 이미지 로딩 안정성을 개선했습니다. 앱 코드 수정 없이 SDK 버전만 올리면 적용됩니다.

---

## [1.0.84] - 2026-06-11
* fix: 알림 메시지에서 알림 설정 버튼을 눌렀을 떄 웹 브라우저 링크도 열 수 있도록 수정

---

## [1.0.83] - 2026-05-28
* fix: 액티비티가 종료 된 이후에 인앱 메시지가 노출이 시도되어도 크래시 리포트가 발생하지 않도록 수정

---

## [1.0.82] - 2026-04-30
* fix: 웹-네이티브 동기화 중 입력되는 데이터는 동기화 이후에 처리되도록 변경

---

## [1.0.81] - 2026-04-23

* fix: 정보성 푸시의 경우 알림 설정 페이지 버튼이 안 뜨도록 수정

---

## [1.0.80] - 2026-04-17

* Add: 정보통신망법 7차 개정안 대응 기능 추가: 알림 메시지에서 바로 알림 설정 페이지로 이동하는 딥링크 지원 ([KISA 안내](https://www.kisa.or.kr/401/form?postSeq=3608&lang_type=KO))

관련 변경 페이지:

- [Android Native SDK 설치 가이드 - Application 설정](../installation/installation-android-sdk.md#application-config): `GroobeeConfig.Builder.setNotificationSettingsButton()` 예시와 주요 설정 항목 설명이 추가되었습니다. 버튼 문구로 사용할 문자열 리소스와 앱 알림 설정 화면으로 이동할 딥링크를 설정합니다.
- [Android Flutter SDK 설치 가이드 - Application 설정](../installation/installation-android-flutter-sdk.md#application-config): Flutter Android 모듈의 `Application` 초기화 예시에 동일한 알림 설정 버튼/딥링크 설정이 추가되었습니다.
- [Android SDK 기능 지원 범위](./sdk-android-feature-support.md): 초기 설정 기능 목록에 `setNotificationSettingsButton` 기반의 `푸시 알림 수신 설정 버튼` 지원 항목이 추가되었습니다.

변경 요약: 푸시 알림 하단에 알림 수신 설정 버튼을 표시하고, 사용자가 버튼을 누르면 앱에서 정의한 알림 설정 화면 딥링크로 이동할 수 있도록 `setNotificationSettingsButton()` 설정이 추가되었습니다. 앱에서는 해당 딥링크 라우팅과 알림 수신 동의 화면/상태 동기화를 함께 구현해야 합니다.

---

## [1.0.78] - 2026-01-29

* Fix: 회원 성별 코드가 대문자로 수집되는 문제 수정

---

## [1.0.77] - 2025-12-24

* Improve: SDK와 Groobee 서버 간 통신 안정화

---

## [1.0.76] - 2025-12-24

* Add: 상세 로그 출력 기능 추가

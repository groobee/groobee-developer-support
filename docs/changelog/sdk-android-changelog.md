# Android SDK - 변경 로그 (Changelog)

이 문서는 Groobee Android SDK의 버전별 변경 사항을 기록합니다.  

## 현재 권장 버전 (Stable)

- 1.0.89

---

## [1.0.89] - 2026-09-29
* fix: 1.0.88에서 인앱 팝업 이미지 높이 상한 설정 메소드(`setInAppMsgMaxHeightRatioPortrait`, `setInAppMsgMaxHeightRatioLandscape`)를 호출하면 앱 빌드 시 컴파일 오류(`cannot find symbol`)가 발생하던 문제 수정
* 관련 변경 페이지: [Android SDK 설치 가이드 - 인앱 팝업 이미지 높이 상한](../installation/installation-android-sdk.md#inapp-popup-height-ratio)

변경 요약: 높이 상한 설정을 사용하려면 1.0.89 이상이 필요합니다. 이 설정을 사용하지 않는 앱은 1.0.88과 동작이 같습니다.

---

## [1.0.88] - 2026-09-28
* improve: **가로 화면 인앱 팝업 표출 개선.** 팝업이 이미지 크기에 맞게 표시되어 좌우 빈 영역이 사라지고, 닫기 버튼이 이미지 모서리에 붙습니다.
* change: **가로 팝업의 좌우 딤(어두운) 영역을 탭하면 랜딩되지 않고 팝업이 닫힙니다.** 기존에는 이미지 클릭으로 처리되어 랜딩되었습니다.
* add: 인앱 팝업 이미지 높이 상한 도입 (기본값 `0.9`). 상한을 조절하는 설정 메소드(`setInAppMsgMaxHeightRatioPortrait`, `setInAppMsgMaxHeightRatioLandscape`)는 이 버전에서 호출하면 컴파일 오류가 발생하므로 **1.0.89 이상**에서 사용하세요.
* 관련 변경 페이지: [Android SDK 설치 가이드 - 인앱 팝업 이미지 높이 상한](../installation/installation-android-sdk.md#inapp-popup-height-ratio)

변경 요약: 가로 화면에서 인앱 팝업이 어색하게 표출되던 문제를 개선했습니다. 앱 코드 수정 없이 SDK 버전만 올리면 적용되며, 높이 상한 설정은 선택 사항입니다(1.0.89 이상).

> **팝업 크기 참고**: 이번 버전에서 팝업이 기존보다 커지는 경우는 없습니다. 높이가 먼저 차는 경우(가로 화면 전반, 태블릿 세로에서 세로로 긴 소재)에는 쓸 수 있는 높이의 90%까지만 사용하므로 가로·세로 각 최대 10% 작아질 수 있습니다.

> **통계 리포트 참고**: 가로 팝업의 좌우 빈 곳 탭이 더 이상 클릭으로 집계되지 않으므로, 이번 버전이 적용된 단말이 늘어남에 따라 **가로 화면에서의 인앱 메시지 클릭수가 감소**할 수 있습니다. 의도하지 않은 클릭이 제외되면서 수치가 정확해지는 것이며, 실제 캠페인 성과가 하락한 것은 아닙니다.

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

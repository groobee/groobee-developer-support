# Groobee Developer Support - 문서 변경 이력

이 문서는 Groobee 개발자 지원 문서의 주요 변경 사항을 기록합니다.  
최신 변경 내역이 상단에 표시됩니다.

---

## 2026-10-01
작성자: 김훈기

- [Android SDK 변경 로그](./sdk-android-changelog.md)에 1.0.90·1.0.91 버전 변경 내역 추가 (인앱 팝업 닫기 버튼 크기 조정 설정 추가, 닫기 버튼 표시 개선)
- [Android SDK 설치 가이드](../installation/installation-android-sdk.md#inapp-close-button-scale)에 인앱 팝업 닫기 버튼 크기 설정 절 추가 (`setInAppMsgCloseButtonScale`, SDK 1.0.91 이상)
- [Android SDK 기능 지원 범위](./sdk-android-feature-support.md)에 인앱 팝업 닫기 버튼 크기 설정 추가
- 현재 최신 SDK 버전 갱신 — Android 1.0.89 → 1.0.91

---

## 2026-09-29
작성자: 김훈기

- [Android SDK 변경 로그](./sdk-android-changelog.md)에 1.0.89 버전 변경 내역 추가 (1.0.88에서 높이 상한 설정 메소드 호출 시 컴파일 오류가 발생하던 문제 수정), 1.0.88 항목에 높이 상한 설정 메소드는 1.0.89 이상에서 사용 가능함을 명시
- [Android SDK 설치 가이드](../installation/installation-android-sdk.md#inapp-popup-height-ratio)의 인앱 팝업 이미지 높이 상한 지원 버전을 1.0.89 이상으로 정정
- [Android SDK 기능 지원 범위](./sdk-android-feature-support.md)의 인앱 팝업 높이 상한 설정 2건 지원 버전을 1.0.89 이상으로 정정
- 현재 최신 SDK 버전 갱신 — Android 1.0.86 → 1.0.89, iOS 1.1.12 → 1.1.13
- 현재 권장 버전(Stable) 갱신 — Android 1.0.88 → 1.0.89

---

## 2026-09-28
작성자: 김훈기

- [Android SDK 변경 로그](./sdk-android-changelog.md)에 1.0.88 버전 변경 내역 추가 (가로 인앱 팝업 표출 개선, 딤 영역 탭 동작 변경, 높이 상한 설정 신설)
- [Android SDK 설치 가이드](../installation/installation-android-sdk.md)에 인앱 팝업 이미지 높이 상한 설정 절 추가 (`setInAppMsgMaxHeightRatioPortrait`·`setInAppMsgMaxHeightRatioLandscape`, SDK 1.0.88)
- [Android SDK 기능 지원 범위](./sdk-android-feature-support.md)에 인앱 팝업 높이 상한 설정 2건 추가
- [iOS SDK 변경 로그](./sdk-ios-changelog.md)에 1.1.13 버전 변경 내역 추가 (가로·폴더블 인앱 팝업 잘림 수정, 닫기 버튼 크기 조정, 높이 상한 설정 신설)
- [iOS SDK 설치 가이드](../installation/installation-ios-sdk.md)에 인앱 팝업 이미지 높이 상한 설정 절 추가 (`setInAppMsgMaxHeightRatioPortrait`·`setInAppMsgMaxHeightRatioLandscape`, SDK 1.1.13)
- [iOS SDK 기능 지원 범위](./sdk-ios-feature-support.md)에 인앱 팝업 높이 상한 설정 2건 추가
- 현재 권장 버전(Stable) 갱신 — Android 1.0.83 → 1.0.88, iOS 1.1.11 → 1.1.13

---

## 2026-09-23
작성자: 이도환

- [행동 이력 수집 가이드](../installation/installation-web-action.md): 커스텀 사이트 장바구니 담기/제거 호출 방법을 `groobee.addToCart()` / `groobee.deleteFromCart()`로 수정, 웹 페이지 URL 등록을 필수로 변경, SPA `start()` / `action()` 안내 정정
- [확장 필드 (attribute / extraData)](../installation/installation-web-action.md#extension-fields) 항목 신설, [Schema](../specs/action/schema.md) Goods에 `attribute` 필드 추가
- [웹 페이지 URL 등록](../prerequisites/web-page-url-registration.md): 페이지 유형별 URL 매칭 방식 정정
- AI 추천 가이드: 기본 타임아웃(5000ms), 클릭 예시 함수 인자 순서, 스크립트형 기획전(`planCd`) 응답, DIV형 속성, `recommendBaseType`(`BRAND`, `MEMBER_DATA`) 정정
- 공통 스크립트 `grbDisabled` 동작 범위, 웹뷰 User-Agent 봇 판정 주의사항 추가

---

## 2026-08-13
작성자: 김훈기

- 하이브리드 앱 데이터 동기화 가이드([Android](../detail/android-sdk-hybrid-sync.md) · [iOS](../detail/ios-sdk-hybrid-sync.md))에 신규 SDK 업데이트 관련 (최근 본 상품 목록 동기화) 안내 추가
- iOS 하이브리드 동기화 가이드에 신설 메소드 `syncNativeToWeb(_ domain:)`·`syncWebToNative(webView:urlRequest:)` 절 추가 (SDK 1.1.12)

---

## 2026-05-20
작성자: 김훈기

- iOS Native SDK 설치 가이드의 [FCM과 GroobeeKit 간 메시지 연동](../installation/installation-ios-sdk.md#ios-fcm-groobee-message-linkage)에 v.1.1.5 이상 기준 Swift/Objective-C 푸시 응답 처리 예시를 추가

---

## 2026-04-23
작성자: 김훈기

- SDK 가이드 추가

---

## 2026-02-23
작성자: 김훈기
 
- 행동이력 문서 업데이트: 행동 유형별 수집 시점 추가
- 트러블 슈팅 문서 업데이트: 자주 발생하는 문제 해결 가이드 추가  

---

## 2026-02-20
작성자: 김훈기
 
- Web Installation: 공통 스크립트, 회원 정보, 행동 이력 수집법 추가  


---

## 2026-01-14
작성자: 김훈기

- Init: 최초 작성  

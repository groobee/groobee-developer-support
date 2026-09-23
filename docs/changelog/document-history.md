# Groobee Developer Support - 문서 변경 이력

이 문서는 Groobee 개발자 지원 문서의 주요 변경 사항을 기록합니다.  
최신 변경 내역이 상단에 표시됩니다.

---

## 2026-09-23
작성자: 이도환

- [행동 이력 수집 가이드](../installation/installation-web-action.md): 커스텀 사이트 장바구니 담기/제거 호출 방법을 `groobee.addToCart()` / `groobee.deleteFromCart()`로 수정, 웹 페이지 URL 등록을 필수로 변경, SPA `start()` / `action()` 안내 정정
- [커스텀 데이터 전달 (attribute / extraData)](../installation/installation-web-action.md#custom-data) 항목 신설, [Schema](../specs/action/schema.md) Goods에 `attribute` 필드 추가
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

# iOS SDK - 기능 지원 범위 (Feature Support)

이 문서는 Groobee iOS SDK에서 제공하는 기능과 지원 버전 범위를 정리한 문서입니다.  
각 기능의 최신 상태와 지원 버전을 확인할 수 있습니다.

> 최소 지원 OS: iOS 10  
> 문서 기준 SDK 버전: 1.1.1

---

## iOS 버전별 이벤트 지원

| SDK 연동 iOS 버전 | Push Open | Push Receive | InAppMessage |
|---|---|---|---|
| iOS 13 미만 | O | △ (Background/Foreground 모드에 따라 결정) | O |
| iOS 13 이상 | O | O | O |

---

## 기능 지원 목록

### 초기 설정 (AppDelegate / GroobeeConfig)

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| SDK 초기화 | `Groobee.configure` | ✅ 지원 | 1.0.0+ | 필수 |
| 서비스키 등록 | `GroobeeConfigBuilder.setServiceKey` | ✅ 지원 | 1.0.0+ | 필수, `serviceKey`와 `bundleId` 전달 |
| 인앱 메시지 상단 마진 | `setInAppMsgMarginTop` | ✅ 지원 | - | 선택 |
| 인앱 메시지 하단 마진 | `setInAppMsgMarginBottom` | ✅ 지원 | - | 선택 |
| 푸시 알림 수신 설정 버튼 | `setNotificationSettingsButton` | ✅ 지원 | - | 텍스트 + 딥링크 URL 지정, 다국어 처리 시 `NSLocalizedString` 권장 |
| 앱 생명주기 연동 | `GroobeeKitLifeCycle` | ✅ 지원 | 1.0.0+ | iOS 13 미만: AppDelegate, iOS 13 이상: SceneDelegate에 각 Life Cycle 메소드 연결 |
| Firebase 초기화 | `FirebaseApp.configure` | ✅ 지원 | 1.0.0+ | 필수 |
| Firebase 메시징 델리게이트 | `Messaging.messaging().delegate` | ✅ 지원 | 1.0.0+ | 필수 |
| 푸시 권한 요청 | `pushNotiConfirmation` | ✅ 지원 | 1.0.0+ | `UNUserNotificationCenter.requestAuthorization` 기반 |
| Rich Push - Notification Service Extension | `GroobeeNotification.receiveService` | ✅ 지원 | 1.0.0+ | 이미지/미디어 첨부 지원에 필요 |
| Rich Push - Notification Content Extension | `GroobeeNotification.receiveContent` | ✅ 지원 | 1.0.0+ | 커스텀 알림 UI 표시 |

### 회원 정보 설정

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| 유저 로그인 | `setServiceLogin(memberId:)` | ✅ 지원 | 1.0.0+ | 선택 |
| 유저 정보 등록 (개별 파라미터) | `setUserInfo(id:grade:age:gender:type:)` | ✅ 지원 | 1.0.0+ | 선택 |
| 유저 정보 등록 (Map 오버로딩) | `setUserInfo(userInfo: [String: Any])` | ✅ 지원 | 1.0.45+ | 필수값: `id`, `grade`, `age`, `gender`, `type` / 추가값: `vendorCd`, `point` |
| 유저 로그아웃 | `serviceLogout` | ✅ 지원 | 1.0.0+ | 로그인했던 memberId 정보 초기화 |
| 유저 정보 초기화 | `memberDataClear` | ✅ 지원 | 1.0.0+ | 세팅한 유저 정보 초기화 |
| 회원가입 완료 | `setMemberJoin(memberId:screenId:)` | ✅ 지원 | 1.0.0+ | 전환율 측정 |
| 푸시 토큰 등록 | `setPushToken(pushToken:)` | ✅ 지원 | 1.0.0+ | 푸시 사용 시 필수 |
| 푸시 동의 상태 동기화 | `syncMemberAgreed(memberId:)` | ✅ 지원 | - | `setServiceLogin`/`setMemberJoin` 이후 호출 |
| 그루비 웹 쿠키 가져오기 | `getGroobeeWebCookies` | ✅ 지원 | - | 웹뷰에 쿠키 주입 용도 |

### 푸시 수신 동의 설정

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| 푸시 사용 동의(전체) | `setPushAgreeAP(isPushAgreedAP:)` | ✅ 지원 | - | 푸시 사용 시 필수 |
| 광고 Push 사용 동의 | `setPushAgreeAA(isPushAgreedAA:)` | ✅ 지원 | - | 푸시 사용 시 필수 |
| 야간 Push 사용 동의 | `setPushAgreeAN(isPushAgreedAN:)` | ✅ 지원 | - | 21시 이후 발송 대상 제한 |
| Push 동의 상태 조회 (동기) | `getPushAgreed(memberId:)` | ✅ 지원 | - | 인증 전 호출 시 null 반환 가능 |
| Push 동의 상태 조회 (비동기/콜백) | `getPushAgreed(memberId:responseAgreeds:)` | ✅ 지원 | - | `ResponseAgreeds` 콜백으로 결과 전달 |

### 페이지별 설정 (화면/행동 이벤트)

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| 검색 키워드 | `setSearchKeyword(searchKwd:screenId:)` | ✅ 지원 | - | 선택 |
| 상품 상세 | `setViewGoods(goods:screenId:)` | ✅ 지원 | - | 선택 |
| 장바구니 | `setShoppingCart(goods:screenId:)` | ✅ 지원 | - | 선택 |
| 주문하기 | `setGoodsOrder(goods:screenId:)` | ✅ 지원 | - | 선택 |
| 주문 완료 | `setGoodsOrderComplete(orderNo:goods:screenId:)` | ✅ 지원 | - | 선택, 전환 측정 |
| 카테고리 | `setCategory(cateCd:cateNm:screenId:)` | ✅ 지원 | - | 선택 |
| 기타 화면 정보 | `setScreenData(screenName:screenId:)` | ✅ 지원 | - | 선택 |
| 커스텀 이벤트 | `setCustomEvent(eventKey:screenId:eventValue:)` | ✅ 지원 | - | 선택 |

### Native + 웹 데이터 동기화 (하이브리드)

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| 웹뷰 쿠키 동기화 | `setWebViewCookies(webView:urlRequest:)` | ✅ 지원 | - | `WKWebView`의 `didFinish navigation`에서 호출 권장 |

### 추천 상품

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| 추천 상품 리스트 (동기식) | `getRecommendGoods(campaignKey:timeout:)` | ✅ 지원 | - | 응답시간 초과 시 빈 Array 반환 |
| 추천 상품 리스트 (비동기식/콜백) | `getRecommendGoods(campaignKey:responseGoods:)` | ✅ 지원 | - | `ResponseGoods` 콜백으로 결과 전달 |
| 추천 상품 노출 통계 | `setShowRecommendGoods(goods:campaignKey:algorithmCd:requestId:)` | ✅ 지원 | - | 노출 상태에 따른 통계 측정 |
| 추천 상품 클릭 통계 | `setClickRecommendGoods(goods:campaignKey:algorithmCd:requestId:)` | ✅ 지원 | - | 클릭 상태에 따른 통계 측정 |

### 로그 유틸리티 (LoggerUtils)

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| 로그 레벨 설정 | `LoggerUtils.setLogLevel` | ✅ 지원 | - | `verbose`, `debug`, `info`, `warn`, `error`, `none` |
| 상세 로그 활성화 | `LoggerUtils.setDetailLogEnabled` | ✅ 지원 | - | 선택 |
| 추적 아이디 활성화 | `LoggerUtils.setTraceEnabled` | ✅ 지원 | - | 선택 |
| 로그 콜백 등록 | `LoggerUtils.setLogCallback` | ✅ 지원 | - | `GroobeeLogCallback` 구현체 전달 |
| 로그 옵션 일괄 설정 | `LoggerUtils.setOptions` | ✅ 지원 | - | `LOG_LEVEL`, `DETAIL_LOG_ENABLED`, `TRACE_ENABLED`, `LOG_CALLBACK` 지원 |

---

## 참고 문서

- [iOS SDK 변경 로그](./sdk-ios-changelog.md)

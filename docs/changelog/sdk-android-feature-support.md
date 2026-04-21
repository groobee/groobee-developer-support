# Android SDK - 기능 지원 범위 (Feature Support)

이 문서는 Groobee Android SDK에서 제공하는 기능과 지원 버전 범위를 정리한 문서입니다.  
각 기능의 최신 상태와 지원 버전을 확인할 수 있습니다.

> 최소 지원 OS: Android API 16 (Jelly Bean)  
> 현재 권장 SDK 버전은 [Android SDK 변경 로그](./sdk-android-changelog.md)에서 확인하세요.

---

## 기능 지원 목록

### 초기 설정 (Application / GroobeeConfig)

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| SDK 초기화 | `Groobee.configure` | ✅ 지원 | 1.0.0+ | 필수 |
| 서비스키 등록 | `GroobeeConfig.Builder.setApiKey` | ✅ 지원 | 1.0.0+ | 필수 |
| 푸시 클릭 액티비티 이동 허용 | `setPushMoveActivityEnabled` | ✅ 지원 | - | 선택 |
| 푸시 클릭 이동 액티비티 지정 | `setPushMoveActivityClassName` | ✅ 지원 | - | `setPushMoveActivityEnabled(true)` 시 필수 |
| 푸시 딥링크 이동 허용 | `setHandlePushDeepLinks` | ✅ 지원 | - | 선택 |
| 푸시 아이콘 등록 | `setSmallNotificationIcon` | ✅ 지원 | - | 필수 |
| 인앱 메시지 상단 마진 | `setInAppMsgMarginTop` | ✅ 지원 | - | 선택 |
| 인앱 메시지 하단 마진 | `setInAppMsgMarginBottom` | ✅ 지원 | - | 선택 |
| 푸시 메시지 중요도 설정 | `setPushImportance` | ✅ 지원 | 1.0.44+ | Android N 이상에서 `IMPORTANCE_DEFAULT` / `IMPORTANCE_HIGH` 사용 |
| 재인증 수행 여부 | `setRetryAuthConnection` | ✅ 지원 | - | 선택 |
| 푸시 알림 수신 설정 버튼 | `setNotificationSettingsButton` | ✅ 지원 | - | 앱 설정 페이지 딥링크 처리 필요 |
| 앱 생명주기 콜백 등록 | `Groobee.getActivityLifecycleCallbacks` | ✅ 지원 | 1.0.0+ | 필수 |
| Firebase 초기화 | `FirebaseApp.initializeApp` | ✅ 지원 | 1.0.0+ | FCM 사용 시 필수 |
| 로그 레벨 설정 | `LoggerUtils.setLogLevel` | ✅ 지원 | - | 선택 |
| 상세 로그 옵션 설정 | `LoggerUtils.setOptions` | ✅ 지원 | - | `DETAIL_LOG_ENABLED`, `TRACE_ENABLED`, `LOG_CALLBACK` 지원 |

### 회원 정보 설정

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| 유저 로그인 | `setServiceLogin` | ✅ 지원 | 1.0.0+ | 선택 |
| 유저 로그아웃 | `setServiceLogout` | ✅ 지원 | 1.0.0+ | 앱 내 회원 ID만 제거 (서버 데이터는 유지) |
| 유저 정보 등록 | `setMember` | ✅ 지원 | 1.0.0+ | `MEMBER_ID, GRADE, GENDER, AGE, TYPE` 또는 Map 전달 가능 |
| 유저 정보 삭제 | `clearMemberData` | ✅ 지원 | 1.0.0+ | 선택 |
| 회원가입 완료 | `setMemberJoin` | ✅ 지원 | 1.0.0+ | 전환율 측정 |
| 푸시 토큰 등록 | `setPushToken` | ✅ 지원 | 1.0.0+ | 푸시 사용 시 필수 |
| 푸시 동의 상태 동기화 | `syncMemberAgreed` | ✅ 지원 | - | `setServiceLogin` 또는 `setMemberJoin` 이후 호출 |

### 푸시 수신 동의 설정

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| 푸시 사용 동의(전체) | `setAgreedPush` | ✅ 지원 | - | 푸시 사용 시 필수 |
| 광고 Push 사용 동의 | `setAgreedPushAdvertising` | ✅ 지원 | - | 푸시 사용 시 필수 |
| 야간 Push 사용 동의 | `setAgreedPushNight` | ✅ 지원 | - | 푸시 사용 시 필수, 21시 이후 발송 대상 제한 |
| Push 동의 상태 조회 (동기) | `getPushAgreed(MEMBER_ID)` | ✅ 지원 | - | 인증 전 호출 시 null 반환 가능 |
| Push 동의 상태 조회 (비동기/콜백) | `getPushAgreed(MEMBER_ID, ResultAgreeds)` | ✅ 지원 | - | 콜백 Listener로 결과 전달 |

### 페이지별 설정 (화면/행동 이벤트)

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| 검색 키워드 | `setSearchKeyword` | ✅ 지원 | - | 선택 |
| 상품 상세 | `setViewGoods` | ✅ 지원 | - | 선택 |
| 장바구니 | `setShoppingCart` | ✅ 지원 | - | 선택 |
| 주문하기 | `setGoodsOrder` | ✅ 지원 | - | 선택 |
| 주문 완료 | `setGoodsOrderComplete` | ✅ 지원 | - | 선택, 전환 측정 |
| 카테고리 | `setCategory` | ✅ 지원 | - | 선택 |
| 기타 화면 정보 | `setScreenData` | ✅ 지원 | - | 선택 |
| 커스텀 이벤트 (SCREEN_ID 포함) | `setCustomEvent(activity, EVENT_KEY, EVENT_VALUE, SCREEN_ID)` | ✅ 지원 | - | 권장 시그니처 |
| 커스텀 이벤트 (SCREEN_ID 없음) | `setCustomEvent(activity, EVENT_KEY, EVENT_VALUE)` | ⚠️ Deprecated | - | 하위 버전 호환용으로 유지 |

### Native + 웹 데이터 동기화 (하이브리드)

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| 웹뷰 → 네이티브 데이터 동기화 | `syncWebToNative` | ✅ 지원 | 1.0.58+ | 1.0.58 이전에는 `setWebViewLogger`로 제공 |
| 네이티브 → 웹뷰 데이터 동기화 | `syncNativeToWeb` | ✅ 지원 | - | `syncWebToNative`와 동시 사용 불가 |
| 네이티브 쿠키 획득 | `getNativeCookie` | ✅ 지원 | - | 직접 웹뷰에 적용할 때 사용 |

### 추천 상품

| 기능 | 메소드 | 최신 상태 | 최초 지원 버전 | 비고 |
|---|---|---|---|---|
| 추천 상품 리스트 (동기식) | `getRecommendGoods(CAMPAIGN_KEY, TIME_OUT)` | ✅ 지원 | - | 응답시간 초과 시 빈 리스트 반환 |
| 추천 상품 리스트 (비동기식/콜백) | `getRecommendGoods(CAMPAIGN_KEY, ResultGoods)` | ✅ 지원 | - | 콜백으로 결과 전달 |
| 추천 상품 노출 통계 | `setShowRecommendGoods` | ✅ 지원 | - | 노출 상태에 따른 통계 측정 |
| 추천 상품 클릭 통계 | `setClickRecommendGoods` | ✅ 지원 | - | 클릭 상태에 따른 통계 측정 |

---

## 참고 문서

- [Android SDK 변경 로그](./sdk-android-changelog.md)

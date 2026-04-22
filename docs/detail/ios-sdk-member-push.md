# iOS SDK 회원 정보 및 푸시 상태 연동

---

## 목차

1. [공통 호출 위치](#common-call-site)
2. [회원 정보 설정](#member-info)
3. [푸시 수신 동의 설정](#push-consent)
4. [푸시 동의 상태 조회](#push-consent-query)
5. [함께 보면 좋은 문서](#related-docs)

---

<a id="common-call-site"></a>
## 공통 호출 위치

그루비 메소드는 가급적이면 View 생성 시 한 번만 호출되는 `viewDidLoad()` 같은 곳에서 사용하시길 권합니다.  
InAppMessage를 사용하는 상태에서 화면전환 메소드나 버튼 기능처럼 여러 번 호출될 수 있는 곳에서 사용하면 오작동 가능성이 있습니다.

<a id="member-info"></a>
## 회원 정보 설정

운영 주의 사항:

- Groobee SDK는 회원 ID를 앱 재실행 후에도 유지합니다.
- 회원 ID는 외부인이 식별할 수 없는 값으로 전달하는 것을 권장합니다. (예: `MB0000012345` 형태)
- 앱 토큰/세션이 만료되어 로그아웃 될 때도 현재 상태에 맞게 `setServiceLogout()`를 호출해야 합니다.
- 푸시 관련 이력 역시 회원 ID와 함께 수집되므로, 푸시로 앱이 열릴 때도 로그인 상태 정합성을 맞춰야 합니다.
- 하이브리드 앱인 경우 스크립트에서 사용하는 회원아이디와 iOS 네이티브 모듈에서 사용하는 회원아이디가 동일해야 합니다.


### `setServiceLogin(memberId)`

Swift:

```swift
Groobee.getInstance().setServiceLogin(memberId: USER_ID_STRING)
```

Objective-C:

```objectivec
[[Groobee getInstance] setServiceLoginWithMemberId:USER_ID_STRING];
```

| 변수명 | 자료형 | 설명 | 예시             |
| --- | --- | --- |----------------|
| `USER_ID_STRING` | `String` | 회원아이디 | `MB0000012345` |

주의:

- 로그인 시에만 `setServiceLogin()`을 호출하면 기존에 이미 로그인되어 있던 사용자가 비회원 정보로 쌓일 수 있습니다. 회원/비회원에 대한 정확한 데이터를 수집하기 위해 호출 로직을 꼼꼼히 검토하세요.

설명:

- 그루비에 등록된 회원 ID에 한해서 타겟팅할 수 있게 되며, 그 대상으로 메시지를 전달할 수 있습니다.
- 동일한 기기에서 여러 사용자가 로그인하는 경우 최근 로그인한 사용자 한 명만 발송 대상으로 등록됩니다.

### `serviceLogout()`

Swift:

```swift
Groobee.getInstance().serviceLogout()
```

Objective-C:

```objectivec
[[Groobee getInstance] serviceLogout];
```

- 로그인했던 `memberId` 정보를 초기화하는 API입니다.


### `setUserInfo(id, grade, age, gender, type)`

Swift:

```swift
Groobee.getInstance().setUserInfo(
    id: MEMBER_ID,
    grade: GRADE,
    age: AGE,
    gender: GENDER,
    type: TYPE
)
```

Objective-C:

```objectivec
[[Groobee getInstance] setUserInfoWithId:MEMBER_ID
                                   grade:GRADE
                                     age:AGE
                                  gender:GENDER
                                    type:TYPE];
```

| 변수명 | 자료형 | 설명 | 예시             |
| --- | --- | --- |----------------|
| `id` | `String` | 회원아이디 | `MB0000012345` |
| `grade` | `String` | 회원등급 | `VIP`          |
| `age` | `String` | 연령대 | `20-30`        |
| `gender` | `String` | 성별 | `M`            |
| `type` | `String` | 회원유형 | `admin`        |

해당 정보는 세그먼트 생성 시 방문자 유형 조건 데이터로 등록됩니다.

### `setUserInfo(userInfo)`

`1.0.45` 버전부터 같은 명칭의 `setUserInfo` 오버로딩이 추가되었습니다.

```swift
let userInfo: [String: Any] = [
    "id": "M12345",
    "grade": "A",
    "age": "25",
    "gender": "M",
    "type": "Premium",
    "vendorCd": "V001",
    "point": "1000"
]

Groobee.getInstance().setUserInfo(userInfo: userInfo)
```

| 변수명 | 자료형 | 설명 | 비고                                  |
| --- | --- | --- |-------------------------------------|
| `userInfo` | `[String: Any]` | 필수 요청값: `id`, `grade`, `age`, `gender`, `type` / 추가값: `vendorCd`, `point`  | 추가값을 사용하려면 별도 설정이 필요합니다. Groobee 고객센터로 문의해주세요. |

### `memberDataClear()`

Swift:

```swift
Groobee.getInstance().memberDataClear()
```

Objective-C:

```objectivec
[[Groobee getInstance] memberDataClear];
```

- 세팅한 유저 정보를 초기화하는 API입니다.

### `setMemberJoin(memberId, screenId)`

Swift:

```swift
Groobee.getInstance().setMemberJoin(memberId: USER_JOIN_ID, screenId: SCREEN_ID)
```

Objective-C:

```objectivec
[[Groobee getInstance] setMemberJoinWithMemberId:USER_JOIN_ID
                                        screenId:SCREEN_ID
                                     clickButton:NULL];
```

| 변수명 | 자료형 | 설명 | 예시               |
| --- | --- | --- |------------------|
| `USER_JOIN_ID` | `String` | 회원가입 계정 | `MB0000012345`   |
| `SCREEN_ID` | `String` | 화면 식별 ID | `SCREEN_PAGE_01` |

- `setMemberJoin()` 호출은 회원가입 완료 시점에 해야 하며, 전환율 측정 후 통계에 노출됩니다.
- `SCREEN_ID`를 이용해 InAppMessage를 노출하거나 특정 화면 진입을 트리거로 메시지를 전달할 수 있습니다.

### `setPushToken(pushToken)`

Swift:

```swift
Groobee.getInstance().setPushToken(pushToken: TOKEN)
```

Objective-C:

```objectivec
[[Groobee getInstance] setPushTokenWithPushToken:TOKEN];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `TOKEN` | `String` | FCM으로 발급받은 토큰 값 | `dKn1wgl63Gc:APA91bHXQsvS5…` |

- `setPushToken()` 호출은 FCM 토큰 생성 이후 시점에 해야 합니다.
- 수집된 토큰 기반으로 푸시 캠페인 메시지를 전달할 수 있습니다.

### `syncMemberAgreed(memberId)`

Swift:

```swift
Groobee.getInstance().syncMemberAgreed(memberId: memberId)
```

Objective-C:

```objectivec
[[Groobee getInstance] syncMemberAgreeWithMemberId:memberId];
```

| 변수명 | 자료형 | 설명 | 예시             |
| --- | --- | --- |----------------|
| `MEMBER_ID` | `String` | 회원아이디 | `MB0000012345` |

여러 기기에서 로그인한 회원에 대해 푸시 동의 상태를 동일하게 동기화하려는 경우 `syncMemberAgreed()`를 호출합니다.  
해당 함수는 `setServiceLogin()` 또는 `setMemberJoin()` 호출 이후에 호출해야 합니다.

예시:

- 1번 기기에서 푸시 동의를 거부한 고객이 2번 기기에서 푸시 동의를 수락한 경우  
  → 1번 기기에 해당하는 회원의 푸시 상태를 동의 수락 상태로 변경

<a id="push-consent"></a>
## 푸시 수신 동의 설정

아래 세 메소드는 각각 전체 푸시 / 광고 푸시 / 야간 푸시 수신 동의 상태를 SDK에 전달합니다.

### 공통 주의 사항

- 세 메소드 모두 **사용자가 설정에서 토글을 변경할 때뿐 아니라 현재 상태도 한 번 호출해 동기화**해야 합니다. 변경 시점에만 호출하면 초기값이 전달되지 않아 해당 사용자가 `false`로 집계될 수 있습니다.
- 설정 화면 진입 시 현재 상태를 한 번 동기화하고, 사용자가 토글을 변경할 때 다시 호출하는 방식을 권장합니다.

### `setPushAgreeAP(isPushAgreedAP)`

Swift:

```swift
Groobee.getInstance().setPushAgreeAP(isPushAgreedAP: IS_PUSH_AGGREED)
```

Objective-C:

```objectivec
[[Groobee getInstance] setPushAgreeAPWithIsPushAgreedAP:IS_PUSH_AGGREED];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `IS_PUSH_AGGREED` | `Bool` | 푸시 사용 동의 허용 여부 | `true` or `false` |

- 이 값이 `false`인 사용자는 모든 푸시 발송 대상에서 제외됩니다.
- 그루비는 이 동의 여부를 기준으로 발송 대상을 만들어 푸시 메시지를 전송합니다.

### `setPushAgreeAA(isPushAgreedAA)`

Swift:

```swift
Groobee.getInstance().setPushAgreeAA(isPushAgreedAA: IS_ADVERTISING_PUSH_AGREED)
```

Objective-C:

```objectivec
[[Groobee getInstance] setPushAgreeAAWithIsPushAgreedAA:IS_ADVERTISING_PUSH_AGREED];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `IS_ADVERTISING_PUSH_AGREED` | `Bool` | 광고 푸시 사용 동의 허용 여부 | `true` or `false` |

- 광고성 캠페인 발송 대상 필터링에 사용됩니다. 동의한 사용자에 한해 광고 메시지가 발송됩니다.

### `setPushAgreeAN(isPushAgreedAN)`

Swift:

```swift
Groobee.getInstance().setPushAgreeAN(isPushAgreedAN: IS_NIGHT_PUSH_AGREED)
```

Objective-C:

```objectivec
[[Groobee getInstance] setPushAgreeANWithIsPushAgreedAN:IS_NIGHT_PUSH_AGREED];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `IS_NIGHT_PUSH_AGREED` | `Bool` | 야간 푸시 사용 동의 허용 여부 | `true` or `false` |

- 21시 이후 발송 대상 필터링에 사용됩니다. 발송 시간이 21시 이후인 메시지는 이 값이 `true`인 사용자에게만 발송됩니다.

<a id="push-consent-query"></a>
## 푸시 동의 상태 조회

### 동기식: `getPushAgreed(memberId)`

Swift:

```swift
let agreeds = Groobee.getInstance().getPushAgreed(memberId: MEMBER_ID)

if let agreeds = agreeds {
    isPush = agreeds.agreedAP
    isAdvert = agreeds.agreedAA
    isNight = agreeds.agreedAN
}
```

Objective-C:

```objectivec
Agreeds *agreeds = [[Groobee getInstance] getPushAgreedWithMemberId:MEMBER_ID];

if (agreeds != NULL) {
    isPush = agreeds.agreedAP;
    isAdvert = agreeds.agreedAA;
    isNight = agreeds.agreedAN;
}
```

| 변수명 | 자료형 | 설명 | 예시             |
| --- | --- | --- |----------------|
| `MEMBER_ID` | `String` | 회원아이디 | `MB0000012345` |

주의:

- `getPushAgreed()`는 동기 방식으로 통신하여 결과를 반환합니다.
- 인증 전 호출될 경우 `null`이 리턴될 수 있으므로 null 처리 예시가 필요합니다.

- 호출한 회원 아이디 기준으로 최근에 설정한 푸시 동의 상태를 조회하여 반환합니다.

### 비동기식(콜백): `getPushAgreed(memberId, responseAgreeds)`

Swift:

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    Groobee.getInstance().getPushAgreed(memberId: MEMBER_ID, responseAgreeds: self)
}

extension ViewController: ResponseAgreeds {
    func onSuccess(agreeds: GroobeeKit.Agreeds) {
        isPush = agreeds.agreedAP
        isAdvert = agreeds.agreedAA
        isNight = agreeds.agreedAN
    }

    func onFailed(exceptionMsg: String) { }
}
```

Objective-C:

```objectivec
@interface ViewController () <ResponseAgreeds>

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Groobee getInstance] getPushAgreedWithMemberId:MEMBER_ID responseAgreeds:self];
}

- (void)onSuccessWithAgreeds:(Agreeds * _Nonnull)agreeds {
    isPush = agreeds.agreedAP;
    isAdvert = agreeds.agreedAA;
    isNight = agreeds.agreedAN;
}

- (void)onFailedWithExceptionMsg:(NSString * _Nonnull)exceptionMsg { }
```

| 변수명 | 자료형 | 설명 | 예시             |
| --- | --- | --- |----------------|
| `MEMBER_ID` | `String` | 회원아이디 | `MB0000012345` |
| `responseAgreeds` | `ResponseAgreeds` | 푸시 동의 정보 반환 | 콜백 객체          |

- `getPushAgreed()` 메소드를 비동기 방식으로 통신하여 결과를 반환합니다.
- 비동기 통신 결과 완료 시 연결한 callback listener로 전달합니다.
- 호출한 회원 아이디 기준으로 최근에 설정한 푸시 동의 상태를 조회하여 반환합니다.

<a id="related-docs"></a>
## 함께 보면 좋은 문서

- [iOS SDK 설치 가이드](../installation/installation-ios-sdk.md)
- [iOS SDK 행동 이력 수집](./ios-sdk-actions.md)
- [iOS SDK 하이브리드 앱 데이터 동기화](./ios-sdk-hybrid-sync.md)

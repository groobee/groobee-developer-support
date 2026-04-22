# Flutter iOS SDK MethodChannel 연동

이 문서는 Flutter 앱에서 Dart와 iOS 모듈 사이를 `MethodChannel`로 연결하는 방법을 정리한 문서입니다. 현재 권장 SDK 버전은 [iOS SDK 변경 로그](../changelog/sdk-ios-changelog.md)에서 확인하세요.

---

## 목차

1. [왜 MethodChannel이 필요한가](#why-method-channel)
2. [사전 조건](#prerequisites)
3. [1. Dart에서 Push Token 생성 후 iOS로 전달](#step-1-push-token)
4. [2. iOS의 Method Channel에서 Groobee의 setPushToken 함수 호출](#step-2-set-push-token)
5. [3. Dart에서 Groobee 함수 호출 예제 (SET 함수 활용)](#step-3-set-functions)
6. [4. Dart에서 Groobee 함수 호출 예제 (GET 함수 활용)](#step-4-get-functions)
7. [주요 매핑 메소드 목록](#method-mapping)
8. [JSON 직렬화 주의사항](#json-serialization)
9. [브리지 확장 순서 권장 사항](#bridge-expansion)
10. [함께 보면 좋은 문서](#related-docs)

---

<a id="why-method-channel"></a>
## 왜 MethodChannel이 필요한가

Flutter 앱에서 Groobee iOS SDK(`GroobeeKit`)는 iOS 네이티브 모듈 안에서 동작합니다.  
즉, Dart 코드에서 직접 `Groobee.getInstance()`를 호출할 수 없기 때문에 아래 흐름이 필요합니다.

1. Dart에서 필요한 값을 준비합니다.
2. `MethodChannel`로 iOS에 메소드 이름과 파라미터를 전달합니다.
3. iOS `AppDelegate` 또는 별도 브리지 클래스에서 `GroobeeKit` 메소드를 호출합니다.
4. 조회성 API는 iOS에서 JSON 문자열로 직렬화해 Dart로 되돌려줍니다.

<a id="prerequisites"></a>
## 사전 조건

- [Flutter iOS SDK 설치 가이드](../installation/installation-ios-flutter-sdk.md)의 설치가 먼저 완료되어 있어야 합니다.
- `ios/Runner/GoogleService-Info.plist`가 포함되어 있어야 합니다.
- Dart 측에서 FCM 토큰을 만들기 전에 `Firebase.initializeApp()`이 먼저 실행되어야 합니다.
- `MethodChannel` 이름은 Dart, iOS 양쪽에서 동일해야 하며, 본 가이드에서는 **`Groobee-iOS-Channel`** 을 사용합니다.

---

<a id="step-1-push-token"></a>
## 1. Dart에서 Push Token 생성 후 iOS로 전달

토큰 생성 전 `Firebase.initializeApp()`을 호출하여 Firebase 인증을 받습니다.

```dart
Future<void> initializeDefault() async {
  await Firebase.initializeApp();
  getFcmToken();
}
```

인증 후 토큰 발급을 처리할 함수를 호출하고, 해당 토큰을 `MethodChannel`을 이용해 Groobee 함수로 전달합니다.

```dart
Future<void> getFcmToken() async {
  const platform = MethodChannel('Groobee-iOS-Channel');

  FirebaseMessaging.instance.getToken().then((value) async {
    String? token = value;
    await platform.invokeMethod('setPushToken', {"token": token});
  });
}
```

<a id="step-2-set-push-token"></a>
## 2. iOS의 Method Channel에서 Groobee의 setPushToken 함수 호출

Dart에서 생성한 토큰을 `GroobeeKit`의 `setPushToken`에 전달합니다.

```swift
let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

let methodChannel = FlutterMethodChannel(
    name: "Groobee-iOS-Channel",
    binaryMessenger: controller.binaryMessenger
)

methodChannel.setMethodCallHandler { (call, result) in
    if call.method == "setPushToken" {
        let arguments = call.arguments as? [String: Any]
        let token = arguments?["token"] as? String
        Groobee.getInstance().setPushToken(pushToken: token!)
    }
}
```

---

<a id="step-3-set-functions"></a>
## 3. Dart에서 Groobee 함수 호출 예제 (SET 함수 활용)

Dart 영역에서 Groobee 함수로 전달할 값들을 `MethodChannel`을 이용해 함수로 구현한 뒤 호출합니다.

예시 1) `setServiceLogin`

```dart
Future<void> setServiceLogin(String memberId) async {
  const platform = MethodChannel('Groobee-iOS-Channel');
  await platform.invokeMethod('setServiceLogin', {"memberId": memberId});
}
```

예시 2) `setPushAgreedAP`

```dart
Future<void> setPushAgreedAP(bool isAgreed) async {
  const platform = MethodChannel('Groobee-iOS-Channel');
  await platform.invokeMethod('setPushAgreedAP', {"isPushAgreedAP": isAgreed});
}
```

iOS의 Method Channel에서 Dart에서 호출하는 함수명에 맞춰 `GroobeeKit` 함수를 호출합니다.

예시 3) iOS 측 핸들러:

```swift
methodChannel.setMethodCallHandler { (call, result) in
    if call.method == "setServiceLogin" {
        let arguments = call.arguments as? [String: Any]
        let memberId = arguments?["memberId"] as? String
        Groobee.getInstance().setServiceLogin(memberId: memberId)
    }

    if call.method == "setPushAgreedAP" {
        let arguments = call.arguments as? [String: Any]
        let isAgreedAP = arguments?["isPushAgreedAP"] as? Bool
        Groobee.getInstance().setPushAgreeAP(isPushAgreedAP: isAgreedAP ?? false)
    }
}
```

---

<a id="step-4-get-functions"></a>
## 4. Dart에서 Groobee 함수 호출 예제 (GET 함수 활용)

### 예제 1) 비동기식 함수 호출

Dart에서 비동기로 호출할 함수명을 지정하고 매개변수를 전달하며, 반환 받을 자료형을 지정합니다.

```dart
Future<void> getPushAgreed(String memberId) async {
  const platform = MethodChannel('Groobee-iOS-Channel');
  String result = await platform.invokeMethod('getPushAgreed', {"memberId": memberId});
  print("getPushAgreed : $result");
}
```

iOS의 Method Channel 클래스에서 전역변수를 선언합니다.

```swift
private var result: FlutterResult!
```

호출된 함수에서 전역변수에 `result`를 대입합니다.

```swift
methodChannel.setMethodCallHandler { (call, result) in
    if call.method == "getPushAgreed" {
        self.result = result
        let arguments = call.arguments as? [String: Any]
        let memberId = arguments?["memberId"] as? String

        if let memberId = memberId {
            Groobee.getInstance().getPushAgreed(memberId: memberId, responseAgreeds: self)
        }
    }
}
```

SDK 가이드와 동일한 콜백 함수를 만들어 `getPushAgreed`를 호출하고, `ResponseAgreeds` 프로토콜 콜백 함수를 이용해 Dart로 값을 전달합니다.

> 주의: `result` 호출 시 String 데이터가 들어갈 수 있도록 객체를 `Data` 형으로 변환하고 JSON String 형태로 다시 디코딩하여 전달해야 합니다.

```swift
extension AppDelegate: ResponseAgreeds {
    func onSuccess(agreeds: GroobeeKit.Agreeds) {
        var isPush = agreeds.agreedAP
        var isAdvert = agreeds.agreedAA
        var isNight = agreeds.agreedAN

        let data = try? JSONEncoder().encode(agreeds)
        let stringAgreeds = String(decoding: data ?? Data(), as: UTF8.self)
        result(stringAgreeds)
    }

    func onFailed(exceptionMSG: String) {
        result(exceptionMSG)
    }
}
```

실행 결과 예시:

```text
flutter: getPushAgreed : {"agreedAA":false,"agreedAN":false,"agreedAP":true}
```

### 예제 2) 동기식 함수 호출

Dart에서 동기로 호출할 함수명을 지정하고 매개변수를 전달하며, 반환 받을 자료형을 지정합니다.

```dart
Future<void> getPushAgreedSync(String memberId) async {
  const platform = MethodChannel('Groobee-iOS-Channel');
  String result = await platform.invokeMethod('getPushAgreedSync', {"memberId": memberId});
  print("getPushAgreedSync : $result");
}
```

iOS의 Method Channel에서 Dart에서 호출하는 함수명에 맞춰 `GroobeeKit` 함수를 호출하고, `result`에 JSON으로 변환하여 결과를 전달합니다.

> 주의: `result` 호출 시 String 데이터가 들어갈 수 있도록 `Data` 형으로 변환하고 JSON String 형태로 다시 디코딩하여 전달해야 합니다.

```swift
methodChannel.setMethodCallHandler { (call, result) in
    if call.method == "getPushAgreedSync" {
        let arguments = call.arguments as? [String: Any]
        let memberId = arguments?["memberId"] as? String

        if let memberId = memberId {
            let data = try? JSONEncoder().encode(Groobee.getInstance().getPushAgreed(memberId: memberId))
            let stringAgreeds = String(decoding: data ?? Data(), as: UTF8.self)
            result(stringAgreeds)
        }
    }
}
```

실행 결과 예시:

```text
flutter: getPushAgreedSync : {"agreedAA":false,"agreedAN":false,"agreedAP":true}
```

---

<a id="method-mapping"></a>
## 주요 매핑 메소드 목록

Flutter 브리지에서 자주 연결하게 되는 `GroobeeKit` 메소드를 기능별로 정리했습니다. 각 메소드의 인자 형식과 동작은 iOS Native SDK 상세 가이드와 동일합니다.

### 회원 정보

| Dart 호출 메소드명 | iOS 메소드 | 설명 |
| --- | --- | --- |
| `setServiceLogin` | `Groobee.getInstance().setServiceLogin(memberId:)` | 로그인한 회원 ID 등록. |
| `setUserInfo` | `Groobee.getInstance().setUserInfo(id:grade:age:gender:type:)` | 회원 속성 등록. `[String: Any]` 오버로딩도 지원. |
| `serviceLogout` | `Groobee.getInstance().serviceLogout()` | 로그아웃 처리. |
| `memberDataClear` | `Groobee.getInstance().memberDataClear()` | 세팅된 회원 정보 초기화. |
| `setMemberJoin` | `Groobee.getInstance().setMemberJoin(memberId:screenId:)` | 회원가입 완료 시점 호출. |
| `syncMemberAgreed` | `Groobee.getInstance().syncMemberAgreed(memberId:)` | 여러 기기 간 푸시 동의 상태 동기화. |
| `getGroobeeWebCookies` | `Groobee.getInstance().getGroobeeWebCookies()` | Groobee 웹 쿠키 조회 (하이브리드 동기화용). |

### 푸시

| Dart 호출 메소드명 | iOS 메소드 | 설명 |
| --- | --- | --- |
| `setPushToken` | `Groobee.getInstance().setPushToken(pushToken:)` | FCM 토큰 등록. |
| `setPushAgreedAP` | `Groobee.getInstance().setPushAgreeAP(...)` | 푸시 사용 동의(전체). |
| `setPushAgreedAA` | `Groobee.getInstance().setPushAgreeAA(...)` | 광고 Push 사용 동의. |
| `setPushAgreedAN` | `Groobee.getInstance().setPushAgreeAN(...)` | 야간 Push 사용 동의. |
| `getPushAgreed` | `Groobee.getInstance().getPushAgreed(memberId:responseAgreeds:)` | 푸시 동의 상태 조회 (비동기, 콜백). |
| `getPushAgreedSync` | `Groobee.getInstance().getPushAgreed(memberId:)` | 푸시 동의 상태 조회 (동기). |

### 행동 이력 수집

| Dart 호출 메소드명 | iOS 메소드 | 설명 |
| --- | --- | --- |
| `setSearchKeyword` | `Groobee.getInstance().setSearchKeyword(...)` | 검색 키워드 수집. |
| `setViewGoods` | `Groobee.getInstance().setViewGoods(...)` | 상품 상세 진입. |
| `setShoppingCart` | `Groobee.getInstance().setShoppingCart(...)` | 장바구니 이벤트. |
| `setGoodsOrder` | `Groobee.getInstance().setGoodsOrder(...)` | 주문하기 이벤트. |
| `setGoodsOrderComplete` | `Groobee.getInstance().setGoodsOrderComplete(...)` | 주문 완료 이벤트. |
| `setCategory` | `Groobee.getInstance().setCategory(...)` | 카테고리 진입. |
| `setScreenData` | `Groobee.getInstance().setScreenData(...)` | 기타 화면 정보. |
| `setCustomEvent` | `Groobee.getInstance().setCustomEvent(...)` | 커스텀 이벤트. |

### 하이브리드 동기화 / 추천 상품

| Dart 호출 메소드명 | iOS 메소드 | 설명 |
| --- | --- | --- |
| `setWebViewCookies` | `Groobee.getInstance().setWebViewCookies(...)` | 웹뷰 데이터 동기화. |
| `getRecommendGoods` | `Groobee.getInstance().getRecommendGoods(...)` | 추천 상품 조회 (동기/비동기). |
| `setShowRecommendGoods` | `Groobee.getInstance().setShowRecommendGoods(...)` | 추천 상품 노출 통계. |
| `setClickRecommendGoods` | `Groobee.getInstance().setClickRecommendGoods(...)` | 추천 상품 클릭 통계. |

> `GroobeeKit` 함수의 정확한 시그니처와 파라미터 규칙은 각 상세 가이드를 참고하세요. Flutter 브리지는 이 시그니처에 맞춰 Dart 측 파라미터를 매핑하면 됩니다.

<a id="json-serialization"></a>
## JSON 직렬화 주의사항

- `getPushAgreed` 등 GET 계열 응답은 `GroobeeKit`에서 `Agreeds`와 같은 Swift 구조체로 반환됩니다. Dart로 그대로 넘길 수 없기 때문에 **JSONEncoder로 Data 형으로 인코딩 → UTF-8 문자열로 디코딩**한 뒤 `result(stringAgreeds)`로 전달해야 합니다.
- Dart 측에서는 전달받은 JSON 문자열을 `jsonDecode`로 역직렬화하여 사용합니다.
- 콜백 기반(`ResponseAgreeds`) API는 `FlutterResult`를 전역 변수(`private var result: FlutterResult!`)로 저장해 두고 콜백에서 호출하는 패턴을 사용합니다. 결과를 전달한 후 전역 변수를 비워 두는 방식으로 사용해도 좋습니다.

<a id="bridge-expansion"></a>
## 브리지 확장 순서 권장 사항

1. `setPushToken()`, `setServiceLogin()`, `setPushAgreedAP()` 처럼 단순한 SET 메소드부터 연결합니다.
2. 이후 `setScreenData()`와 `setSearchKeyword()` 같은 행동 이력 수집 메소드를 연결합니다.
3. 다음으로 상품/주문 모델 변환이 필요한 `setViewGoods`, `setGoodsOrder`, `setGoodsOrderComplete` 등을 추가합니다.
4. 마지막으로 `getPushAgreed()`, `getRecommendGoods()` 처럼 JSON 응답이 필요한 GET 계열을 확장합니다.

<a id="related-docs"></a>
## 함께 보면 좋은 문서

- [Flutter iOS SDK 설치 가이드](../installation/installation-ios-flutter-sdk.md)
- [iOS SDK 회원 정보 및 푸시 상태 연동](./ios-sdk-member-push.md)
- [iOS SDK 행동 이력 수집](./ios-sdk-actions.md)
- [iOS SDK 추천 상품 연동](./ios-sdk-recommend.md)
- [iOS SDK 주의사항 및 로그 유틸리티](./ios-sdk-cautions-log.md)

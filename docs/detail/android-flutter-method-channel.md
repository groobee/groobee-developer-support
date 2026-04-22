# Flutter Android SDK MethodChannel 연동

이 문서는 Flutter 앱에서 Dart와 Android 모듈 사이를 `MethodChannel`로 연결하는 방법을 정리한 문서입니다. 현재 권장 SDK 버전은 [Android SDK 변경 로그](../changelog/sdk-android-changelog.md)에서 확인하세요.

---

## 목차

1. [왜 MethodChannel이 필요한가](#why-method-channel)
2. [사전 조건](#prerequisites)
3. [Dart에서 Push Token 생성 후 Android로 전달](#dart-push-token)
4. [Android에서 Push Token 처리](#android-push-token)
5. [SET 계열 메소드 패턴](#set-pattern)
6. [GET 계열 메소드 패턴](#get-pattern)
7. [Activity 인자가 필요한 메소드](#activity-required)
8. [브리지 확장 순서 권장 사항](#bridge-expansion)
9. [함께 보면 좋은 문서](#related-docs)

---

<a id="why-method-channel"></a>
## 왜 MethodChannel이 필요한가

Flutter 앱에서 Groobee Android SDK는 Android 네이티브 모듈 안에서 동작합니다.  
즉, Dart 코드에서 직접 `Groobee.getInstance()`를 호출할 수 없기 때문에 아래 흐름이 필요합니다.

1. Dart에서 필요한 값을 준비합니다.
2. `MethodChannel`로 Android에 메소드 이름과 파라미터를 전달합니다.
3. Android `MainActivity` 또는 별도 브리지 클래스에서 Groobee SDK 메소드를 호출합니다.
4. 조회성 API는 Android에서 JSON 문자열로 직렬화해 Dart로 되돌려줍니다.

<a id="prerequisites"></a>
## 사전 조건

- [Android Flutter SDK 설치 가이드](../installation/installation-android-flutter-sdk.md)의 설치가 먼저 완료되어 있어야 합니다.
- `android/app/google-services.json`이 포함되어 있어야 합니다.
- Dart 측에서 FCM 토큰을 만들기 전에 `Firebase.initializeApp()`이 먼저 실행되어야 합니다.

<a id="dart-push-token"></a>
## Dart에서 Push Token 생성 후 Android로 전달

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

const _channel = MethodChannel('Groobee-Android-Channel');

Future<void> initializeGroobeePush() async {
  await Firebase.initializeApp();

  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    await _channel.invokeMethod('setPushToken', {'token': token});
  }
}
```

<a id="android-push-token"></a>
## Android에서 Push Token 처리

Kotlin:

```kotlin
class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "Groobee-Android-Channel"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setPushToken" -> {
                        val token = call.argument<String>("token")
                        if (token.isNullOrBlank()) {
                            result.error("INVALID_TOKEN", "token is required", null)
                        } else {
                            Groobee.getInstance().setPushToken(token)
                            result.success(null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
```

Java:

```java
public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "Groobee-Android-Channel";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if ("setPushToken".equals(call.method)) {
                        String token = call.argument("token");
                        if (token == null || token.trim().isEmpty()) {
                            result.error("INVALID_TOKEN", "token is required", null);
                        } else {
                            Groobee.getInstance().setPushToken(token);
                            result.success(null);
                        }
                    } else {
                        result.notImplemented();
                    }
                });
    }
}
```

<a id="set-pattern"></a>
## SET 계열 메소드 패턴

Dart에서 값을 보내고 Android에서 Groobee 메소드를 호출하는 가장 단순한 패턴입니다.

예시:

```dart
Future<void> setServiceLogin(String memberId) async {
  await _channel.invokeMethod('setServiceLogin', {'memberId': memberId});
}

Future<void> setAgreedPush(bool isAgreed) async {
  await _channel.invokeMethod('setAgreedPush', {'isAgreed': isAgreed});
}
```

Android:

Kotlin:

```kotlin
"setServiceLogin" -> {
    val memberId = call.argument<String>("memberId")
    if (memberId.isNullOrBlank()) {
        result.error("INVALID_MEMBER_ID", "memberId is required", null)
    } else {
        Groobee.getInstance().setServiceLogin(memberId)
        result.success(null)
    }
}

"setAgreedPush" -> {
    val isAgreed = call.argument<Boolean>("isAgreed")
    if (isAgreed == null) {
        result.error("INVALID_ARG", "isAgreed is required", null)
    } else {
        Groobee.getInstance().setAgreedPush(isAgreed)
        result.success(null)
    }
}
```

Java:

```java
case "setServiceLogin": {
    String memberId = call.argument("memberId");
    if (memberId == null || memberId.trim().isEmpty()) {
        result.error("INVALID_MEMBER_ID", "memberId is required", null);
    } else {
        Groobee.getInstance().setServiceLogin(memberId);
        result.success(null);
    }
    break;
}

case "setAgreedPush": {
    Boolean isAgreed = call.argument("isAgreed");
    if (isAgreed == null) {
        result.error("INVALID_ARG", "isAgreed is required", null);
    } else {
        Groobee.getInstance().setAgreedPush(isAgreed);
        result.success(null);
    }
    break;
}
```

<a id="get-pattern"></a>
## GET 계열 메소드 패턴

조회성 메소드는 Android에서 받은 결과를 Dart로 다시 넘겨야 합니다.  
`result.success()`에는 문자열이 들어가도록 `Gson().toJson()`을 사용해 JSON 문자열로 직렬화한 뒤 전달하는 방식을 권장합니다.

### 비동기식 예시: `getPushAgreed`

Dart:

```dart
import 'dart:convert';

Future<Map<String, dynamic>?> getPushAgreed(String memberId) async {
  final jsonString = await _channel.invokeMethod<String>(
    'getPushAgreed',
    {'memberId': memberId},
  );

  if (jsonString == null) {
    return null;
  }

  return jsonDecode(jsonString) as Map<String, dynamic>;
}
```

Android:

Kotlin:

```kotlin
private var pendingResult: MethodChannel.Result? = null

"getPushAgreed" -> {
    val memberId = call.argument<String>("memberId")
    if (memberId.isNullOrBlank()) {
        result.error("INVALID_MEMBER_ID", "memberId is required", null)
    } else {
        pendingResult = result
        Groobee.getInstance().getPushAgreed(memberId, resultAgreeds)
    }
}

private val resultAgreeds = object : ResultAgreeds {
    override fun onSuccess(agreeds: Agreeds) {
        pendingResult?.success(Gson().toJson(agreeds))
        pendingResult = null
    }

    override fun onFailed(exceptMsg: String) {
        pendingResult?.error("GROOBEE_ERROR", exceptMsg, null)
        pendingResult = null
    }
}
```

Java:

```java
private MethodChannel.Result pendingResult;

case "getPushAgreed": {
    String memberId = call.argument("memberId");
    if (memberId == null || memberId.trim().isEmpty()) {
        result.error("INVALID_MEMBER_ID", "memberId is required", null);
    } else {
        pendingResult = result;
        Groobee.getInstance().getPushAgreed(memberId, resultAgreeds);
    }
    break;
}

private final ResultAgreeds resultAgreeds = new ResultAgreeds() {
    @Override
    public void onSuccess(Agreeds agreeds) {
        if (pendingResult != null) {
            pendingResult.success(new Gson().toJson(agreeds));
            pendingResult = null;
        }
    }

    @Override
    public void onFailed(String exceptMsg) {
        if (pendingResult != null) {
            pendingResult.error("GROOBEE_ERROR", exceptMsg, null);
            pendingResult = null;
        }
    }
};
```

### 동기식 예시: `getPushAgreedSync`

Kotlin:

```kotlin
"getPushAgreedSync" -> {
    val memberId = call.argument<String>("memberId")
    if (memberId.isNullOrBlank()) {
        result.error("INVALID_MEMBER_ID", "memberId is required", null)
    } else {
        result.success(
            Gson().toJson(Groobee.getInstance().getPushAgreed(memberId))
        )
    }
}
```

Java:

```java
case "getPushAgreedSync": {
    String memberId = call.argument("memberId");
    if (memberId == null || memberId.trim().isEmpty()) {
        result.error("INVALID_MEMBER_ID", "memberId is required", null);
    } else {
        result.success(new Gson().toJson(Groobee.getInstance().getPushAgreed(memberId)));
    }
    break;
}
```

<a id="activity-required"></a>
## Activity 인자가 필요한 메소드

아래 메소드는 `Activity` 인자가 필요하므로 Android Activity 컨텍스트에서 호출해야 합니다.

- `setMemberJoin()`
- `setSearchKeyword()`
- `setViewGoods()`
- `setShoppingCart()`
- `setGoodsOrder()`
- `setGoodsOrderComplete()`
- `setCategory()`
- `setScreenData()`
- `setCustomEvent()`

즉, Flutter에서 화면 진입을 감지하더라도 실제 Groobee 호출은 `MainActivity` 같은 Android 쪽 브리지에서 처리하는 구성이 안전합니다.

<a id="bridge-expansion"></a>
## 브리지 확장 순서 권장 사항

1. `setPushToken()`, `setServiceLogin()`, `setAgreedPush()`처럼 단순한 SET 메소드부터 연결합니다.
2. 이후 `setScreenData()`와 `setSearchKeyword()` 같은 행동 이력 수집 메소드를 연결합니다.
3. 다음으로 `Goods` 모델 변환이 필요한 상품 이벤트 메소드를 추가합니다.
4. 마지막으로 `getPushAgreed()`나 추천 상품 API처럼 JSON 응답이 필요한 GET 계열을 확장합니다.

<a id="related-docs"></a>
## 함께 보면 좋은 문서

- [Android Flutter SDK 설치 가이드](../installation/installation-android-flutter-sdk.md)
- [Android SDK 회원 정보 및 푸시 상태 연동](./android-sdk-member-push.md)
- [Android SDK 행동 이력 수집](./android-sdk-actions.md)
- [Android SDK 추천 상품 연동](./android-sdk-recommend.md)

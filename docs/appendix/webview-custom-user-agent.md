# 부록: 웹뷰 커스텀 User-Agent 설정

이 문서는 **하이브리드 앱의 웹뷰에 커스텀 User-Agent 문자열을 추가**하여 Groobee 어드민에 등록한 "사용 플랫폼" 값과 짝을 이루도록 설정하는 방법을 정리한 부록 문서입니다.

Groobee 어드민 사용 플랫폼 등록 방법은 [앱 정보 등록 > 사용 플랫폼 설정](../prerequisites/app-name-registration.md#사용-플랫폼-설정-하이브리드-앱에서-앱-여부-식별) 문서를 참고하세요.

---

## 목차

1. [개요](#overview)
2. [공통 권장 사항](#common-guidelines)
3. [Android `WebView`](#android-webview)
4. [iOS `WKWebView`](#ios-wkwebview)
5. [Flutter (`webview_flutter`)](#flutter-webview)
6. [검증 방법](#verification)

---

<a id="overview"></a>
## 개요

Groobee는 웹 스크립트로 들어오는 요청이 **앱 내부 웹뷰에서 발생했는지 일반 웹 브라우저에서 발생했는지** 를 User-Agent 문자열로 구분합니다.

앱 측에서 해야 하는 일은 **앱 내 모든 웹뷰가 보내는 User-Agent에 고정된 식별 문자열을 포함**시키는 것뿐입니다. 어드민의 `사용 플랫폼 > 기타(직접 입력)`에 등록한 값과 **완전히 같은 문자열**이 포함되도록 설정하면 됩니다.

> 이 문서에서는 예시 식별자로 `MyAppCustomUserAgent`를 사용합니다. 실제로는 어드민에 등록한 값과 동일한 문자열로 바꿔서 적용하세요.

---

<a id="common-guidelines"></a>
## 공통 권장 사항

- **기존 기본 User-Agent를 완전히 대체하지 말고** 뒤에 식별자를 append 하세요. 기본 UA를 통째로 날리면 웹사이트가 모바일/데스크톱 레이아웃을 판단하지 못하거나 일부 리소스 요청이 차단될 수 있습니다.
  - 권장: `<기본 UA> MyAppCustomUserAgent`
  - 비권장: `MyAppCustomUserAgent` (기본 UA 제거)
- 앱 내부에 웹뷰가 여러 개 있다면 **모든 웹뷰 인스턴스에 일관되게** 적용하세요.
- 어드민에 등록한 값과 **대소문자·공백·기호까지 완전히 동일**해야 앱 트래픽으로 집계됩니다.

---

<a id="android-webview"></a>
## Android `WebView`

Android 기본 `WebView`는 `WebSettings.setUserAgentString()`으로 UA를 직접 지정합니다.

Kotlin:

```kotlin
val webView: WebView = findViewById(R.id.web_view)
val defaultUa = webView.settings.userAgentString
webView.settings.userAgentString = "$defaultUa MyAppCustomUserAgent"
```

Java:

```java
WebView webView = findViewById(R.id.web_view);
String defaultUa = webView.getSettings().getUserAgentString();
webView.getSettings().setUserAgentString(defaultUa + " MyAppCustomUserAgent");
```

- `WebView`가 생성된 직후, 페이지를 로드하기 전에 설정해야 합니다.
- 앱에서 여러 `WebView`를 생성하는 경우 공통 초기화 함수에서 일괄 적용하는 것을 권장합니다.

---

<a id="ios-wkwebview"></a>
## iOS `WKWebView`

iOS에서는 `WKWebView.customUserAgent` 프로퍼티를 사용하는 것을 권장합니다.

Swift:

```swift
let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())

// 기본 UA 조회 후 커스텀 값을 append
webView.evaluateJavaScript("navigator.userAgent") { result, _ in
    let defaultUa = (result as? String) ?? ""
    webView.customUserAgent = "\(defaultUa) MyAppCustomUserAgent"
}
```

Objective-C:

```objectivec
WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero
                                         configuration:[[WKWebViewConfiguration alloc] init]];

[webView evaluateJavaScript:@"navigator.userAgent"
          completionHandler:^(id result, NSError * _Nullable error) {
    NSString *defaultUa = (NSString *)result ?: @"";
    webView.customUserAgent = [NSString stringWithFormat:@"%@ MyAppCustomUserAgent", defaultUa];
}];
```

- `customUserAgent`에 nil 또는 빈 문자열이 들어가면 시스템 기본값으로 되돌아갑니다.
- `UserDefaults`의 `UserAgent` 키로도 전역 UA를 덮을 수 있지만, 앱 시작 매우 초기 시점에 설정해야 하고 전 앱에 영향을 주므로 `customUserAgent` 방식을 권장합니다.

---

<a id="flutter-webview"></a>
## Flutter (`webview_flutter`)

Flutter 공식 `webview_flutter` 패키지의 `WebViewController`에 `setUserAgent()`가 제공됩니다.

```dart
import 'package:webview_flutter/webview_flutter.dart';

final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted);

// 기본 UA 조회 후 append
final defaultUa = await controller.runJavaScriptReturningResult(
  'navigator.userAgent',
) as String;

await controller.setUserAgent('$defaultUa MyAppCustomUserAgent');
await controller.loadRequest(Uri.parse('https://example.com'));
```

- `webview_flutter` 버전에 따라 API 시그니처가 다를 수 있으므로 사용 중인 버전의 문서를 함께 확인하세요.
- 내부적으로는 Android `WebView` / iOS `WKWebView`의 UA 설정을 그대로 호출하므로, 위 네이티브 섹션의 주의 사항이 동일하게 적용됩니다.

---

<a id="verification"></a>
## 검증 방법

앱 웹뷰에서 아래 중 한 가지 방법으로 실제 전송되는 User-Agent를 확인합니다.

1. **웹뷰에서 JavaScript 실행**

   ```javascript
   console.log(navigator.userAgent);
   ```

2. **웹뷰가 로드하는 페이지 서버 로그 확인** — HTTP 요청의 `User-Agent` 헤더에 등록한 식별자(`MyAppCustomUserAgent`)가 포함되어 있어야 합니다.

3. **Groobee 어드민 실시간 모니터링** — 사용 플랫폼 등록이 끝난 뒤 앱 웹뷰에서 페이지를 한 번 열고, 해당 세션이 앱 트래픽으로 분류되는지 확인합니다.

확인된 User-Agent 문자열에 어드민에 등록한 값이 **그대로 포함**되어 있는지 반드시 대조하세요. 한 글자라도 다르면 앱 트래픽으로 집계되지 않습니다.

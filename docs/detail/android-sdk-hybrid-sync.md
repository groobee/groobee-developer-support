# Android SDK 하이브리드 앱 데이터 동기화

이 문서는 Android Native SDK와 Flutter Android SDK 공통 기준으로 WebView가 포함된 하이브리드 앱에서 Groobee 데이터를 동기화하는 방법을 정리한 문서입니다.

---

## 목차

1. [왜 웹-네이티브 동기화가 필요한가](#why-sync)
2. [어떤 방식을 선택해야 하는가](#choose-approach)
3. [웹뷰에서 네이티브로 동기화](#web-to-native)
4. [네이티브에서 웹뷰로 동기화](#native-to-web)
5. [네이티브 쿠키 직접 가져오기](#get-native-cookie)
6. [Flutter 앱에서의 적용](#flutter-usage)
7. [함께 보면 좋은 문서](#related-docs)

---

<a id="why-sync"></a>
## 왜 웹-네이티브 동기화가 필요한가

그루비는 사용자를 식별할 때 **그루비가 자체적으로 발급·관리하는 쿠키 값**을 기준으로 사용합니다. 이 쿠키 값이 같으면 동일 사용자, 다르면 서로 다른 사용자로 집계됩니다.

문제는 하이브리드 앱에서 쿠키 저장소가 **두 개로 분리**된다는 점입니다.

- **앱 네이티브 영역**: Groobee Android SDK가 앱 내부 저장소(`SharedPreferences` 등)에 자체 식별 값을 생성·보관합니다.
- **앱 내부 웹뷰 영역**: `WebView`는 별도의 쿠키 저장소(`CookieManager`)를 사용합니다. 같은 웹사이트라도 외부 브라우저와 앱 웹뷰의 쿠키 저장소는 서로 격리되어 있습니다.

동기화를 하지 않으면 아래와 같은 상황이 발생합니다.

- 앱 네이티브에서는 `id=AAA-111`로 식별되는 사용자가
- 앱 웹뷰 안에서는 웹 스크립트가 새 쿠키 `id=BBB-222`를 발급하면서

같은 사용자가 **서로 다른 두 사용자로 중복 수집**됩니다. 세그먼트, 인앱메시지 타겟팅, 전환 통계, 추천 데이터 모두 영향을 받습니다.

이 문제를 피하려면 앱 네이티브와 웹뷰 중 한쪽이 보유한 그루비 식별 쿠키 값을 다른 쪽에 복사해 **두 저장소가 같은 값을 공유**하도록 맞춰야 합니다. 이 역할을 하는 것이 아래의 `syncWebToNative()` / `syncNativeToWeb()` / `getNativeCookie()` 메소드입니다.

---

<a id="choose-approach"></a>
## 어떤 방식을 선택해야 하는가

Groobee Android SDK는 하이브리드 앱에서 아래 두 가지 방식 중 하나를 사용합니다.

| 앱 구조 | 권장 방식 |
| --- | --- |
| WebView가 주 영역인 앱 | `syncWebToNative()` |
| 네이티브가 주 영역이고 일부만 WebView인 앱 | `syncNativeToWeb()` |

중요:

- `syncWebToNative()`와 `syncNativeToWeb()`는 동시에 사용하지 않습니다.
- 앱 구조에 맞는 한 가지 방식만 선택하세요.

<a id="web-to-native"></a>
## 웹뷰에서 네이티브로 동기화

### `syncWebToNative(url)`

WebView가 주 영역인 하이브리드 앱에서 웹 기준 데이터를 앱으로 동기화합니다.

Kotlin:

```kotlin
class CustomWebViewClient : WebViewClient() {
    override fun onPageFinished(view: WebView?, url: String?) {
        super.onPageFinished(view, url)
        Groobee.getInstance().syncWebToNative(url)
    }
}
```

Java:

```java
public class CustomWebViewClient extends WebViewClient {
    @Override
    public void onPageFinished(WebView view, String url) {
        super.onPageFinished(view, url);
        Groobee.getInstance().syncWebToNative(url);
    }
}
```

| 파라미터 | 설명 |
| --- | --- |
| `url` | WebView 페이지 로드 완료 시점의 URL |

이 메소드를 사용하지 않으면 웹 행동과 앱 행동이 서로 다른 사용자로 집계될 수 있습니다.

참고:

- Android SDK `1.0.58` 이전 버전에서는 `setWebViewLogger`라는 이름으로 제공되었습니다.

<a id="native-to-web"></a>
## 네이티브에서 웹뷰로 동기화

### `syncNativeToWeb(url)`

네이티브가 주 영역인 하이브리드 앱에서 앱 기준 데이터를 WebView에 동기화합니다.

Kotlin:

```kotlin
Groobee.configure(this, groobeeConfig.build())

Groobee.getInstance().syncNativeToWeb(".myshop.io")
Groobee.getInstance().syncNativeToWeb(".m.myshop.io")
```

Java:

```java
Groobee.configure(this, groobeeConfig.build());

Groobee.getInstance().syncNativeToWeb(".myshop.io");
Groobee.getInstance().syncNativeToWeb(".m.myshop.io");
```

| 파라미터 | 설명 | 예시 |
| --- | --- | --- |
| `url` | 쿠키 정보가 설정될 사이트 주소 | `.myshop.io` |

이 메소드를 사용하지 않으면 앱 행동과 웹 행동이 서로 다른 사용자로 집계될 수 있습니다.

<a id="get-native-cookie"></a>
## 네이티브 쿠키 직접 가져오기

### `getNativeCookie()`

`syncNativeToWeb()`를 사용하지 않고, 네이티브 쿠키를 직접 WebView에 적용해야 할 때 사용합니다.

Kotlin:

```kotlin
val nativeCookie = Groobee.getInstance().getNativeCookie()
```

Java:

```java
String nativeCookie = Groobee.getInstance().getNativeCookie();
```

- 쿠키를 직접 주입해야 하는 특수 WebView 구성에서 유용합니다.

<a id="flutter-usage"></a>
## Flutter 앱에서의 적용

Flutter 앱에서도 실제 WebView 동기화는 Android 모듈에서 처리하는 것이 안전합니다.

- WebViewClient를 Android 쪽에서 커스터마이징할 수 있으면 `syncWebToNative()`를 직접 연결합니다.
- 네이티브 쿠키를 주입하는 구조라면 `syncNativeToWeb()` 또는 `getNativeCookie()`를 Android 쪽에서 처리한 뒤 Flutter WebView 구성과 연결합니다.

<a id="related-docs"></a>
## 함께 보면 좋은 문서

- [Android SDK 행동 이력 수집](./android-sdk-actions.md)
- [Android Flutter SDK MethodChannel 연동](./android-flutter-method-channel.md)

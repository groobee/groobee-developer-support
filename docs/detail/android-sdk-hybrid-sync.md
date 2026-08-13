# Android SDK 하이브리드 앱 데이터 동기화

이 문서는 Android Native SDK와 Flutter Android SDK 공통 기준으로 WebView가 포함된 하이브리드 앱에서 Groobee 데이터를 동기화하는 방법을 정리한 문서입니다.

---

## 목차

1. [왜 웹-네이티브 동기화가 필요한가](#why-sync)
2. [어떤 방식을 선택해야 하는가](#choose-approach)
3. [웹뷰에서 네이티브로 동기화](#web-to-native)
4. [네이티브에서 웹뷰로 동기화](#native-to-web)
5. [네이티브 쿠키 직접 가져오기](#get-native-cookie)
6. [동작 한계](#limitations)
7. [Flutter 앱에서의 적용](#flutter-usage)
8. [iOS SDK와의 메소드 대응](#platform-mapping)
9. [함께 보면 좋은 문서](#related-docs)

---

<a id="why-sync"></a>
## 왜 웹-네이티브 동기화가 필요한가

동기화는 두 가지를 옮깁니다.

1. **그루비 식별 쿠키** — 앱과 웹의 사용자를 같은 사람으로 집계하기 위한 값
2. **최근 본 상품 목록** — 추천·세그먼트의 입력이 되는 값 (네이티브 → 웹뷰 방향은 SDK `1.0.86` 이상)

문제는 하이브리드 앱에서 저장소가 **두 개로 분리**된다는 점입니다.

- **앱 네이티브 영역**: Groobee Android SDK가 앱 내부 저장소(`SharedPreferences` 등)에 자체 식별 값과 최근 본 상품 목록을 생성·보관합니다.
- **앱 내부 웹뷰 영역**: `WebView`는 별도의 쿠키 저장소(`CookieManager`)를 사용합니다. 같은 웹사이트라도 외부 브라우저와 앱 웹뷰의 쿠키 저장소는 서로 격리되어 있습니다.

### ① 식별 쿠키가 공유되지 않으면

- 앱 네이티브에서는 `id=AAA-111`로 식별되는 사용자가
- 앱 웹뷰 안에서는 웹 스크립트가 새 쿠키 `id=BBB-222`를 발급하면서

같은 사용자가 **서로 다른 두 사용자로 중복 수집**됩니다. 세그먼트, 인앱메시지 타겟팅, 전환 통계, 추천 데이터 모두 영향을 받습니다.

### ② 최근 본 상품 목록이 공유되지 않으면

- 앱 네이티브 화면에서 본 상품이 **웹뷰 영역의 추천 입력에 들어가지 않고**
- 웹뷰에서 본 상품이 **앱 네이티브 영역의 추천 입력에 들어가지 않습니다**

식별 쿠키가 맞아도 이 목록이 한쪽에만 쌓이면 **같은 사용자에게 화면마다 다른 추천 결과가 나갑니다.** 최근 본 상품을 참조하는 추천 캠페인이라면 동기화를 반드시 연동해야 합니다.

이 문제를 피하려면 앱 네이티브와 웹뷰 중 한쪽이 보유한 값을 다른 쪽에 복사해 **두 저장소가 같은 값을 공유**하도록 맞춰야 합니다. 이 역할을 하는 것이 아래의 `syncWebToNative()` / `syncNativeToWeb()` / `getNativeCookie()` 메소드입니다.

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

설명:

- 웹뷰의 그루비 식별 쿠키와 최근 본 상품 목록을 읽어 네이티브 저장소에 반영합니다. WebView가 주 영역인 앱이므로 **웹뷰 값이 기준**이 됩니다.
- 이 메소드를 사용하지 않으면 웹 행동과 앱 행동이 서로 다른 사용자로 집계될 수 있습니다.

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

설명:

- `Groobee.configure()` 직후에 **웹뷰에서 사용하는 도메인마다 한 번씩** 호출합니다.
- SDK `1.0.86` 이상에서는 그루비 식별 쿠키와 함께 **최근 본 상품 목록**도 기록합니다. 호출한 도메인은 SDK가 기억해 두고, 이후 상품 상세 수집(`setViewGoods()`)으로 목록이 바뀔 때마다 **자동으로 다시 기록**합니다. 상품을 볼 때마다 이 메소드를 다시 호출할 필요는 없습니다.
- 이 메소드를 사용하지 않으면 앱 행동과 웹 행동이 서로 다른 사용자로 집계되고, 앱에서 본 상품이 웹뷰 추천에 반영되지 않습니다.
- 외부 브라우저(Chrome 등)는 앱과 격리된 별도 쿠키 저장소를 사용하므로 **적용 대상이 아닙니다.**

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
- ⚠️ **반환값에는 그루비 식별 쿠키만 담겨 있고 최근 본 상품 목록은 포함되지 않습니다.** 최근 본 상품까지 동기화하려면 `syncNativeToWeb()`을 사용하세요.

<a id="limitations"></a>
## 동작 한계

### 웹뷰 첫 진입 1회는 반영되지 않을 수 있습니다

호출 시점에 따라 웹뷰에 처음 진입하는 그 한 번은 최근 본 상품이 반영되지 않을 수 있습니다. `Groobee.configure()` 직후에 `syncNativeToWeb()`을 호출해 두면 이후 화면부터는 최신 목록이 유지됩니다.

### 최근 본 상품은 최대 12개까지 보관됩니다

웹 스크립트와 동일한 기준입니다. 직전에 본 상품과 같은 상품은 목록에 다시 추가하지 않습니다. 이 규칙은 SDK `1.0.86`에서 웹 스크립트와 통일되었으며, 그 이전 버전에서는 5개에서 잘렸습니다.

<a id="flutter-usage"></a>
## Flutter 앱에서의 적용

Flutter 앱에서도 실제 WebView 동기화는 Android 모듈에서 처리하는 것이 안전합니다.

- WebViewClient를 Android 쪽에서 커스터마이징할 수 있으면 `syncWebToNative()`를 직접 연결합니다.
- 네이티브 쿠키를 주입하는 구조라면 `syncNativeToWeb()` 또는 `getNativeCookie()`를 Android 쪽에서 처리한 뒤 Flutter WebView 구성과 연결합니다.

<a id="related-docs"></a>
## 함께 보면 좋은 문서

- [Android SDK 행동 이력 수집](./android-sdk-actions.md)
- [Android SDK 추천 상품 연동](./android-sdk-recommend.md)
- [Android Flutter SDK MethodChannel 연동](./android-flutter-method-channel.md)
- [iOS SDK 하이브리드 앱 데이터 동기화](./ios-sdk-hybrid-sync.md)

# iOS SDK 하이브리드 앱 데이터 동기화

이 문서는 iOS Native SDK와 Flutter iOS SDK 공통 기준으로, `WKWebView`가 포함된 하이브리드 앱에서 Groobee 데이터를 **앱 네이티브 영역과 웹뷰 영역 사이에 동기화**하는 방법을 정리한 문서입니다.

---

## 목차

1. [왜 웹-네이티브 동기화가 필요한가](#why-sync)
2. [어떤 방식을 선택해야 하는가](#choose-approach)
3. [웹뷰에서 네이티브로 동기화](#web-to-native)
4. [네이티브에서 웹뷰로 동기화](#native-to-web)
5. [그루비 웹 쿠키 직접 가져오기](#get-web-cookies)
6. [동작 한계](#limitations)
7. [함께 보면 좋은 문서](#related-docs)

---

<a id="why-sync"></a>
## 왜 웹-네이티브 동기화가 필요한가

동기화는 두 가지를 옮깁니다.

1. **그루비 식별 쿠키** — 앱과 웹의 사용자를 같은 사람으로 집계하기 위한 값
2. **최근 본 상품 목록** — 추천·세그먼트의 입력이 되는 값 (네이티브 → 웹뷰 방향은 SDK `1.1.12` 이상)

문제는 하이브리드 앱에서 저장소가 **두 개로 분리**된다는 점입니다.

- **앱 네이티브 영역**: Groobee iOS SDK(`GroobeeKit`)가 앱 내부 저장소에 자체 식별 값과 최근 본 상품 목록을 생성·보관합니다.
- **앱 내부 웹뷰 영역**: `WKWebView`는 별도의 쿠키 저장소(`WKHTTPCookieStore`)를 사용합니다. 같은 웹사이트라도 외부 Safari와 앱 웹뷰의 쿠키 저장소는 서로 격리되어 있습니다.

### ① 식별 쿠키가 공유되지 않으면

- 앱 네이티브에서는 `id=AAA-111`로 식별되는 사용자가
- 앱 웹뷰 안에서는 웹 스크립트가 새 쿠키 `id=BBB-222`를 발급하면서

같은 사용자가 **서로 다른 두 사용자로 중복 수집**됩니다. 세그먼트, 인앱메시지 타겟팅, 전환 통계, 추천 데이터 모두 영향을 받습니다.

### ② 최근 본 상품 목록이 공유되지 않으면

- 앱 네이티브 화면에서 본 상품이 **웹뷰 영역의 추천 입력에 들어가지 않고**
- 웹뷰에서 본 상품이 **앱 네이티브 영역의 추천 입력에 들어가지 않습니다**

식별 쿠키가 맞아도 이 목록이 한쪽에만 쌓이면 **같은 사용자에게 화면마다 다른 추천 결과가 나갑니다.** 최근 본 상품을 참조하는 추천 캠페인이라면 동기화를 반드시 연동해야 합니다.

이 문제를 피하려면 앱 네이티브와 웹뷰 중 한쪽이 보유한 값을 다른 쪽에 복사해 **두 저장소가 같은 값을 공유**하도록 맞춰야 합니다. 이 역할을 하는 것이 아래의 `syncWebToNative()` / `syncNativeToWeb()` 메소드입니다.

---

<a id="choose-approach"></a>
## 어떤 방식을 선택해야 하는가

Groobee iOS SDK는 하이브리드 앱에서 아래 두 가지 방식 중 하나를 사용합니다.

| 앱 구조 | 권장 방식 |
| --- | --- |
| WebView가 주 영역인 앱 | `syncWebToNative()` |
| 네이티브가 주 영역이고 일부만 WebView인 앱 | `syncNativeToWeb()` |

중요:

- `syncWebToNative()`와 `syncNativeToWeb()`는 **동시에 사용하지 않습니다.**
- 앱 구조에 맞는 한 가지 방식만 선택하세요.

<a id="web-to-native"></a>
<a id="set-webview-cookies"></a>
## 웹뷰에서 네이티브로 동기화

### `syncWebToNative(webView:urlRequest:)`

WebView가 주 영역인 하이브리드 앱에서 웹 기준 데이터를 앱으로 동기화합니다. `WKNavigationDelegate`의 `didFinish navigation`에서 호출합니다.

Swift:

```swift
import UIKit
import WebKit
import GroobeeKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        let urlRequest = URLRequest(url: webView.url!)
        Groobee.getInstance().syncWebToNative(webView: webView, urlRequest: urlRequest)
    }
}
```

Objective-C:

```objectivec
#import "ViewController.h"
#import <GroobeeKit/GroobeeKit-Swift.h>
#import <WebKit/WebKit.h>

@interface ViewController () <WKNavigationDelegate>

@end

@implementation ViewController

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:webView.URL];
    [[Groobee getInstance] syncWebToNativeWithWebView:webView urlRequest:urlRequest];
}

@end
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `webView` | `WKWebView` | 현재 사용 중인 WebView | 위 코드와 같이 삽입 |
| `urlRequest` | `URLRequest` | 현재 사용 중인 URL | 위 코드와 같이 삽입 |

설명:

- 이 메소드를 사용하지 않으면 웹에서의 유저 행동과 앱에서의 유저 행동이 다른 유저로 데이터가 쌓이게 됩니다.
- 보다 정확한 전환율 측정과 통계 데이터를 위해 사용합니다.

참고:

- **`setWebViewCookies(webView:urlRequest:)`는 같은 동작의 기존 이름이며 계속 지원됩니다.** 이미 연동한 앱은 코드를 바꿀 필요가 없습니다. `syncWebToNative()`는 `syncNativeToWeb()`과 이름 쌍을 맞추기 위해 SDK `1.1.12`에서 추가된 이름입니다.

<a id="native-to-web"></a>
## 네이티브에서 웹뷰로 동기화

### `syncNativeToWeb(_ domain:)`

> SDK `1.1.12` 이상에서 지원합니다.

네이티브가 주 영역인 하이브리드 앱에서 앱 기준 데이터(그루비 식별 쿠키 + 최근 본 상품 목록)를 WebView 쿠키에 동기화합니다.

Swift:

```swift
Groobee.configure(groobeeConfig: groobeeConfig)

Groobee.getInstance().syncNativeToWeb(".myshop.io")
Groobee.getInstance().syncNativeToWeb(".m.myshop.io")
```

Objective-C:

```objectivec
[Groobee configureWithGroobeeConfig:groobeeConfig];

[[Groobee getInstance] syncNativeToWeb:@".myshop.io"];
[[Groobee getInstance] syncNativeToWeb:@".m.myshop.io"];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `domain` | `String` | 쿠키 정보가 설정될 사이트 주소 | `.myshop.io` |

설명:

- `Groobee.configure()` 직후에 **웹뷰에서 사용하는 도메인마다 한 번씩** 호출합니다.
- 호출한 도메인은 SDK가 기억해 두고, 이후 상품 상세 수집(`setViewGoods()`)으로 최근 본 상품 목록이 바뀔 때마다 **자동으로 다시 기록**합니다. 상품을 볼 때마다 이 메소드를 다시 호출할 필요는 없습니다.
- 이 메소드를 사용하지 않으면 앱 행동과 웹 행동이 서로 다른 사용자로 집계되고, 앱에서 본 상품이 웹뷰 추천에 반영되지 않습니다.
- 외부 Safari와 `SFSafariViewController`는 앱 웹뷰와 격리된 별도 쿠키 저장소를 사용하므로 **적용 대상이 아닙니다.**

<a id="get-web-cookies"></a>
## 그루비 웹 쿠키 직접 가져오기

### `getGroobeeWebCookies()`

`syncNativeToWeb()`을 사용하지 않고, 네이티브 쿠키를 직접 WebView에 적용해야 할 때 사용합니다.

Swift:

```swift
let cookies = Groobee.getInstance().getGroobeeWebCookies()
```

Objective-C:

```objectivec
NSDictionary<NSString *, NSString *> *cookies = [[Groobee getInstance] getGroobeeWebCookies];
```

파라미터:

- 없음

설명:

- 그루비 스크립트가 인식할 수 있는 쿠키명(`key`)과 쿠키값(`value`)을 반환합니다. `for ... in` 반복문으로 `key`, `value`를 각각 꺼내 사용할 수 있습니다.
- 쿠키를 직접 주입해야 하는 특수 WebView 구성에서 유용합니다. Android SDK의 `getNativeCookie()`와 같은 자리입니다.
- ⚠️ **반환값에는 그루비 식별 쿠키만 담겨 있고 최근 본 상품 목록은 포함되지 않습니다.** 최근 본 상품까지 동기화하려면 `syncNativeToWeb()`을 사용하세요.

<a id="limitations"></a>
## 동작 한계

### 🔴 iOS 11 미만에서는 동기화가 동작하지 않습니다

`WKWebView`의 쿠키 저장소(`WKHTTPCookieStore`)에 접근할 공개 API가 iOS 11부터 제공되기 때문에, **iOS 10 이하에서는 쓰기와 읽기가 모두 동작하지 않습니다.**

- `syncNativeToWeb()` — 쿠키를 쓰지 않습니다. SDK가 경고 로그를 남깁니다.
- `syncWebToNative()` / `setWebViewCookies()` — 웹뷰 쿠키를 읽지 못합니다.

해당 단말에서는 앱과 웹이 다른 사용자로 집계되며, 앱 코드로 우회할 방법은 없습니다.

### 웹뷰 첫 진입 1회는 반영되지 않을 수 있습니다

호출 시점에 따라 웹뷰에 처음 진입하는 그 한 번은 최근 본 상품이 반영되지 않을 수 있습니다. `Groobee.configure()` 직후에 `syncNativeToWeb()`을 호출해 두면 이후 화면부터는 최신 목록이 유지됩니다.

### 최근 본 상품은 최대 12개까지 보관됩니다

웹 스크립트와 동일한 기준입니다. 직전에 본 상품과 같은 상품은 목록에 다시 추가하지 않습니다. 이 규칙은 SDK `1.1.12`에서 웹 스크립트와 통일되었으며, 그 이전 버전에서는 5개에서 잘렸습니다.

<a id="related-docs"></a>
## 함께 보면 좋은 문서

- [iOS SDK 회원 정보 및 푸시 상태 연동](./ios-sdk-member-push.md)
- [iOS SDK 행동 이력 수집](./ios-sdk-actions.md)
- [iOS SDK 추천 상품 연동](./ios-sdk-recommend.md)
- [iOS SDK 주의사항 및 로그 유틸리티](./ios-sdk-cautions-log.md)
- [Android SDK 하이브리드 앱 데이터 동기화](./android-sdk-hybrid-sync.md)

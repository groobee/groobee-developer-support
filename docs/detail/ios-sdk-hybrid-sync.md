# iOS SDK 하이브리드 앱 데이터 동기화

이 문서는 iOS Native SDK와 Flutter iOS SDK 공통 기준으로, `WKWebView`가 포함된 하이브리드 앱에서 Groobee 데이터를 **앱 네이티브 영역과 웹뷰 영역 사이에 동기화**하는 방법을 정리한 문서입니다.

---

## 목차

1. [왜 웹-네이티브 동기화가 필요한가](#why-sync)
2. [Groobee 웹 쿠키 가져오기](#get-web-cookies)
3. [웹뷰 데이터 동기화](#set-webview-cookies)
4. [함께 보면 좋은 문서](#related-docs)

---

<a id="why-sync"></a>
## 왜 웹-네이티브 동기화가 필요한가

Groobee는 사용자를 식별할 때 **Groobee가 자체적으로 발급·관리하는 쿠키 값**을 기준으로 사용합니다. 이 쿠키 값이 같으면 동일 사용자, 다르면 서로 다른 사용자로 집계됩니다.

문제는 하이브리드 앱에서 쿠키 저장소가 **두 개로 분리**된다는 점입니다.

- **앱 네이티브 영역**: Groobee iOS SDK(`GroobeeKit`)가 앱 내부 저장소에 자체 식별 값을 생성·보관합니다.
- **앱 내부 웹뷰 영역**: `WKWebView`는 별도의 쿠키 저장소(`WKHTTPCookieStore`)를 사용합니다. 같은 웹사이트라도 외부 Safari와 앱 웹뷰의 쿠키 저장소는 서로 격리되어 있습니다.

동기화를 하지 않으면 아래와 같은 상황이 발생합니다.

- 앱 네이티브에서는 `id=AAA-111`로 식별되는 사용자가
- 앱 웹뷰 안에서는 웹 스크립트가 새 쿠키 `id=BBB-222`를 발급하면서

같은 사용자가 **서로 다른 두 사용자로 중복 수집**됩니다. 세그먼트, 인앱메시지 타겟팅, 전환 통계, 추천 데이터 모두 영향을 받습니다.

이 문제를 피하려면 앱 네이티브와 웹뷰 중 한쪽이 보유한 Groobee 식별 쿠키 값을 다른 쪽에 복사해 **두 저장소가 같은 값을 공유**하도록 맞춰야 합니다. 이 역할을 하는 것이 아래의 `getGroobeeWebCookies()` / `setWebViewCookies()` 메소드입니다.

---

<a id="get-web-cookies"></a>
## Groobee 웹 쿠키 가져오기

### `getGroobeeWebCookies()`

Swift:

```swift
Groobee.getInstance().getGroobeeWebCookies()
```

Objective-C:

```objectivec
[[Groobee getInstance] getGroobeeWebCookies];
```

파라미터:

- 없음

설명:

- WebView를 여러 페이지에서 사용해야 할 경우 기존에 사용하던 쿠키를 네이티브에 sync 해놓고 사용하게 됩니다.
- 이때 sync된 쿠키 값을 다시 읽어 와서 새로운 WebView에 Groobee 스크립트가 인식할 수 있는 쿠키 정보로 세팅하기 위해 쿠키명(`key`)과 쿠키값(`value`)을 가져오는 함수입니다.
- `for ... in` 반복문을 통해 `key`, `value` 값을 각각 가져올 수 있습니다.

<a id="set-webview-cookies"></a>
## 웹뷰 데이터 동기화

### `setWebViewCookies(webView, urlRequest)`

Swift:

```swift
import UIKit
import WebKit
import GroobeeKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        let urlRequest = URLRequest(url: webView.url!)
        Groobee.getInstance().setWebViewCookies(webView: webView, urlRequest: urlRequest)
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
    [[Groobee getInstance] setWebViewCookiesWithWebView:webView urlRequest:urlRequest];
}

@end
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `webView` | `WKWebView` | 현재 사용 중인 WebView | 위 코드와 같이 삽입 |
| `urlRequest` | `URLRequest` | 현재 사용 중인 URL | 위 코드와 같이 삽입 |

설명:

- 웹뷰와 네이티브 영역이 혼합된 앱이라면 `setWebViewCookies()` 메소드를 호출하여 웹과 앱 간 데이터 싱크를 맞추는 것을 권장합니다.
- `setWebViewCookies()` 메소드를 사용하지 않을 경우 웹에서의 유저 행동과 앱에서의 유저 행동이 다른 유저로 데이터가 쌓이게 됩니다.
- 보다 정확한 전환율 측정과 통계 데이터를 위해 사용합니다.

<a id="related-docs"></a>
## 함께 보면 좋은 문서

- [iOS SDK 회원 정보 및 푸시 상태 연동](./ios-sdk-member-push.md)
- [iOS SDK 행동 이력 수집](./ios-sdk-actions.md)
- [iOS SDK 주의사항 및 로그 유틸리티](./ios-sdk-cautions-log.md)

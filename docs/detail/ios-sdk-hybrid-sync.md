# iOS SDK 하이브리드 앱 데이터 동기화

## 그루비 웹 쿠키 가져오기

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
- 이때 sync된 쿠키 값을 다시 읽어 와서 새로운 WebView에 그루비 스크립트가 인식할 수 있는 쿠키 정보로 세팅하기 위해 쿠키명(`key`)과 쿠키값(`value`)을 가져오는 함수입니다.
- `for ... in` 반복문을 통해 `key`, `value` 값을 각각 가져올 수 있습니다.

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

## 함께 보면 좋은 문서

- [iOS SDK 회원 정보 및 푸시 상태 연동](./ios-sdk-member-push.md)
- [iOS SDK 화면 이벤트 및 행동 이력 연동](./ios-sdk-screen-events.md)
- [iOS SDK 주의사항 및 로그 유틸리티](./ios-sdk-cautions-log.md)

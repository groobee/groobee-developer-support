# iOS SDK 주의사항 및 로그 유틸리티

## WebView에서 InAppMessage 사용 시 주의사항

WebView에서 InAppMessage 기능을 사용할 때 `ViewController`의 `rootView`에서 WebView를 `subView`로 추가하면 정상 동작합니다.  
반대로 `override func loadView()` 같은 함수로 `rootView`를 WebView로 설정하면 InAppMessage와 WebView 모두 보이지 않고 Black Screen 오류가 발생할 수 있습니다.

### 오류 예시

```swift
import UIKit
import WebKit
import GroobeeKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "URL")
        let request = URLRequest(url: url!)
        self.webView.load(request)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        Groobee.getInstance().setScreenData(screenName: "SCREEN_NAME", screenId: "SCREEN_ID")
    }
}
```

### 정상 예시

```swift
import UIKit
import WebKit
import GroobeeKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        let url = URL(string: "URL")
        let request = URLRequest(url: url!)
        self.webView.load(request)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self

        Groobee.getInstance().setScreenData(screenName: "SCREEN_NAME", screenId: "SCREEN_ID")
    }
}
```

## 로그 유틸리티 사용법

그루비 SDK는 상세 로그를 확인할 수 있도록 `LoggerUtils`라는 로그 클래스를 제공합니다.

| 메소드 | 설명 |
| --- | --- |
| `setLogLevel` | 로그 레벨을 설정합니다. `verbose`, `debug`, `info`, `warn`, `error`, `none`가 있으며 `verbose`가 가장 자세한 로그를 출력합니다. |
| `setDetailLogEnabled` | 평소에는 간략하게 표기되는 일부 로그를, 디버깅이 필요할 때 더 상세하게 출력하도록 전환하는 옵션입니다. |
| `setTraceEnabled` | 추적 아이디를 활성화합니다. |
| `setLogCallback` | 로그 내용을 별도로 처리할 수 있는 콜백을 등록합니다. |
| `setOptions` | 위 옵션들을 키-값 형태로 한 번에 설정하는 대체 API입니다. 지원 옵션: `LOG_LEVEL` (`GroobeeLogLevel` raw value) — 로그 레벨, `DETAIL_LOG_ENABLED` (boolean) — 상세 로그 활성화, `TRACE_ENABLED` (boolean) — 추적 아이디 활성화, `LOG_CALLBACK` (`GroobeeLogCallback`) — 로그 콜백 등록. |

Swift 예시:

```swift
import GroobeeKit

class MyLogger: NSObject, GroobeeLogCallback {
    func onLog(level: Int, tag: String, message: String) {
        print("Groobee Log :", message)
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LoggerUtils.setLogLevel(GroobeeLogLevel.verbose.rawValue)
        LoggerUtils.setDetailLogEnabled(true)
        LoggerUtils.setTraceEnabled(true)
        LoggerUtils.setLogCallback(MyLogger())

//        LoggerUtils.setOptions("LOG_LEVEL", value: GroobeeLogLevel.verbose.rawValue)
//        LoggerUtils.setOptions("DETAIL_LOG_ENABLED", value: true)
//        LoggerUtils.setOptions("TRACE_ENABLED", value: true)
//        LoggerUtils.setOptions("LOG_CALLBACK", value: logger)

        return true
    }
}
```

## 함께 보면 좋은 문서

- [iOS SDK 설치 가이드](../installation/installation-ios-sdk.md)
- [iOS SDK 하이브리드 앱 데이터 동기화](./ios-sdk-hybrid-sync.md)
- [iOS SDK 행동 이력 수집](./ios-sdk-actions.md)

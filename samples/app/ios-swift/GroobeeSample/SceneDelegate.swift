import UIKit
import GroobeeKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let nav = UINavigationController(rootViewController: ViewController())
        nav.navigationBar.prefersLargeTitles = true

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()

        if let url = connectionOptions.urlContexts.first?.url {
            AppLog.shared.log("딥링크(scene 시작): \(url.absoluteString)")
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            AppLog.shared.log("딥링크 수신: \(url.absoluteString)")
        }
    }

    // ─────────── GroobeeKit 라이프사이클 연결 (iOS 13+) [필수] ───────────
    // iOS 13 미만을 지원해야 한다면 AppDelegate 의
    // applicationDidBecomeActive / WillResignActive / DidEnterBackground /
    // WillEnterForeground / WillTerminate 에 동일한 호출을 추가하세요.

    func sceneDidBecomeActive(_ scene: UIScene) {
        GroobeeKitLifeCycle.sceneDidBecomeActive()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        GroobeeKitLifeCycle.sceneWillResignActive()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        GroobeeKitLifeCycle.sceneWillEnterForeground()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        GroobeeKitLifeCycle.sceneDidEnterBackground()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        GroobeeKitLifeCycle.sceneDidDisconnect()
    }
}

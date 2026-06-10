import Flutter
import UIKit
import GroobeeKit

/// iOS 13+ 라이프사이클을 GroobeeKitLifeCycle 에 연결합니다. [필수]
class SceneDelegate: FlutterSceneDelegate {

  override func sceneDidBecomeActive(_ scene: UIScene) {
    GroobeeKitLifeCycle.sceneDidBecomeActive()
    super.sceneDidBecomeActive(scene)
  }

  override func sceneWillResignActive(_ scene: UIScene) {
    GroobeeKitLifeCycle.sceneWillResignActive()
    super.sceneWillResignActive(scene)
  }

  override func sceneWillEnterForeground(_ scene: UIScene) {
    GroobeeKitLifeCycle.sceneWillEnterForeground()
    super.sceneWillEnterForeground(scene)
  }

  override func sceneDidEnterBackground(_ scene: UIScene) {
    GroobeeKitLifeCycle.sceneDidEnterBackground()
    super.sceneDidEnterBackground(scene)
  }

  override func sceneDidDisconnect(_ scene: UIScene) {
    GroobeeKitLifeCycle.sceneDidDisconnect()
    super.sceneDidDisconnect(scene)
  }
}

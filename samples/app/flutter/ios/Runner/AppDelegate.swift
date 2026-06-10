import Flutter
import UIKit
import GroobeeKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

  private var methodChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Groobee 초기화(configure)는 Dart 가 groobee_config.json 의 서비스키로 호출합니다.
    // (아래 MethodChannel "configure" 핸들러 참고)

    // 푸시 권한 요청 (FCM 토큰은 Dart 측 firebase_messaging 에서 발급해 setPushToken 으로 전달)
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, _ in
      guard granted else { return }
      DispatchQueue.main.async { application.registerForRemoteNotifications() }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Flutter 3.x implicit-engine: 플러그인 등록 + MethodChannel 설정
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "GroobeeBridge") else { return }
    let channel = FlutterMethodChannel(name: "io.groobee.sample/bridge", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    methodChannel = channel
  }

  // MARK: - MethodChannel 핸들러 (Dart → GroobeeKit)

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let g = Groobee.getInstance()
    let args = (call.arguments as? [String: Any]) ?? [:]

    switch call.method {
    case "configure":
      // Groobee 초기화 (서비스키는 Dart 의 groobee_config.json 에서 전달받음)
      let key = args["serviceKey"] as? String ?? ""
      let config = GroobeeConfig.GroobeeConfigBuilder()
        .setServiceKey(serviceKey: key, bundleId: Bundle.main.bundleIdentifier ?? "")
        .setInAppMsgMarginTop(50)
        .setInAppMsgMarginBottom(17)
        .setNotificationSettingsButton("알림 설정", "groobeesample://setting/notification")
        .build()
      Groobee.configure(groobeeConfig: config)
      result(nil)
    case "setServiceLogin":
      g.setServiceLogin(memberId: args["memberId"] as? String)
      result(nil)
    case "serviceLogout":
      g.serviceLogout()
      g.memberDataClear()
      result(nil)
    case "setMember":
      // setUserInfo 인자 순서: id, grade, age, gender, type
      g.setUserInfo(
        id: args["id"] as? String ?? "",
        grade: args["grade"] as? String ?? "",
        age: args["age"] as? String ?? "",
        gender: args["gender"] as? String ?? "",
        type: args["type"] as? String ?? ""
      )
      result(nil)
    case "setPushToken":
      if let token = args["token"] as? String { g.setPushToken(pushToken: token) }
      result(nil)
    case "setPushAgree":
      let isAgreed = args["isAgreed"] as? Bool ?? false
      switch args["type"] as? String {
      case "AP": g.setPushAgreeAP(isPushAgreedAP: isAgreed)
      case "AA": g.setPushAgreeAA(isPushAgreedAA: isAgreed)
      case "AN": g.setPushAgreeAN(isPushAgreedAN: isAgreed)
      default: break
      }
      result(nil)
    case "getPushAgreed":
      g.getPushAgreed(memberId: args["memberId"] as? String ?? "", responseAgreeds: ResponseAgreedsHandler(result))
    case "setScreenData":
      g.setScreenData(screenName: args["screenName"] as? String ?? "", screenId: args["screenId"] as? String ?? "")
      result(nil)
    case "setSearchKeyword":
      g.setSearchKeyword(searchKwd: args["keyword"] as? String ?? "", screenId: args["screenId"] as? String ?? "")
      result(nil)
    case "setViewGoods":
      g.setViewGoods(goods: goodsFromMap(args["goods"] as? [String: Any]), screenId: args["screenId"] as? String ?? "")
      result(nil)
    case "setCategory":
      g.setCategory(cateCd: args["cateCd"] as? String ?? "", cateNm: args["cateNm"] as? String ?? "", screenId: args["screenId"] as? String ?? "")
      result(nil)
    case "setShoppingCart":
      g.setShoppingCart(goods: goodsList(args["goods"]), screenId: args["screenId"] as? String ?? "")
      result(nil)
    case "setGoodsOrder":
      g.setGoodsOrder(goods: goodsList(args["goods"]), screenId: args["screenId"] as? String ?? "")
      result(nil)
    case "setGoodsOrderComplete":
      g.setGoodsOrderComplete(orderNo: args["orderNo"] as? String ?? "", goods: goodsList(args["goods"]), screenId: args["screenId"] as? String ?? "")
      result(nil)
    case "setCustomEvent":
      // iOS 인자 순서: eventKey, screenId, eventValue
      g.setCustomEvent(eventKey: args["eventKey"] as? String ?? "", screenId: args["screenId"] as? String ?? "", eventValue: args["eventValue"] as? String ?? "")
      result(nil)
    case "getRecommendGoods":
      g.getRecommendGoods(campaignKey: args["campaignKey"] as? String ?? "", responseGoods: ResponseGoodsHandler(result))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func goodsFromMap(_ map: [String: Any]?) -> Goods {
    let m = map ?? [:]
    let goods = Goods()
    if let v = m["goodsCd"] as? String { _ = goods.setGoodsCd(v) }
    if let v = m["goodsNm"] as? String { _ = goods.setGoodsNm(v) }
    if let v = m["goodsCate"] as? String { _ = goods.setGoodsCate(v) }
    if let v = m["goodsCateNm"] as? String { _ = goods.setGoodsCateNm(v) }
    if let v = m["goodsImg"] as? String { _ = goods.setGoodsImg(v) }
    if let v = m["goodsPrc"] as? Int { _ = goods.setGoodsPrc(v) }
    if let v = m["goodsSalePrc"] as? Int { _ = goods.setGoodsSalePrc(v) }
    if let v = m["goodsAmt"] as? Int { _ = goods.setGoodsAmt(v) }
    if let v = m["goodsCnt"] as? Int { _ = goods.setGoodsCnt(v) }
    return goods
  }

  private func goodsList(_ array: Any?) -> [Goods] {
    guard let list = array as? [[String: Any]] else { return [] }
    return list.map { goodsFromMap($0) }
  }

  // MARK: - 푸시 수신/응답을 Groobee 로 전달
  //  (FCM 토큰/APNs 토큰 처리는 firebase_messaging 플러그인이 담당)

  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    Groobee.getInstance().didReceiveRemoteNotification(userInfo: userInfo)
    super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .list, .badge, .sound])
    } else {
      completionHandler([.alert, .badge, .sound])
    }
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    if Groobee.getInstance().userNotificationCenter(response: response) {
      completionHandler()
      return
    }
    super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }
}

// MARK: - 비동기 응답 핸들러 (@objc 프로토콜 → FlutterResult)

final class ResponseAgreedsHandler: NSObject, ResponseAgreeds {
  private let result: FlutterResult
  init(_ result: @escaping FlutterResult) { self.result = result }

  func onSuccess(agreeds: Agreeds) {
    let payload: [String: Any] = [
      "agreedAP": agreeds.agreedAP,
      "agreedAA": agreeds.agreedAA,
      "agreedAN": agreeds.agreedAN,
    ]
    let json = (try? JSONSerialization.data(withJSONObject: payload))
      .flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
    DispatchQueue.main.async { self.result(json) }
  }

  func onFailed(exceptionMsg: String) {
    DispatchQueue.main.async { self.result(FlutterError(code: "GROOBEE", message: exceptionMsg, details: nil)) }
  }
}

final class ResponseGoodsHandler: NSObject, ResponseGoods {
  private let result: FlutterResult
  init(_ result: @escaping FlutterResult) { self.result = result }

  func onSuccess(aiRecommend: ArtificialRecommend) {
    let g = Groobee.getInstance()
    let list = aiRecommend.getRecommendList() ?? []
    let campaignKey = aiRecommend.getCampaignKey() ?? ""
    let algorithmCd = aiRecommend.getAlgorithmCd() ?? ""
    let requestId = aiRecommend.getRequestId() ?? ""

    if !list.isEmpty, !campaignKey.isEmpty, !algorithmCd.isEmpty {
      // 노출/클릭 통계 전송 (데모: 첫 상품 클릭 가정)
      g.setShowRecommendGoods(goods: list, campaignKey: campaignKey, algorithmCd: algorithmCd, requestId: requestId)
      if let first = list.first {
        g.setClickRecommendGoods(goods: first, campaignKey: campaignKey, algorithmCd: algorithmCd, requestId: requestId)
      }
    }

    let payload: [String: Any] = [
      "campaignKey": campaignKey,
      "algorithmCd": algorithmCd,
      "requestId": requestId,
      "goodsList": list.map { ["goodsNm": $0.goodsNm ?? "", "goodsCd": $0.goodsCd ?? ""] },
    ]
    let json = (try? JSONSerialization.data(withJSONObject: payload))
      .flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
    DispatchQueue.main.async { self.result(json) }
  }

  func onFailed(exceptionMsg: String, campaignKey: String) {
    DispatchQueue.main.async { self.result(FlutterError(code: "GROOBEE", message: exceptionMsg, details: campaignKey)) }
  }
}

import 'package:flutter/services.dart';

import 'goods.dart';

/// Dart ↔ 네이티브(iOS GroobeeKit / Android groobee-sdk-message) 브리지.
///
/// Groobee 는 순수 Dart 패키지가 없으므로 MethodChannel 로 네이티브 SDK 를 호출합니다.
/// 여기서는 플랫폼 공통 메소드 이름을 사용하고, 플랫폼별 차이(메소드명/인자 순서 등)는
/// 각 네이티브 핸들러(AppDelegate.swift / MainActivity.kt)에서 흡수합니다.
class GroobeeBridge {
  GroobeeBridge._();
  static final GroobeeBridge instance = GroobeeBridge._();

  static const MethodChannel _channel = MethodChannel('io.groobee.sample/bridge');

  // ── 초기화 ────────────────────────────────────────────────────
  /// 네이티브에서 Groobee.configure 를 수행합니다. (다른 호출 이전에 1회)
  Future<void> configure(String serviceKey) =>
      _channel.invokeMethod('configure', {'serviceKey': serviceKey});

  // ── 회원 / 로그인 ──────────────────────────────────────────────
  Future<void> setServiceLogin(String memberId) =>
      _channel.invokeMethod('setServiceLogin', {'memberId': memberId});

  Future<void> serviceLogout() => _channel.invokeMethod('serviceLogout');

  Future<void> setMember({
    required String id,
    required String grade,
    required String gender,
    required String age,
    required String type,
  }) =>
      _channel.invokeMethod('setMember', {
        'id': id,
        'grade': grade,
        'gender': gender,
        'age': age,
        'type': type,
      });

  // ── 푸시 ──────────────────────────────────────────────────────
  Future<void> setPushToken(String token) =>
      _channel.invokeMethod('setPushToken', {'token': token});

  /// type: "AP"(전체) | "AA"(광고) | "AN"(야간)
  Future<void> setPushAgree(String type, bool isAgreed) =>
      _channel.invokeMethod('setPushAgree', {'type': type, 'isAgreed': isAgreed});

  /// 동의 상태를 JSON 문자열로 반환: {"agreedAP":true,"agreedAA":false,"agreedAN":false}
  Future<String?> getPushAgreed(String memberId) =>
      _channel.invokeMethod<String>('getPushAgreed', {'memberId': memberId});

  // ── 행동 이력 ─────────────────────────────────────────────────
  Future<void> setScreenData(String screenName, String screenId) =>
      _channel.invokeMethod('setScreenData', {'screenName': screenName, 'screenId': screenId});

  Future<void> setSearchKeyword(String keyword, String screenId) =>
      _channel.invokeMethod('setSearchKeyword', {'keyword': keyword, 'screenId': screenId});

  Future<void> setViewGoods(Goods goods, String screenId) =>
      _channel.invokeMethod('setViewGoods', {'goods': goods.toMap(), 'screenId': screenId});

  Future<void> setCategory(String cateCd, String cateNm, String screenId) =>
      _channel.invokeMethod('setCategory', {'cateCd': cateCd, 'cateNm': cateNm, 'screenId': screenId});

  Future<void> setShoppingCart(List<Goods> goods, String screenId) =>
      _channel.invokeMethod('setShoppingCart', {
        'goods': goods.map((g) => g.toMap()).toList(),
        'screenId': screenId,
      });

  Future<void> setGoodsOrder(List<Goods> goods, String screenId) =>
      _channel.invokeMethod('setGoodsOrder', {
        'goods': goods.map((g) => g.toMap()).toList(),
        'screenId': screenId,
      });

  Future<void> setGoodsOrderComplete(String orderNo, List<Goods> goods, String screenId) =>
      _channel.invokeMethod('setGoodsOrderComplete', {
        'orderNo': orderNo,
        'goods': goods.map((g) => g.toMap()).toList(),
        'screenId': screenId,
      });

  Future<void> setCustomEvent(String eventKey, String eventValue, String screenId) =>
      _channel.invokeMethod('setCustomEvent', {
        'eventKey': eventKey,
        'eventValue': eventValue,
        'screenId': screenId,
      });

  // ── AI 추천 ───────────────────────────────────────────────────
  /// 추천 결과를 JSON 문자열로 반환합니다.
  /// (네이티브에서 노출/클릭 통계 전송까지 함께 처리)
  Future<String?> getRecommendGoods(String campaignKey) =>
      _channel.invokeMethod<String>('getRecommendGoods', {'campaignKey': campaignKey});
}

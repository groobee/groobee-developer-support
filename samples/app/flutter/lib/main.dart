import 'package:flutter/material.dart';

import 'groobee/goods.dart';
import 'groobee/groobee_bridge.dart';
import 'groobee/push_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GroobeeSampleApp());
}

class GroobeeSampleApp extends StatelessWidget {
  const GroobeeSampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groobee Flutter Sample',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF3F51B5),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/// 데모 화면 식별자(screenId)
class Screen {
  static const home = 'HOME';
  static const search = 'SEARCH';
  static const product = 'PRODUCT_DETAIL';
  static const category = 'CATEGORY';
  static const cart = 'CART';
  static const order = 'ORDER';
  static const orderComplete = 'ORDER_COMPLETE';
}

const String demoMemberId = 'groobee_demo_user';

/// 서비스키 / 추천 캠페인키는 groobee_config.json 에서 주입됩니다.
///   flutter run --dart-define-from-file=groobee_config.json
/// (값이 없으면 placeholder 로 동작)
const String serviceKey =
    String.fromEnvironment('GROOBEE_SERVICE_KEY', defaultValue: 'YOUR_GROOBEE_SERVICE_KEY');
const String recommendCampaignKey =
    String.fromEnvironment('GROOBEE_RECOMMEND_CAMPAIGN_KEY', defaultValue: 'YOUR_RECOMMEND_CAMPAIGN_KEY');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bridge = GroobeeBridge.instance;
  final _memberIdController = TextEditingController(text: demoMemberId);
  final List<String> _logs = [];

  bool _agreePush = true;
  bool _agreeAd = true;
  bool _agreeNight = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // 1) Groobee 초기화 (다른 호출 이전에 1회)
    await _call('Groobee 초기화 configure', () => _bridge.configure(serviceKey));
    // 2) 현재 화면(홈) 진입 이력
    await _call('화면 진입 setScreenData(HOME)', () => _bridge.setScreenData('홈', Screen.home));
    // 3) FCM 토큰 발급 → Groobee 전달
    await PushHelper.initAndRegisterToken(log: _log);
  }

  @override
  void dispose() {
    _memberIdController.dispose();
    super.dispose();
  }

  // ── 공통 헬퍼 ────────────────────────────────────────────────
  void _log(String message) {
    if (!mounted) return;
    setState(() => _logs.insert(0, '· $message'));
  }

  Future<void> _call(String label, Future<void> Function() action) async {
    try {
      await action();
      _log(label);
    } catch (e) {
      _log('실패: $label ($e)');
    }
  }

  List<Goods> _sampleCart() => const [
        Goods(
          goodsCd: '0011',
          goodsNm: '파란색 줄무늬 티셔츠',
          goodsCate: 'C99',
          goodsCateNm: '티셔츠',
          goodsPrc: 25000,
          goodsSalePrc: 20000,
          goodsAmt: 20000,
          goodsCnt: 1,
        ),
        Goods(
          goodsCd: '0012',
          goodsNm: '흰색 줄무늬 티셔츠',
          goodsCate: 'C99',
          goodsCateNm: '티셔츠',
          goodsPrc: 20000,
          goodsSalePrc: 15000,
          goodsAmt: 45000,
          goodsCnt: 3,
        ),
      ];

  Goods _sampleGoods() => _sampleCart().first;

  // ── 빌드 ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groobee Flutter Sample'),
        actions: [
          TextButton(
            onPressed: () => setState(_logs.clear),
            child: const Text('로그 지우기'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _section('① 회원 / 로그인'),
                  TextField(
                    controller: _memberIdController,
                    decoration: const InputDecoration(
                      labelText: '회원 ID',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _button('로그인 (setServiceLogin)', () {
                    _call('로그인 setServiceLogin', () => _bridge.setServiceLogin(_memberIdController.text));
                  }),
                  _button('회원정보 설정 (setMember)', () {
                    _call('회원정보 setMember', () => _bridge.setMember(
                          id: _memberIdController.text,
                          grade: 'VIP',
                          gender: 'M',
                          age: '30',
                          type: 'general',
                        ));
                  }),
                  _button('로그아웃 (serviceLogout)', () {
                    _call('로그아웃 serviceLogout', () => _bridge.serviceLogout());
                  }),

                  _section('② 푸시 (Push)'),
                  _switch('전체 푸시 동의 (AP)', _agreePush, (v) {
                    setState(() => _agreePush = v);
                    _call('setPushAgree(AP,$v)', () => _bridge.setPushAgree('AP', v));
                  }),
                  _switch('광고 푸시 동의 (AA)', _agreeAd, (v) {
                    setState(() => _agreeAd = v);
                    _call('setPushAgree(AA,$v)', () => _bridge.setPushAgree('AA', v));
                  }),
                  _switch('야간 푸시 동의 (AN)', _agreeNight, (v) {
                    setState(() => _agreeNight = v);
                    _call('setPushAgree(AN,$v)', () => _bridge.setPushAgree('AN', v));
                  }),
                  _button('동의 상태 조회 (getPushAgreed)', () async {
                    final json = await _bridge.getPushAgreed(_memberIdController.text);
                    _log('동의 상태: ${json ?? "-"}');
                  }),

                  _section('③ 행동 이력 (Actions)'),
                  _button('검색 (setSearchKeyword)', () {
                    _call('검색 setSearchKeyword', () => _bridge.setSearchKeyword('겨울 패딩', Screen.search));
                  }),
                  _button('상품 상세 (setViewGoods)', () {
                    _call('상품상세 setViewGoods', () => _bridge.setViewGoods(_sampleGoods(), Screen.product));
                  }),
                  _button('카테고리 (setCategory)', () {
                    _call('카테고리 setCategory', () => _bridge.setCategory('C99', '티셔츠', Screen.category));
                  }),
                  _button('장바구니 (setShoppingCart)', () {
                    _call('장바구니 setShoppingCart', () => _bridge.setShoppingCart(_sampleCart(), Screen.cart));
                  }),
                  _button('주문서 (setGoodsOrder)', () {
                    _call('주문서 setGoodsOrder', () => _bridge.setGoodsOrder(_sampleCart(), Screen.order));
                  }),
                  _button('주문 완료 (setGoodsOrderComplete)', () {
                    _call('주문완료 setGoodsOrderComplete',
                        () => _bridge.setGoodsOrderComplete('ORD-20260609-0001', _sampleCart(), Screen.orderComplete));
                  }),
                  _button('커스텀 이벤트 (setCustomEvent)', () {
                    _call('커스텀이벤트 setCustomEvent', () => _bridge.setCustomEvent('wishlist_add', '0011', Screen.home));
                  }),

                  _section('④ AI 추천 (Recommend)'),
                  _button('추천 상품 요청 (getRecommendGoods)', () async {
                    _log('추천 요청 getRecommendGoods($recommendCampaignKey)');
                    final json = await _bridge.getRecommendGoods(recommendCampaignKey);
                    _log('추천 결과: ${json ?? "-"}');
                  }),
                ],
              ),
            ),
          ),
          _logView(),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 4),
        child: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF303F9F)),
        ),
      );

  Widget _button(String label, VoidCallback onPressed) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(alignment: Alignment.centerLeft),
          onPressed: onPressed,
          child: Text(label),
        ),
      );

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) => SwitchListTile(
        title: Text(label, style: const TextStyle(fontSize: 14)),
        value: value,
        onChanged: onChanged,
        dense: true,
      );

  Widget _logView() => Container(
        height: 200,
        width: double.infinity,
        color: const Color(0xFF1E1E2A),
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _logs.length,
          itemBuilder: (_, i) => Text(
            _logs[i],
            style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 11, fontFamily: 'monospace'),
          ),
        ),
      );
}

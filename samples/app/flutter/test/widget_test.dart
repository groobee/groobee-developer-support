// Goods 모델 단위 테스트.
//
// (전체 위젯 테스트는 네이티브 MethodChannel/Firebase 가 필요하므로 생략하고,
//  플랫폼에 의존하지 않는 모델 변환만 검증합니다.)
import 'package:flutter_test/flutter_test.dart';
import 'package:groobee_sample/groobee/goods.dart';

void main() {
  test('Goods.toMap 은 null 이 아닌 필드만 SDK 키로 직렬화한다', () {
    const goods = Goods(
      goodsCd: '0011',
      goodsNm: '파란색 줄무늬 티셔츠',
      goodsPrc: 25000,
      goodsSalePrc: 20000,
      goodsCnt: 1,
    );

    final map = goods.toMap();

    expect(map['goodsCd'], '0011');
    expect(map['goodsNm'], '파란색 줄무늬 티셔츠');
    expect(map['goodsPrc'], 25000);
    expect(map['goodsSalePrc'], 20000);
    expect(map['goodsCnt'], 1);
    // null 필드는 포함되지 않아야 한다
    expect(map.containsKey('goodsImg'), false);
    expect(map.containsKey('goodsAmt'), false);
  });
}

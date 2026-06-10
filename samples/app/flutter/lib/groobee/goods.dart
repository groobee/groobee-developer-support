/// 행동 이력 / 추천에 사용하는 상품 모델.
///
/// 네이티브(MethodChannel)로 넘길 때는 [toMap] 으로 변환합니다.
/// 키 이름은 네이티브 SDK 의 Goods 필드명과 동일합니다.
class Goods {
  final String? goodsCd;
  final String? goodsNm;
  final String? goodsCate;
  final String? goodsCateNm;
  final String? goodsImg;
  final int? goodsPrc; // 판매가(원가)
  final int? goodsSalePrc; // 할인 판매가
  final int? goodsAmt; // 결제 금액 (salePrc * cnt)
  final int? goodsCnt; // 수량

  const Goods({
    this.goodsCd,
    this.goodsNm,
    this.goodsCate,
    this.goodsCateNm,
    this.goodsImg,
    this.goodsPrc,
    this.goodsSalePrc,
    this.goodsAmt,
    this.goodsCnt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (goodsCd != null) map['goodsCd'] = goodsCd;
    if (goodsNm != null) map['goodsNm'] = goodsNm;
    if (goodsCate != null) map['goodsCate'] = goodsCate;
    if (goodsCateNm != null) map['goodsCateNm'] = goodsCateNm;
    if (goodsImg != null) map['goodsImg'] = goodsImg;
    if (goodsPrc != null) map['goodsPrc'] = goodsPrc;
    if (goodsSalePrc != null) map['goodsSalePrc'] = goodsSalePrc;
    if (goodsAmt != null) map['goodsAmt'] = goodsAmt;
    if (goodsCnt != null) map['goodsCnt'] = goodsCnt;
    return map;
  }
}

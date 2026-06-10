import GroobeeKit

/// 행동 이력 / 추천 데모에서 사용할 샘플 상품 데이터.
///
/// Goods 는 체이닝 가능한 setter 로 구성합니다.
///  - 금액(setGoodsPrc / setGoodsSalePrc / setGoodsAmt)과 수량(setGoodsCnt)은 Int
enum DemoData {

    static func sampleGoods() -> Goods {
        Goods()
            .setGoodsNm("파란색 줄무늬 티셔츠")
            .setGoodsCd("0011")
            .setGoodsCate("C99")
            .setGoodsCateNm("티셔츠")
            .setGoodsPrc(25_000)      // 판매가(원가)
            .setGoodsSalePrc(20_000)  // 할인 판매가
            .setGoodsAmt(20_000)      // 결제 금액 (salePrc * cnt)
            .setGoodsImg("https://shop.example.com/web/product/0011.png")
            .setGoodsCnt(1)
    }

    static func sampleCart() -> [Goods] {
        [
            Goods()
                .setGoodsNm("파란색 줄무늬 티셔츠")
                .setGoodsCd("0011")
                .setGoodsCate("C99")
                .setGoodsCateNm("티셔츠")
                .setGoodsPrc(25_000)
                .setGoodsSalePrc(20_000)
                .setGoodsAmt(20_000)
                .setGoodsImg("https://shop.example.com/web/product/0011.png")
                .setGoodsCnt(1),
            Goods()
                .setGoodsNm("흰색 줄무늬 티셔츠")
                .setGoodsCd("0012")
                .setGoodsCate("C99")
                .setGoodsCateNm("티셔츠")
                .setGoodsPrc(20_000)
                .setGoodsSalePrc(15_000)
                .setGoodsAmt(45_000)
                .setGoodsImg("https://shop.example.com/web/product/0012.png")
                .setGoodsCnt(3)
        ]
    }
}

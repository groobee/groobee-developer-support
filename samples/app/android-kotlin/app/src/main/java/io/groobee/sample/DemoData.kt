package io.groobee.sample

import io.groobee.message.models.Goods

/**
 * 행동 이력 / 추천 데모에서 사용할 샘플 상품 데이터.
 *
 * Goods 모델은 빌더 패턴으로 생성합니다.
 *  - 금액 필드(goodsPrc / goodsSalePrc / goodsAmt)는 Long
 *  - 수량(goodsCnt)은 Int
 */
object DemoData {

    fun sampleGoods(): Goods = Goods.builder()
        .goodsNm("파란색 줄무늬 티셔츠")
        .goodsCd("0011")
        .goodsCate("C99")
        .goodsCateNm("티셔츠")
        .goodsPrc(25000L)       // 판매가(원가)
        .goodsSalePrc(20000L)   // 할인 판매가
        .goodsAmt(20000L)       // 결제 금액 (salePrc * cnt)
        .goodsImg("https://shop.example.com/web/product/0011.png")
        .goodsCnt(1)
        .build()

    fun sampleCart(): List<Goods> = listOf(
        Goods.builder()
            .goodsNm("파란색 줄무늬 티셔츠")
            .goodsCd("0011")
            .goodsCate("C99")
            .goodsCateNm("티셔츠")
            .goodsPrc(25000L)
            .goodsSalePrc(20000L)
            .goodsAmt(20000L)
            .goodsImg("https://shop.example.com/web/product/0011.png")
            .goodsCnt(1)
            .build(),
        Goods.builder()
            .goodsNm("흰색 줄무늬 티셔츠")
            .goodsCd("0012")
            .goodsCate("C99")
            .goodsCateNm("티셔츠")
            .goodsPrc(20000L)
            .goodsSalePrc(15000L)
            .goodsAmt(45000L)
            .goodsImg("https://shop.example.com/web/product/0012.png")
            .goodsCnt(3)
            .build()
    )
}

# iOS SDK 화면 이벤트 및 행동 이력 연동

---

## 목차

1. [검색 키워드](#search-keyword)
2. [Goods Model Builder](#goods-model-builder)
3. [상품 상세](#goods-detail)
4. [장바구니](#cart)
5. [주문하기](#order)
6. [주문 완료](#order-complete)
7. [카테고리](#category)
8. [기타 화면 정보](#etc-screen)
9. [커스텀 이벤트](#custom-event)
10. [함께 보면 좋은 문서](#related-docs)

---

<a id="search-keyword"></a>
## 검색 키워드

### `setSearchKeyword(searchKwd, screenId)`

Swift:

```swift
Groobee.getInstance().setSearchKeyword(searchKwd: SEARCH_KEYWORD, screenId: SCREEN_ID)
```

Objective-C:

```objectivec
[[Groobee getInstance] setSearchKeywordWithSearchKwd:SEARCH_KEYWORD
                                             screenId:SCREEN_ID
                                          clickButton:NULL];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `SEARCH_KEYWORD` | `String` | 검색 키워드 | `청바지` |
| `SCREEN_ID` | `String` | 화면 식별 ID | `SCREEN_PAGE_01` |

- 검색 시 `setSearchKeyword()` 메소드를 호출하면 특정 검색어를 입력한 유저에 한해 메시지 전달이 가능합니다.
- 세그먼트 변수 생성 시 방문행동 → 사이트 검색어를 이용해 특정 단어에 대한 세그먼트를 만들 수 있습니다.

<a id="goods-model-builder"></a>
## Goods Model Builder

상품 관련 메소드에는 `Goods` 모델을 사용합니다.

Swift:

```swift
let goodsItem = Goods()
    .setGoodsNm("청바지")
    .setGoodsCd("0012")
    .setGoodsCate("C99")
    .setGoodsCateNm("바지")
    .setGoodsPrc(2000)
    .setGoodsSalePrc(1900)
    .setGoodsAmt(1900)
    .setGoodsImg("http://shop.com/web/product_img.png")
    .setGoodsCnt(1)
```

Objective-C:

```objectivec
Goods *goodsItem = [[[[[[[[[[Goods alloc] init]
    setGoodsNm:@"청바지"]
    setGoodsCd:@"0012"]
    setGoodsCate:@"C99"]
    setGoodsCateNm:@"바지"]
    setGoodsPrc:2000]
    setGoodsSalePrc:1900]
    setGoodsAmt:1900]
    setGoodsImg:@"http://shop.com/web/product_img.png"]
    setGoodsCnt:1];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `goodsNm` | `String` | 상품명 | `청바지` |
| `goodsCd` | `String` | 상품코드 | `0012` |
| `goodsCate` | `String` | 상품의 카테고리 코드 | `C99` |
| `goodsCateNm` | `String` | 상품의 카테고리 이름 | `바지` |
| `goodsPrc` | `Int` | 상품가격 | `2000` |
| `goodsSalePrc` | `Int` | 상품 세일가격 | `1900` |
| `goodsAmt` | `Int` | 상품 총 가격 | `1900` |
| `goodsImg` | `String` | 상품 이미지 URL | `http://shop.com/web/product_img.png` |
| `goodsCnt` | `Int` | 상품 수량 | `1` |

<a id="goods-detail"></a>
## 상품 상세

### `setViewGoods(goods, screenId)`

Swift:

```swift
Groobee.getInstance().setViewGoods(goods: goodsItem, screenId: SCREEN_ID)
```

Objective-C:

```objectivec
[[Groobee getInstance] setViewGoodsWithGoods:goodsItem
                                    screenId:SCREEN_ID
                                 clickButton:NULL];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `GOODS_ITEM` | `Goods` | Groobee SDK에서 지원하는 Model Builder | 위 코드와 같이 상품정보를 입력 |
| `SCREEN_ID` | `String` | 화면 식별 ID | `SCREEN_PAGE_01` |

- `setViewGoods()` 메소드는 상품 상세 진입 시 호출을 권장합니다.
- 세그먼트 변수 생성, AI 분석(RFM, 구매확률), 전환 상태 측정, 트리거 옵션 기능에 활용됩니다.

<a id="cart"></a>
## 장바구니

### `setShoppingCart(goods, screenId)`

Swift:

```swift
var goodsList = [Goods]()
goodsList.append(goodsItem)

Groobee.getInstance().setShoppingCart(goods: goodsList, screenId: SCREEN_ID)
```

Objective-C:

```objectivec
NSMutableArray<Goods *> *goodsList = [NSMutableArray array];
[goodsList addObject:goodsItem];

[[Groobee getInstance] setShoppingCartWithGoods:goodsList
                                       screenId:SCREEN_ID
                                    clickButton:NULL];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `GOODS_LIST` | `Array<Goods>` | Groobee SDK에서 지원하는 Model Builder를 Array에 넣은 형태 | 위 코드와 같이 상품정보를 입력 |
| `SCREEN_ID` | `String` | 화면 식별 ID | `SCREEN_PAGE_01` |

- `setShoppingCart()` 메소드는 장바구니 진입 시 호출을 권장합니다.
- 세그먼트 변수 생성, AI 분석(RFM, 구매확률), 전환 상태 측정, 트리거 옵션 기능에 활용됩니다.

<a id="order"></a>
## 주문하기

### `setGoodsOrder(goods, screenId)`

Swift:

```swift
var goodsList = [Goods]()
goodsList.append(goodsItem)

Groobee.getInstance().setGoodsOrder(goods: goodsList, screenId: SCREEN_ID)
```

Objective-C:

```objectivec
NSMutableArray<Goods *> *goodsList = [NSMutableArray array];
[goodsList addObject:goodsItem];

[[Groobee getInstance] setGoodsOrderWithGoods:goodsList
                                     screenId:SCREEN_ID
                                  clickButton:NULL];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `GOODS_LIST` | `Array<Goods>` | Groobee SDK에서 지원하는 Model Builder를 Array에 넣은 형태 | 위 코드와 같이 상품정보를 입력 |
| `SCREEN_ID` | `String` | 화면 식별 ID | `SCREEN_PAGE_01` |

- `setGoodsOrder()` 메소드는 주문하기 진입 시 호출을 권장합니다.
- 세그먼트 변수 생성, AI 분석(RFM, 구매확률), 전환 상태 측정, 트리거 옵션 기능에 활용됩니다.

<a id="order-complete"></a>
## 주문 완료

### `setGoodsOrderComplete(orderNo, goods, screenId)`

Swift:

```swift
var goodsList = [Goods]()
goodsList.append(goodsItem)

Groobee.getInstance().setGoodsOrderComplete(
    orderNo: ORDER_NUMBER,
    goods: goodsList,
    screenId: SCREEN_ID
)
```

Objective-C:

```objectivec
NSMutableArray<Goods *> *goodsList = [NSMutableArray array];
[goodsList addObject:goodsItem];

[[Groobee getInstance] setGoodsOrderCompleteWithOrderNo:ORDER_NUMBER
                                                  goods:goodsList
                                               screenId:SCREEN_ID
                                            clickButton:NULL];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `ORDER_NUMBER` | `String` | 주문번호 | `P013A151F2037` |
| `GOODS_LIST` | `Array<Goods>` | Groobee SDK에서 지원하는 Model Builder를 Array에 넣은 형태 | 위 코드와 같이 상품정보를 입력 |
| `SCREEN_ID` | `String` | 화면 식별 ID | `SCREEN_PAGE_01` |

- `setGoodsOrderComplete()` 메소드는 주문완료 진입 시 호출을 권장합니다.
- 세그먼트 변수 생성, AI 분석(RFM, 구매확률), 전환 상태 측정, 트리거 옵션 기능에 활용됩니다.

<a id="category"></a>
## 카테고리

### `setCategory(cateCd, cateNm, screenId)`

Swift:

```swift
Groobee.getInstance().setCategory(cateCd: CATE_CODE, cateNm: CATE_NAME, screenId: SCREEN_ID)
```

Objective-C:

```objectivec
[[Groobee getInstance] setCategoryWithCateCd:CATE_CODE
                                       cateNm:CATE_NAME
                                     screenId:SCREEN_ID
                                  clickButton:NULL];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `CATE_CODE` | `String` | 카테고리 코드 | `C99` |
| `CATE_NAME` | `String` | 카테고리 이름 | `바지` |
| `SCREEN_ID` | `String` | 화면 식별 ID | `SCREEN_PAGE_01` |

- 카테고리 선택 시 `setCategory()` 메소드 호출을 권장하며, 특정 카테고리 진입 시 메시지를 전달할 수 있습니다.

<a id="etc-screen"></a>
## 기타 화면 정보

### `setScreenData(screenName, screenId)`

Swift:

```swift
Groobee.getInstance().setScreenData(screenName: SCREEN_NAME, screenId: SCREEN_ID)
```

Objective-C:

```objectivec
[[Groobee getInstance] setScreenDataWithScreenName:SCREEN_NAME
                                          screenId:SCREEN_ID
                                       clickButton:NULL];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `SCREEN_NAME` | `String` | 화면 식별 NAME | `홈` |
| `SCREEN_ID` | `String` | 화면 식별 ID | `SCREEN_PAGE_01` |

현재 그루비는 상품을 보거나 구매하는 행위에 초점이 맞추어져 있습니다.  
그 외 다른 화면에서 메시지를 전달하고 싶다면 `setScreenData()` 메소드를 호출합니다.

<a id="custom-event"></a>
## 커스텀 이벤트

### `setCustomEvent(eventKey, screenId, eventValue)`

Swift:

```swift
Groobee.getInstance().setCustomEvent(
    eventKey: EVENT_KEY,
    screenId: SCREEN_ID,
    eventValue: EVENT_VALUE
)
```

Objective-C:

```objectivec
[[Groobee getInstance] setCustomEventWithEventKey:EVENT_KEY
                                          screenId:SCREEN_ID
                                        eventValue:EVENT_VALUE];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `EVENT_KEY` | `String` | 이벤트 키 | `EV1711351248041` |
| `SCREEN_ID` | `String` | 화면 식별 ID | `SCREEN_PAGE_01` |
| `EVENT_VALUE` | `String` | 이벤트 값 | `HOME` |

그루비 어드민에서 별도의 CustomEvent 변수를 이용해 사용자에게 메시지를 전달하고 싶다면 `setCustomEvent()` 메소드를 호출합니다.

<a id="related-docs"></a>
## 함께 보면 좋은 문서

- [iOS SDK 회원 정보 및 푸시 상태 연동](./ios-sdk-member-push.md)
- [iOS SDK 하이브리드 앱 데이터 동기화](./ios-sdk-hybrid-sync.md)
- [iOS SDK 추천 상품 연동](./ios-sdk-recommend.md)

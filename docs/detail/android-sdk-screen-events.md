# Android SDK 화면 이벤트 및 행동 이력 연동

이 문서는 Android Native SDK와 Flutter Android SDK 공통 기준으로 검색, 상품 상세, 장바구니, 주문, 카테고리, 커스텀 이벤트 등 화면/행동 데이터 연동 방법을 정리한 문서입니다.

---

## 목차

1. [공통 원칙](#common-principles)
2. [`Goods` 모델](#goods-model)
3. [메소드별 정리](#methods)
4. [어떤 화면에서 어떤 메소드를 써야 하는가](#method-by-screen)
5. [Flutter 앱에서의 적용](#flutter-usage)

---

<a id="common-principles"></a>
## 공통 원칙

- 가능한 한 화면 최초 진입 시점에 한 번만 호출하세요.
- `screenId`는 고정 문자열로 일관되게 관리하세요.
- 상품 이벤트는 `Goods` 모델을 사용합니다.

예:

```text
SCREEN_HOME
SCREEN_SEARCH
SCREEN_PRODUCT_DETAIL
SCREEN_ORDER
SCREEN_ORDER_COMPLETE
```

<a id="goods-model"></a>
## `Goods` 모델

상품 관련 메소드에는 `Goods` 모델을 사용합니다.

Kotlin:

```kotlin
val goodsItem = Goods.builder()
    .goodsNm("청바지")
    .goodsCd("0012")
    .goodsCate("C99")
    .goodsCateNm("바지")
    .goodsPrc(2000L)
    .goodsSalePrc(1900L)
    .goodsAmt(1900L)
    .goodsImg("https://shop.example.com/product_img.png")
    .goodsCnt(1)
    .build()
```

Java:

```java
Goods goodsItem = Goods.builder()
        .goodsNm("청바지")
        .goodsCd("0012")
        .goodsCate("C99")
        .goodsCateNm("바지")
        .goodsPrc(2000L)
        .goodsSalePrc(1900L)
        .goodsAmt(1900L)
        .goodsImg("https://shop.example.com/product_img.png")
        .goodsCnt(1)
        .build();
```

| 필드 | 자료형 | 설명 |
| --- | --- | --- |
| `goodsNm` | `String` | 상품명 |
| `goodsCd` | `String` | 상품코드 |
| `goodsCate` | `String` | 카테고리 코드 |
| `goodsCateNm` | `String` | 카테고리 이름 |
| `goodsPrc` | `Long` | 정상가 |
| `goodsSalePrc` | `Long` | 판매가 |
| `goodsAmt` | `Long` | 총 금액 |
| `goodsImg` | `String` | 상품 이미지 URL |
| `goodsCnt` | `Int` | 수량 |

<a id="methods"></a>
## 메소드별 정리

### `setSearchKeyword(activity, keyword, screenId)`

- 검색 결과 화면 진입 시 호출을 권장합니다.
- 특정 검색어를 입력한 사용자 세그먼트 구성에 사용할 수 있습니다.

| 파라미터 | 설명 |
| --- | --- |
| `activity` | 호출하는 Activity |
| `keyword` | 검색 키워드 |
| `screenId` | 화면 식별 ID |

### `setViewGoods(activity, goods, screenId)`

- 상품 상세 화면 진입 시 호출을 권장합니다.
- 상품 조회 행동을 수집하며 세그먼트, 인앱메시지, AI 분석 기초 데이터에 활용됩니다.

### `setShoppingCart(activity, goodsList, screenId)`

- 장바구니 화면 진입 시 호출을 권장합니다.
- `goodsList`는 여러 상품을 담은 `List<Goods>` 형태입니다.

### `setGoodsOrder(activity, goodsList, screenId)`

- 주문하기 화면 진입 시 호출을 권장합니다.
- 구매 전환 직전 행동 데이터 수집에 사용됩니다.

### `setGoodsOrderComplete(activity, orderNumber, goodsList, screenId)`

- 주문 완료 시점에 호출을 권장합니다.
- 주문 완료 전환과 구매 상품 정보를 함께 전달합니다.

| 추가 파라미터 | 설명 |
| --- | --- |
| `orderNumber` | 주문번호 |

### `setCategory(activity, cateCode, cateName, screenId)`

- 카테고리 진입 시 호출을 권장합니다.
- 특정 카테고리 진입 사용자 세그먼트와 트리거 메시지 구성에 활용됩니다.

### `setScreenData(activity, screenId)`

- 상품 관련 메소드가 없는 일반 화면에서 사용합니다.
- 예를 들어 메인, 이벤트, 브랜드 소개 같은 화면에 적용할 수 있습니다.

### `setCustomEvent(activity, eventKey, eventValue, screenId)`

- Groobee 어드민에서 정의한 커스텀 이벤트 기준으로 메시지를 제어할 때 사용합니다.
- `screenId`가 없는 구버전 호환 메소드(`setCustomEvent(activity, eventKey, eventValue)`)도 존재하지만 **`@Deprecated`** 처리되어 있으므로, 신규 개발 시에는 반드시 `screenId`가 있는 형태를 사용하세요.

| 파라미터 | 설명 |
| --- | --- |
| `eventKey` | 이벤트 키 |
| `eventValue` | 이벤트 값 |
| `screenId` | 화면 식별 ID |

<a id="method-by-screen"></a>
## 어떤 화면에서 어떤 메소드를 써야 하는가

| 화면/행동 | 권장 메소드 |
| --- | --- |
| 검색 결과 | `setSearchKeyword()` |
| 상품 상세 | `setViewGoods()` |
| 장바구니 | `setShoppingCart()` |
| 주문서 | `setGoodsOrder()` |
| 주문 완료 | `setGoodsOrderComplete()` |
| 카테고리 | `setCategory()` |
| 일반 화면 | `setScreenData()` |
| 별도 비즈니스 이벤트 | `setCustomEvent()` |

<a id="flutter-usage"></a>
## Flutter 앱에서의 적용

Flutter에서는 화면 이벤트를 Dart에서 감지하더라도, 실제 Groobee 메소드 호출은 Android Activity 컨텍스트에서 처리해야 합니다.  
특히 아래 메소드는 `Activity` 인자가 필요하므로 `MainActivity` 등 Android 브리지 쪽에서 처리하세요.

- `setMemberJoin()`
- `setSearchKeyword()`
- `setViewGoods()`
- `setShoppingCart()`
- `setGoodsOrder()`
- `setGoodsOrderComplete()`
- `setCategory()`
- `setScreenData()`
- `setCustomEvent()`

자세한 구현은 [Flutter Android SDK MethodChannel 연동](./android-flutter-method-channel.md)을 참고하세요.

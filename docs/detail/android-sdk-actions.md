# Android SDK 행동 이력 수집

이 문서는 Android Native SDK와 Flutter Android SDK 공통 기준으로, 검색·상품 상세·장바구니·주문·카테고리·커스텀 이벤트 등 **사용자 행동 이력(Action)을 Groobee에 수집**하는 방법을 정리한 문서입니다.

---

## 목차

1. [공통 원칙](#common-principles)
2. [`Goods` 모델](#goods-model)
3. [행동 수집 메소드 목록](#action-methods)
4. [행동별 권장 메소드](#action-by-usecase)
5. [Flutter 앱에서의 적용](#flutter-usage)

---

<a id="common-principles"></a>
## 공통 원칙

- 가능한 한 행동이 발생한 화면에 최초 진입한 시점에 한 번만 호출하세요.
- `screenId`는 고정 문자열로 일관되게 관리하세요.
- 상품 관련 행동은 `Goods` 모델을 사용합니다.

`screenId` 예:

```text
SCREEN_HOME
SCREEN_SEARCH
SCREEN_PRODUCT_DETAIL
SCREEN_ORDER
SCREEN_ORDER_COMPLETE
```

---

<a id="goods-model"></a>
## `Goods` 모델

상품 관련 행동 수집 메소드에는 `Goods` 모델을 사용합니다.

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
| `goodsSalePrc` | `Long` | 판매가 (할인 적용가) |
| `goodsAmt` | `Long` | 총 금액 |
| `goodsImg` | `String` | 상품 이미지 URL |
| `goodsCnt` | `Int` | 수량 |

---

<a id="action-methods"></a>
## 행동 수집 메소드 목록

### `setSearchKeyword(activity, keyword, screenId)`

- 검색 결과 화면에서 사용자가 입력한 검색 키워드를 수집할 때 호출합니다.
- 특정 검색어를 입력한 사용자 세그먼트 구성에 사용할 수 있습니다.

| 파라미터 | 자료형 | 설명 | 예시                                     |
| --- | --- | --- |----------------------------------------|
| `activity` | `Activity` | 호출하는 Activity 컨텍스트 | `MyActivity.this` or `this@MyActivity` |
| `keyword` | `String` | 사용자가 입력한 검색어 | `"청바지"`                                |
| `screenId` | `String` | 화면 식별 ID (고정 문자열 권장) | `"SCREEN_SEARCH"`                      |

### `setViewGoods(activity, goods, screenId)`

- 상품 상세 화면에서 조회된 상품 정보를 수집할 때 호출합니다.
- 상품 조회 행동을 수집하며 세그먼트, 인앱메시지, AI 분석 기초 데이터에 활용됩니다.

| 파라미터 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `activity` | `Activity` | 호출하는 Activity 컨텍스트 | `MyActivity.this` or `this@MyActivity` |
| `goods` | `Goods` | 조회한 상품 1건 | [`Goods` 모델](#goods-model) 참고 |
| `screenId` | `String` | 화면 식별 ID | `"SCREEN_PRODUCT_DETAIL"` |

### `setShoppingCart(activity, goodsList, screenId)`

- 장바구니에 담긴 상품 목록을 수집할 때 호출합니다.

| 파라미터 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `activity` | `Activity` | 호출하는 Activity 컨텍스트 | `MyActivity.this` or `this@MyActivity` |
| `goodsList` | `List<Goods>` | 장바구니에 담긴 상품 목록 | `listOf(goodsA, goodsB)` |
| `screenId` | `String` | 화면 식별 ID | `"SCREEN_CART"` |

### `setGoodsOrder(activity, goodsList, screenId)`

- 주문하기 화면 진입 시 호출해 구매 전환 직전 행동 데이터를 수집합니다.

| 파라미터 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `activity` | `Activity` | 호출하는 Activity 컨텍스트 | `MyActivity.this` or `this@MyActivity` |
| `goodsList` | `List<Goods>` | 주문 진행 중인 상품 목록 | `listOf(goodsItem)` |
| `screenId` | `String` | 화면 식별 ID | `"SCREEN_ORDER"` |

### `setGoodsOrderComplete(activity, orderNumber, goodsList, screenId)`

- 주문 완료 시점에 호출해 주문 전환과 구매 상품 정보를 함께 수집합니다.

| 파라미터 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `activity` | `Activity` | 호출하는 Activity 컨텍스트 | `MyActivity.this` or `this@MyActivity` |
| `orderNumber` | `String` | 주문 번호 | `"ORD-20260101-0001"` |
| `goodsList` | `List<Goods>` | 주문한 상품 목록 | `listOf(goodsItem)` |
| `screenId` | `String` | 화면 식별 ID | `"SCREEN_ORDER_COMPLETE"` |

### `setCategory(activity, cateCode, cateName, screenId)`

- 카테고리 진입 시 호출해 카테고리 기반 세그먼트·트리거 메시지 구성에 활용합니다.

| 파라미터 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `activity` | `Activity` | 호출하는 Activity 컨텍스트 | `MyActivity.this` or `this@MyActivity` |
| `cateCode` | `String` | 카테고리 코드 | `"C99"` |
| `cateName` | `String` | 카테고리 이름 | `"바지"` |
| `screenId` | `String` | 화면 식별 ID | `"SCREEN_CATEGORY"` |

### `setScreenData(activity, screenId)`

- 상품 관련 행동이 없는 일반 화면에서 호출해 화면 진입 이력을 수집합니다.
- 예: 이벤트, 브랜드 소개.

| 파라미터 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `activity` | `Activity` | 호출하는 Activity 컨텍스트 | `MyActivity.this` or `this@MyActivity` |
| `screenId` | `String` | 화면 식별 ID | `"SCREEN_HOME"` |

### `setCustomEvent(activity, eventKey, eventValue, screenId)`

- Groobee 어드민에 정의한 커스텀 이벤트 기준으로 메시지를 제어할 때 사용합니다.
- `screenId`가 없는 구버전 오버로드(`setCustomEvent(activity, eventKey, eventValue)`)도 존재하지만 **`@Deprecated`** 처리되어 있으므로, 신규 개발 시에는 반드시 `screenId`가 있는 형태를 사용하세요.

| 파라미터 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `activity` | `Activity` | 호출하는 Activity 컨텍스트 | `MyActivity.this` or `this@MyActivity` |
| `eventKey` | `String` | 어드민에 정의한 이벤트 키 | `"AGREE_MARKETING"` |
| `eventValue` | `String` | 이벤트 값 | `"true"` |
| `screenId` | `String` | 화면 식별 ID | `"SCREEN_SETTINGS"` |

---

<a id="action-by-usecase"></a>
## 행동별 권장 메소드

| 행동 유형 | 권장 메소드 |
| --- | --- |
| 검색어 입력 | `setSearchKeyword()` |
| 상품 상세 조회 | `setViewGoods()` |
| 장바구니 담기 / 조회 | `setShoppingCart()` |
| 주문 진행 | `setGoodsOrder()` |
| 주문 완료 | `setGoodsOrderComplete()` |
| 카테고리 진입 | `setCategory()` |
| 일반 화면 진입 | `setScreenData()` |
| 커스텀 이벤트 | `setCustomEvent()` |

---

<a id="flutter-usage"></a>
## Flutter 앱에서의 적용

Flutter에서는 사용자 행동을 Dart에서 감지하더라도, Groobee 메소드들은 `Activity` 인자가 필요하므로 `MainActivity` 등 Android 브리지 쪽에서 처리하세요.

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

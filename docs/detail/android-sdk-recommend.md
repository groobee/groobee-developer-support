# Android SDK 추천 상품 연동

이 문서는 Android Native SDK와 Flutter Android SDK 공통 기준으로 추천 상품 캠페인과 추천 상품 API 연동 방법을 정리한 문서입니다.

---

## 목차

1. [추천 상품 연동 전 준비](#prerequisites)
2. [추천 상품 조회](#get-recommend)
3. [추천 결과에서 사용하는 값](#recommend-result)
4. [추천 상품 노출 통계 전송](#show-stats)
5. [추천 상품 클릭 통계 전송](#click-stats)
6. [추천 상품 연동 예시 흐름](#example-flow)
7. [Flutter 앱에서의 적용](#flutter-usage)

---

<a id="prerequisites"></a>
## 추천 상품 연동 전 준비

추천 상품 API를 사용하려면 먼저 Groobee 어드민에서 추천 캠페인을 생성해야 합니다.

필수 준비 항목:

- Groobee 어드민에서 `AI 상품 추천` 캠페인 생성
- 생성된 `campaignKey` 확보

추천 상품 연동은 다음 흐름으로 진행합니다.

1. `campaignKey`로 추천 상품 리스트를 조회합니다.
2. 화면에 실제로 노출한 상품 리스트를 Groobee에 전송합니다.
3. 사용자가 클릭한 상품을 Groobee에 전송합니다.
4. 어드민에서 노출/클릭 통계를 확인합니다.

<a id="get-recommend"></a>
## 추천 상품 조회

### 동기식: `getRecommendGoods(campaignKey, timeout)`

Kotlin:

```kotlin
val recommendData = Groobee.getInstance().getRecommendGoods(campaignKey, 10_000)
```

Java:

```java
RecommendData recommendData =
        Groobee.getInstance().getRecommendGoods(campaignKey, 10_000);
```

| 파라미터 | 자료형 | 설명 |
| --- | --- | --- |
| `campaignKey` | `String` | 어드민에서 생성한 추천 캠페인키 |
| `timeout` | `Int` | 응답 대기 시간(ms) |

### 비동기식: `getRecommendGoods(campaignKey, resultGoods)`

- UI 블로킹을 피하려면 비동기식을 권장합니다.
- 성공 시 `RecommendData`를 콜백으로 받습니다.

<a id="recommend-result"></a>
## 추천 결과에서 사용하는 값

추천 상품 조회 결과 `RecommendData`에서 아래 값을 사용합니다.

| 값 | 설명 |
| --- | --- |
| `requestId` | 추천 요청 식별자 |
| `campaignKey` | 조회에 사용한 캠페인키 |
| `algorithmCd` | 선택된 알고리즘 코드 |
| `goodsList` | 추천된 상품 목록 |

응답 결과가 없거나 타임아웃이 지나면 빈 리스트가 반환될 수 있습니다.

<a id="show-stats"></a>
## 추천 상품 노출 통계 전송

### `setShowRecommendGoods(requestId, campaignKey, algorithmCd, goodsList)`

실제로 화면에 노출된 추천 상품 목록을 Groobee에 전달합니다.

Kotlin:

```kotlin
Groobee.getInstance().setShowRecommendGoods(
    requestId,
    campaignKey,
    algorithmCd,
    goodsList
)
```

Java:

```java
Groobee.getInstance().setShowRecommendGoods(
        requestId,
        campaignKey,
        algorithmCd,
        goodsList
);
```

| 파라미터 | 설명 |
| --- | --- |
| `requestId` | `getRecommendGoods()` 결과의 `requestId` |
| `campaignKey` | `getRecommendGoods()` 결과의 `campaignKey` |
| `algorithmCd` | `getRecommendGoods()` 결과의 `algorithmCd` |
| `goodsList` | 실제로 노출된 추천 상품 목록 |

- 이 호출이 있어야 어드민에서 노출 통계를 확인할 수 있습니다.

<a id="click-stats"></a>
## 추천 상품 클릭 통계 전송

### `setClickRecommendGoods(requestId, campaignKey, algorithmCd, goods)`

사용자가 클릭한 추천 상품 한 건을 Groobee에 전달합니다.

Kotlin:

```kotlin
Groobee.getInstance().setClickRecommendGoods(
    requestId,
    campaignKey,
    algorithmCd,
    clickedGoodsItem
)
```

Java:

```java
Groobee.getInstance().setClickRecommendGoods(
        requestId,
        campaignKey,
        algorithmCd,
        clickedGoodsItem
);
```

| 파라미터 | 설명 |
| --- | --- |
| `requestId` | `getRecommendGoods()` 결과의 `requestId` |
| `campaignKey` | `getRecommendGoods()` 결과의 `campaignKey` |
| `algorithmCd` | `getRecommendGoods()` 결과의 `algorithmCd` |
| `goods` | 클릭된 추천 상품 1건 |

- 이 호출이 있어야 어드민에서 클릭 통계를 확인할 수 있습니다.

<a id="example-flow"></a>
## 추천 상품 연동 예시 흐름

Kotlin:

```kotlin
val recommendData = Groobee.getInstance().getRecommendGoods(campaignKey, 10_000)

recommendData?.let { data ->
    val goodsList = data.goodsList

    if (goodsList.isNotEmpty()) {
        Groobee.getInstance().setShowRecommendGoods(
            data.requestId,
            data.campaignKey,
            data.algorithmCd,
            goodsList
        )
    }
}
```

클릭 시:

```kotlin
Groobee.getInstance().setClickRecommendGoods(
    recommendData.requestId,
    recommendData.campaignKey,
    recommendData.algorithmCd,
    clickedGoodsItem
)
```

Java:

```java
RecommendData recommendData =
        Groobee.getInstance().getRecommendGoods(campaignKey, 10_000);

if (recommendData != null) {
    List<Goods> goodsList = recommendData.getGoodsList();

    if (goodsList != null && !goodsList.isEmpty()) {
        Groobee.getInstance().setShowRecommendGoods(
                recommendData.getRequestId(),
                recommendData.getCampaignKey(),
                recommendData.getAlgorithmCd(),
                goodsList
        );
    }
}
```

클릭 시:

```java
Groobee.getInstance().setClickRecommendGoods(
        recommendData.getRequestId(),
        recommendData.getCampaignKey(),
        recommendData.getAlgorithmCd(),
        clickedGoodsItem
);
```

<a id="flutter-usage"></a>
## Flutter 앱에서의 적용

Flutter 앱에서는 Android 모듈에서 추천 API를 호출하고 결과를 JSON 형태로 Dart에 전달하는 구성이 일반적입니다.

추천 연동 시 권장 순서:

1. Android 브리지에 `getRecommendGoods` 메소드를 추가합니다.
2. `RecommendData`를 JSON으로 직렬화해 Dart에 전달합니다.
3. Dart에서 렌더링한 실제 노출 리스트를 다시 Android로 보내 `setShowRecommendGoods()`를 호출합니다.
4. 클릭 이벤트 시 클릭된 상품 한 건을 Android로 보내 `setClickRecommendGoods()`를 호출합니다.

Flutter 브리지 패턴은 [Flutter Android SDK MethodChannel 연동](./android-flutter-method-channel.md)을 참고하세요.

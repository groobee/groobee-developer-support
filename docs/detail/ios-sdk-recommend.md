# iOS SDK 추천 상품 연동

이 문서는 iOS Native SDK와 Flutter iOS SDK 공통 기준으로, Groobee AI 추천 상품 리스트를 조회하고 노출·클릭 통계를 전송하는 방법을 정리한 문서입니다.

---

## 목차

1. [추천 상품 리스트 조회 (비동기식 · 권장)](#recommend-list)
2. [추천 상품 노출](#recommend-impression)
3. [추천 상품 클릭](#recommend-click)
4. [Goods Model Builder Parameter](#goods-model-builder-parameter)
5. [부록: 동기식 호출 (비권장)](#legacy-sync)
6. [함께 보면 좋은 문서](#related-docs)

---

<a id="recommend-list"></a>
## 추천 상품 리스트 조회 (비동기식 · 권장)

### `getRecommendGoods(campaignKey, responseGoods)`

추천 상품 조회는 네트워크 요청이 포함되므로 **비동기식 콜백 방식을 권장**합니다. 결과는 `ResponseGoods` 프로토콜을 통해 전달됩니다.

Swift:

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    Groobee.getInstance().getRecommendGoods(campaignKey: CAMPAIGN_KEY, responseGoods: self)
}

extension ViewController: ResponseGoods {
    func onSuccess(aiRecommend: GroobeeKit.ArtificialRecommend) {
        let goods = aiRecommend.getRecommendList()
        let campaignKey = aiRecommend.getCampaignKey()
        let algorithmCd = aiRecommend.getAlgorithmCd()
        let requestId = aiRecommend.getRequestId() ?? ""

        if goods != nil && campaignKey != nil && algorithmCd != nil && goods!.count > 0 {
            // 화면에 추천 상품 렌더링
        }
    }

    func onFailed(exceptionMsg: String, campaignKey: String) { }
}
```

Objective-C:

```objectivec
@interface ViewController () <ResponseGoods>

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Groobee getInstance] getRecommendGoodsWithCampaignKey:CAMPAIGN_KEY responseGoods:self];
}

- (void)onSuccessWithGoods:(NSObject<ArtificialRecommend *> * _Nonnull)aiRecommend {
    goods = [aiRecommend getRecommendList];
    campaignKey = [aiRecommend getCampaignKey];
    algorithmCd = [aiRecommend getAlgorithmCd];
    requestId = [aiRecommend getRequestId];

    if (goods != nil && campaignKey != nil && algorithmCd != nil && ([goods count] > 0)) {
        // 화면에 추천 상품 렌더링
    }
}

- (void)onFailedWithExceptionMsg:(NSString * _Nonnull)exceptionMsg
                    campaignKeyn:(NSString * _Nonnull)campaignKey { }
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `CAMPAIGN_KEY` | `String` | 그루비 어드민에서 생성한 추천 캠페인키 | `RE10b977c6fd…` |
| `responseGoods` | `ResponseGoods` | 성공(`onSuccess`) / 실패(`onFailed`) 결과를 받을 콜백 | 콜백 객체 |

- UI 스레드를 블로킹하지 않아 어떤 화면에서도 안전하게 호출할 수 있습니다.
- 추천할 상품 리스트가 없거나 응답시간이 지난 경우 빈 `Array`가 포함된 상태로 `onSuccess`가 호출될 수 있습니다.

<a id="recommend-impression"></a>
## 추천 상품 노출

### `setShowRecommendGoods(goods, campaignKey, algorithmCd, requestId)`

Swift:

```swift
Groobee.getInstance().setShowRecommendGoods(
    goods: RECOMMEND_GOODS_LIST,
    campaignKey: campaignKey,
    algorithmCd: algorithmCd,
    requestId: requestId
)
```

Objective-C:

```objectivec
[[Groobee getInstance] setShowRecommendGoodsWithGoods:RECOMMEND_GOODS_LIST
                                          campaignKey:campaignKey
                                          algorithmCd:algorithmCd
                                            requestId:requestId];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `RECOMMEND_GOODS_LIST` | `Array<Goods>` | 화면에 노출되고 있는 추천 상품 리스트 | 위 코드와 같이 상품정보를 입력 |
| `campaignKey` | `String` | 캠페인 키 | 상품 추천 리스트 리턴 값 활용 |
| `algorithmCd` | `String` | 알고리즘 코드 | 상품 추천 리스트 리턴 값 활용 |
| `requestId` | `String` | 요청 ID | 리턴 데이터가 없는 경우 `null` |

`getRecommendGoods()` 메소드로 만들어진 View에서 현재 화면에 load된 추천상품들을 `List`에 담아 `setShowRecommendGoods()`를 호출합니다.  
이 함수를 호출하면 그루비 어드민에서 추천상품의 노출상태에 따른 통계 데이터를 확인할 수 있습니다.

<a id="recommend-click"></a>
## 추천 상품 클릭

### `setClickRecommendGoods(goods, campaignKey, algorithmCd, requestId)`

Swift:

```swift
Groobee.getInstance().setClickRecommendGoods(
    goods: RECOMMEND_GOODS_ITEM,
    campaignKey: campaignKey,
    algorithmCd: algorithmCd,
    requestId: requestId
)
```

Objective-C:

```objectivec
[[Groobee getInstance] setClickRecommendGoodsWithGoods:RECOMMEND_GOODS_ITEM
                                           campaignKey:campaignKey
                                           algorithmCd:algorithmCd
                                             requestId:requestId];
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `RECOMMEND_GOODS_ITEM` | `Goods` | 클릭한 추천 상품 정보 | 클릭한 Goods Item |
| `campaignKey` | `String` | 캠페인 키 | 상품 추천 리스트 리턴 값 활용 |
| `algorithmCd` | `String` | 알고리즘 코드 | 상품 추천 리스트 리턴 값 활용 |
| `requestId` | `String` | 요청 ID | 리턴 데이터가 없는 경우 `null` |

`getRecommendGoods()` 메소드로 만들어진 View에서 현재 화면에 load된 추천상품들 중 클릭된 추천상품을 `setClickRecommendGoods()`로 전달합니다.  
이 함수를 호출하면 그루비 어드민에서 추천상품의 클릭에 따른 통계 데이터를 확인할 수 있습니다.

<a id="goods-model-builder-parameter"></a>
## Goods Model Builder Parameter

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `goodsNm` | `String` | 상품명 | `청바지` |
| `goodsCd` | `String` | 상품코드 | `0012` |
| `goodsCate` | `String` | 상품의 카테고리 코드 | `C99` |
| `goodsCateNm` | `String` | 상품의 카테고리 이름 | `바지` |
| `goodsPrc` | `Int` | 상품가격 | `2000` |
| `goodsSalePrc` | `Int` | 상품 세일가격 | `1900` |
| `goodsAmt` | `Int` | 상품 총 가격 | `3800` |
| `goodsImg` | `String` | 상품 이미지 URL | `https://shop.example.com/product_img.png` |
| `goodsCnt` | `Int` | 상품 수량 | `2` |

---

<a id="legacy-sync"></a>
## 부록: 동기식 호출 (비권장)

> ⚠️ **비권장**: 아래 동기식 호출은 네트워크 응답을 기다리는 동안 호출 스레드를 블로킹합니다. 메인 스레드에서 호출하면 UI 프리즈(Freeze)로 이어질 수 있고, 별도 큐에서 호출하더라도 응답 지연 시 후속 로직 실행이 늦어집니다. **신규 개발에서는 위의 [비동기식 호출](#recommend-list)을 사용하세요.**

### `getRecommendGoods(campaignKey, timeout)`

Swift:

```swift
let aiRecommend: ArtificialRecommend = Groobee.getInstance().getRecommendGoods(
    campaignKey: CAMPAIGN_KEY,
    timeout: 10000
)

if let goodsList = aiRecommend.getRecommendList(),
   let campaignKey = aiRecommend.getCampaignKey(),
   let algorithmCd = aiRecommend.getAlgorithmCd() {
    let requestId = aiRecommend.getRequestId() ?? ""
    // ...
}
```

Objective-C:

```objectivec
NSObject<ArtificialRecommend *> *aiRecommend =
    [[Groobee getInstance] getRecommendGoodsWithCampaignKey:CAMPAIGN_KEY timeout:TIME_OUT];

NSArray *goodsList = [aiRecommend getRecommendList];
NSString *campaignKey = [aiRecommend getCampaignKey];
NSString *algorithmCd = [aiRecommend getAlgorithmCd];
NSString *requestId = [aiRecommend getRequestId];

if (goodsList != nil && [goodsList count] > 0) {
    // ...
}
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `CAMPAIGN_KEY` | `String` | 그루비 어드민에서 생성한 추천 캠페인키 | `RE10b977c6fd…` |
| `TIME_OUT` | `Double` | 추천 상품 리스트 응답 대기 시간(ms) | `10000 => 10초` |

- 추천할 상품 리스트가 없거나 응답시간이 지난 경우 빈 `Array`로 반환됩니다.
- 이미 이 방식으로 운영 중인 코드를 유지해야 하는 경우에만 사용하세요.

---

<a id="related-docs"></a>
## 함께 보면 좋은 문서

- [iOS SDK 행동 이력 수집](./ios-sdk-actions.md)
- [iOS SDK 하이브리드 앱 데이터 동기화](./ios-sdk-hybrid-sync.md)
- [iOS SDK 주의사항 및 로그 유틸리티](./ios-sdk-cautions-log.md)

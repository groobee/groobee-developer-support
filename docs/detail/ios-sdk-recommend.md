# iOS SDK 추천 상품 연동

---

## 목차

1. [추천 상품 리스트 조회](#recommend-list)
2. [추천 상품 노출](#recommend-impression)
3. [추천 상품 클릭](#recommend-click)
4. [Goods Model Builder Parameter](#goods-model-builder-parameter)
5. [함께 보면 좋은 문서](#related-docs)

---

<a id="recommend-list"></a>
## 추천 상품 리스트 조회

### 동기식: `getRecommendGoods(campaignKey, timeout)`

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
    ...
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
    ...
}
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `CAMPAIGN_KEY` | `String` | 그루비 어드민에서 생성한 추천 캠페인키 | `RE10b977c6fd…` |
| `TIME_OUT` | `Double` | 추천 상품 리스트 응답 대기 시간(ms) | `10000 => 10초` |

그루비 어드민에서 AI 상품 추천 캠페인을 생성한 뒤 생성된 `CampaignKey`를 가지고 `getRecommendGoods()` 메소드를 호출하면 추천 상품 리스트를 받을 수 있습니다.

- 추천할 상품 리스트가 없거나 응답시간이 지난 경우 빈 `Array`로 반환됩니다.

### 비동기식(콜백): `getRecommendGoods(campaignKey, responseGoods)`

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
            ...
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
        ...
    }
}

- (void)onFailedWithExceptionMsg:(NSString * _Nonnull)exceptionMsg
                    campaignKeyn:(NSString * _Nonnull)campaignKey { }
```

| 변수명 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `CAMPAIGN_KEY` | `String` | 그루비 어드민에서 생성한 추천 캠페인키 | `RE10b977c6fd…` |
| `responseGoods` | `ResponseGoods` | 비동기식 응답 결과 호출 | 콜백 객체 |

그루비 어드민에서 AI 상품 추천 캠페인을 생성한 뒤 생성된 `CampaignKey`를 가지고 `getRecommendGoods()` 메소드를 호출하면 추천 상품 리스트를 받을 수 있습니다.

- 추천할 상품 리스트가 없거나 응답시간이 지난 경우 빈 `Array`로 반환됩니다.

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
| `goodsImg` | `String` | 상품 이미지 URL | `http://shop.com/web/product_img.png` |
| `goodsCnt` | `Int` | 상품 수량 | `2` |

<a id="related-docs"></a>
## 함께 보면 좋은 문서

- [iOS SDK 행동 이력 수집](./ios-sdk-actions.md)
- [iOS SDK 하이브리드 앱 데이터 동기화](./ios-sdk-hybrid-sync.md)
- [iOS SDK 주의사항 및 로그 유틸리티](./ios-sdk-cautions-log.md)

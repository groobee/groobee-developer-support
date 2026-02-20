# AI 상품 추천: 데이터 호출형 - 모든 페이지

## 개요
스크립트 LOAD 완료 후 원하는 시점에 추천 상품 목록을 가져와서 사용할 수 있습니다.
DIV형과 달리 디자인을 자유롭게 구성할 수 있습니다.

> **비동기식 방식**으로 구현되어 있기 때문에 타임아웃 값을 적절하게 설정해주세요.

## 연동 방식
고객사가 그루비에서 추천 상품을 요청하면 데이터를 바로 전달합니다.
비동기식이라 요청이 느려지면 HTML에 추천 리스트를 표현하지 못하는 경우가 발생할 수 있습니다.

```javascript
groobee.getGroobeeKeyBaseRecommendAsync("캠페인키", "추천타입", "타입에따른 기준값", 타임아웃)
  .then(data => {
    console.log(data);
  });
```

## 추천 상품 조회 (getGroobeeKeyBaseRecommendAsync)
고객사가 키(Key) 기반 추천 상품을 요청할 때 사용하는 함수입니다.

- **역할**: 키 기반 추천 상품 조회
- **함수명**: `groobee.getGroobeeKeyBaseRecommendAsync`

### 파라미터
- `campaignKey` (string): 캠페인키
- `recommendBaseType` (string): 추천 종류(대문자)
- `recommendValue` (string): 추천 검색 값
- `timeSet` (int): 타임아웃 시간 (기본 3000ms)

#### recommendBaseType 종류
- `CATEGORY`
- `GOODS`
- `KEYWORD`

#### recommendBaseType에 따른 recommendValue
- `CATEGORY`: 카테고리 코드
- `GOODS`: 상품코드
- `KEYWORD`: 검색어

### 호출 예시
```javascript
groobee.getGroobeeKeyBaseRecommendAsync("RE6b33946d7add471dbd33f35347b5c06f", "CATEGORY", "카테고리코드", 3000)
  .then(data => {
    console.log(data);
  });

groobee.getGroobeeKeyBaseRecommendAsync("RE6b33946d7add471dbd33f35347b5c06f", "GOODS", "상품코드", 3000)
  .then(data => {
    console.log(data);
  });

groobee.getGroobeeKeyBaseRecommendAsync("RE6b33946d7add471dbd33f35347b5c06f", "KEYWORD", "검색어", 3000)
  .then(data => {
    console.log(data);
  });
```

### 결과 예시
```json
{
  "campaignKey": "RE0878d834239d4160b8d9fbac6e69617c",
  "algorithmCd": "ST09",
  "goodsList": [
    {
      "serviceKey": "21af7eb7cd8643a0ac599fd2ea1c9611",
      "goodsNm": "자갸드 원피스",
      "goodsCd": "49",
      "goodsImg": "//shop3.grooshop.com/web/product/medium/202008/179f46dfad80fd80432fc283f8735e91.jpg",
      "goodsCateNm": "",
      "goodsCate": "",
      "goodsPrc": 52800,
      "goodsSalePrc": 47520,
      "regDtm": [2020, 5, 21, 22, 16, 13, 232000000],
      "moddDtm": [2020, 5, 21, 22, 16, 13, 232000000]
    }
  ]
}
```

## DI (노출)
실제 고객사에서 노출된 상품 정보를 그루비로 보내 통계에 집계합니다.

- **함수명**: `groobee.send`
- **type**: `"DI"` (고정 값)

### 상품 노출
```javascript
groobeeObj = {
  algorithmCd: "알고리즘코드",
  campaignKey: "추천캠페인키",
  campaignTypeCd: "RE", // 고정
  goods: [
    { goodsCd: "노출된 상품코드1" },
    { goodsCd: "노출된 상품코드2" }
  ]
};

groobee.send("DI", groobeeObj);
```

### 기획전 노출
```javascript
groobeeObj = {
  algorithmCd: "알고리즘코드",
  campaignKey: "추천캠페인키",
  campaignTypeCd: "RE", // 고정
  goods: [
    { plan: ["노출된 기획전코드1", "노출된 기획전코드2"] }
  ]
};

groobee.send("DI", groobeeObj);
```

## CL (클릭)
고객이 클릭한 상품 정보를 그루비로 보내 통계에 집계합니다.

- **함수명**: `groobee.send`
- **type**: `"CL"` (고정 값)

### 상품 클릭
```javascript
groobeeObj = {
  algorithmCd: "알고리즘코드",
  campaignKey: "추천캠페인키",
  campaignTypeCd: "RE", // 고정
  goods: [
    { goodsCd: "고객이 클릭한 상품코드1" }
  ]
};

groobee.send("CL", groobeeObj);
```

### 기획전 클릭
```javascript
groobeeObj = {
  algorithmCd: "알고리즘코드",
  campaignKey: "추천캠페인키",
  campaignTypeCd: "RE",
  goods: [
    { plan: ["고객이 클릭한 기획전 코드1"] }
  ]
};

groobee.send("CL", groobeeObj);
```

## 사용 가능 알고리즘 정의
사용 가능한 알고리즘은 `recommendBaseType`에 따라 아래와 같습니다.

### CATEGORY (카테고리 기반)
1. 카테고리 TOP N
2. 실시간 카테고리 TOP N
3. 연관 카테고리 상품

### GOODS (상품 기반)
1. 함께 본 상품
2. 함께 구매한 상품
3. 함께 담은 상품
4. 구매 패턴 유사 상품
5. 상품명 기반 유사 상품
6. 딥러닝 기반 유사 상품
7. 연관 카테고리 상품
8. 이미지 기반 유사 상품
9. 딥러닝 기반 다음에 볼 상품

### KEYWORD (검색어 기반)
1. 검색어 추천

## 작성 예시
> 아래는 작성 예시일 뿐 고객사 코드에 맞게 수정해 주세요. 그루비 스크립트가 정상적으로 로드되지 않으면 동작하지 않기 때문에 예시와 같이 setInterval 함수 사용을 권장드립니다.
```javascript
function groobeeRecommendCall() {
  // 함수 존재 여부 체크
  if (groobee && groobee.getGroobeeKeyBaseRecommendAsync) {
    groobee.getGroobeeKeyBaseRecommendAsync("RE6b33946d7add471dbd33f35347b5c06f", "CATEGORY", "카테고리코드", 500)
      .then(data => {
        고객사처리함수(data);
      });
  } else {
    // 함수가 아직 준비되지 않은 경우 재시도
    let tryCnt = 0;
    let _timer = setInterval(() => {
      if (tryCnt === 3) {
        clearInterval(_timer);
        $("#지정된ID").hide();
        return;
      }
      tryCnt++;

      if (groobee.getGroobeeKeyBaseRecommendAsync && typeof groobee.getGroobeeKeyBaseRecommendAsync === "function") {
        groobee.getGroobeeKeyBaseRecommendAsync("RE6b33946d7add471dbd33f35347b5c06f", "CATEGORY", "카테고리코드", 500)
          .then(data => {
            고객사처리함수(data);
          });
        clearInterval(_timer);
      }
    }, 500);
  }
}

function 고객사처리함수(data) {
  console.log("recommendData :::", data);

  if (data && data.goodsList) {
    // 고객사 추천상품 노출 및 데이터 처리
    var html = "<ul>";
    for (let i = 0; i < data.goodsList.length; i++) {
      html += `<li onClick=\"clickGroobeeProduct('${data.algorithmCd}', '${data.campaignKey}', '${data.goodsList[i].goodsCd}')\">${data.goodsList[i].goodsNm}</li>`;
    }
    html += "</ul>";

    $("#지정된ID").append(html);
    $("#지정된ID").show();

    // --------------groobee 노출(DI) 처리 START----------------
    groobeeDisplayInsert(data.campaignKey, data.algorithmCd, data.goodsList);
    // --------------groobee 노출(DI) 처리 END------------------
  } else {
    $("#지정된ID").hide();
  }
}

function groobeeDisplayInsert(campaignKey, algorithmCd, goodsList) {
  if (!goodsList || goodsList.length === 0) return;

  // 기존 goodsList를 사용하거나, goodsCd만 가공해서 전달할 수 있습니다.
  // 1) var goods = goodsList;
  // 2) var goods = goodsList.map(item => ({ goodsCd: item.goodsCd }));
  var goods = goodsList;

  var groobeeObj = {
    algorithmCd: algorithmCd,
    campaignKey: campaignKey,
    campaignTypeCd: "RE",
    goods: goods
  };

  groobee.send("DI", groobeeObj);
}

function clickGroobeeProduct(campaignKey, algorithmCd, goodsCd) {
  var groobeeObj = {
    algorithmCd: algorithmCd,
    campaignKey: campaignKey,
    campaignTypeCd: "RE",
    goods: [{ goodsCd: goodsCd }]
  };

  groobee.send("CL", groobeeObj);

  // 고객사 페이지 이동 처리
  // ...
}
```

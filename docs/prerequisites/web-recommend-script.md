# AI 상품 추천: 스크립트형

## 개요
고객사에서 추천 상품을 제어하거나 전시 영역의 디자인을 수정해야 하는 경우 **스크립트형**을 사용합니다.
DIV형과 달리 디자인을 자유롭게 구성할 수 있습니다.

## 연동 방식
그루비는 추천 상품 전달 시 HTML/CSS가 아니라 아래 정보를 고객사 사이트의 특정 자바스크립트 함수로 전달합니다.
- **추천 캠페인키**
- **선택된 알고리즘 코드**
- **추천 상품 목록**

```javascript
function setGroobeeRecommend(algorithmCd, campaignKey, goodsArray) {
  // ...
}
```

고객사는 전달된 `algorithmCd`, `campaignKey`, `goodsArray`를 활용해
상품을 선별하고 원하는 위치에 노출하도록 구현해야 합니다.

## setGroobeeRecommend
그루비에서 정보 수집 후 필요한 정보를 전달하는 함수입니다.

- **역할**: 그루비에서 정보 수집 후 필요한 정보 전달
- **함수명**: `setGroobeeRecommend` (고정 값, 변경 불가)

### 파라미터
- `algorithmCd` (string): 알고리즘 코드
- `campaignKey` (string): 추천 캠페인키
- `goodsArray` (Object[]): 상품 목록

> `goodsArray`에는 상품코드 정보만 내려옵니다.

```javascript
goodsArray = [
  { goodsCd: "추천상품코드1" },
  { goodsCd: "추천상품코드2" }
];
```

## DI (노출)
실제 고객사에서 노출된 상품/기획전 정보를 그루비로 보내 통계에 집계합니다.

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
고객이 클릭한 상품/기획전 정보를 그루비로 보내 통계에 집계합니다.

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
  campaignTypeCd: "RE", // 고정
  goods: [
    { plan: ["고객이 클릭한 기획전코드1"] }
  ]
};

groobee.send("CL", groobeeObj);
```

## 작성 예시
```javascript
function setGroobeeRecommend(algorithmCd, campaignKey, goodsArray) {
  console.log(algorithmCd, ":::", campaignKey, ":::", goodsArray);

  if (goodsArray && goodsArray.length > 0) {
    // 예시를 위한 범용 AJAX. 고객사 환경에 맞게 수정 필요
    $.ajax({
      type: "고객사 상품코드로 정보 가져올 통신 타입",
      url: "고객사 상품코드로 정보 가져올 통신 URL",
      data: JSON.stringify({ goods: goodsArray }),
      success: function (result) {
        // 추천 상품 선별 및 노출 작업
        // 각 상품 클릭 시 이벤트 연결 처리 필요
        var html = "<ul>";
        for (let i = 0; i < result.length; i++) {
          html += `<li onClick=\"clickGroobeeProduct('${algorithmCd}', '${campaignKey}', '${result[i].goodsCd}')\">${result[i].goodsNm}</li>`;
        }
        html += "</ul>";

        $("#지정된ID").append(html);
        $("#지정된ID").show();

        // ----------------그루비 노출 START------------------
        var goods = result;
        var groobeeObj = {
          algorithmCd: algorithmCd,
          campaignKey: campaignKey,
          campaignTypeCd: "RE",
          goods: goods
        };
        // 마지막에 노출 처리
        groobee.send("DI", groobeeObj);
        // ----------------그루비 노출 END------------------
      },
      error: function (result, status, error) {
        console.log(error);
      }
    });
  } else {
    // 상품정보가 없을 때 노출 영역 숨김 처리
    $("#지정된ID").hide();
  }
}

// 추천 상품 클릭 시 호출해야 하는 함수 (함수명은 자유)
function clickGroobeeProduct(algorithmCd, campaignKey, goodsCd) {
  var groobeeObj = {
    algorithmCd: algorithmCd,
    campaignKey: campaignKey,
    campaignTypeCd: "RE", // 고정
    goods: [{ goodsCd: goodsCd }]
  };

  groobee.send("CL", groobeeObj);

  // 고객사 페이지 이동 처리
  // ...
}
```

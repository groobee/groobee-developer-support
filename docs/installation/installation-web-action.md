# Groobee 스크립트 설치 가이드 - 행동 이력 수집

이 문서는 웹 환경에서 Groobee 스크립트를 **실제 서비스에 맞게 설치**하기 위한 가이드 중 행동 이력 수집 방법을 기술한 문서입니다.

---

## 행동 이력 수집
- Groobee로 회원 정보에 맞춰 맞춤형 서비스를 제공하기 위해서는 행동 이력 수집이 필요합니다.
- Groobee에서 기본적으로 제공하는 행동이력 유형은 메인화면, 카테고리, 상품상세정보, 검색, 장바구니, 주문서 작성, 주문완료 페이지 방문 등이 있으며  
  만약, 추가로 수집하고자 하는 행동이력이 있는 경우에는 커스텀 이벤트 기능을 활용하시면 됩니다.  
  👉 현재 문서 내 [행동 유형 목록](#행동-유형-목록)에 각 행동유형에 대한 간단한 설명이 나와있습니다.

---

## 사전 요구 사항

- **(필수)** 공통 스크립트가 설치 되어있어야 합니다.  
👉 [공통 스크립트 설치 가이드](../installation/installation-web-common-script.md)
- **(권장)** 웹 페이지 URL이 등록 되어있어야 합니다.  
👉 [웹 페이지 경로 등록 가이드](../prerequisites/web-page-url-registration.md)

---

## 행동 유형 목록

| 구분 | 행동 이름 | 행동 코드 | 설명 |
|---|---|---|---|
| 기본 | 메인 페이지 | MA | 메인 페이지 방문 시 수집 |
| 기본 | 상품 상세 페이지 | VG | 상품 상세 페이지 방문 시 수집 |
| 기본 | 장바구니 페이지 | VC | 장바구니 페이지 방문 시 수집 |
| 기본 | 검색 결과 페이지 | SE | 검색 결과 페이지 방문 시 수집 |
| 기본 | 주문서 페이지 | OR | 주문서 페이지 방문 시 수집 |
| 기본 | 주문 완료 페이지 | PU | 주문 완료 시 수집 |
| 기본 | 카테고리 페이지 | CA | 카테고리 페이지 방문 시 수집 |
| 기본 | 회원가입 완료 페이지 | MJ | 회원가입 완료 시 수집 |
| 기본 | 기타 페이지 | LO | 이벤트 등 기타 페이지 방문 시 수집 |
| 추가 | 커스텀 이벤트 | CE | 개발자가 정의한 특정 행동 |
| 추가 | 장바구니 담기 이벤트 | AC | 상품을 장바구니에 담았을 때 수집 |
| 추가 | 장바구니 제거 이벤트 | DC | 장바구니에서 상품을 제거했을 때 수집 |

---

## 목차
- [커스텀 웹 사이트 (Custom)](#커스텀-웹-사이트-custom)
- [SPA 환경 (React, Vue 등)](#spa-환경-react-vue-등)
- [Cafe24](#cafe24)
- [고도몰](#고도몰)
- [고도몰 (옛날버전)](#고도몰-옛날버전)
- [메이크샵](#메이크샵)
- [위사 (스마트윙)](#위사-스마트윙)

---

## 커스텀 웹 사이트 (Custom)
페이지 내에 [공통 스크립트](../installation/installation-web-common-script.md)가 정상적으로 설치되어 있다면,  
아래와 같은 자바스크립트 함수를 사용 할 수 있습니다.  
아래 함수를 타입에 맞는 데이터를 넣어 호출하면 해당 행동 이력이 Groobee로 전송되어 수집됩니다.

```javascript
groobee("행동코드", 값);
```

### 메인 페이지 (MA)
- 메인 페이지 방문 이력은 [웹 페이지 URL 등록](../prerequisites/web-page-url-registration.md)이 되어 있다면 자동으로 수집됩니다.  
별도의 코드 삽입이 필요하지 않습니다.

### 검색 결과 페이지 (SE)
- 검색 결과 페이지 방문 이력은 검색어(keyword)와 함께 호출해주어야 됩니다.
```javascript
groobee( "SE", { keyword : "겨울옷" } );
```

### 상품 상세 페이지 (VG)
- 상품 상세 페이지 방문 이력은 상품 정보 목록과 함께 호출해주어야 됩니다.
- 상품 정보 목록(goods)의 타입은 Goods[] 이며, 상세한 필드별 설명은 [Goods 스키마 문서](../specs/action/schema.md#goods)를 참고해주세요.
```javascript
groobee( "VG", {
  goods : [
    {
      name: "파란색 줄무늬 티셔츠",
      code: "0011",
      amt: 20000,
      prc: 25000,
      salePrc: 20000,
      status : "", // 품절이거나 상품이 판매상태가 아닐 경우 "SS"
      img: "상품 이미지 전체 URL",
      cat: "1234",
      cateNm: "티셔츠",
      catL: "1",
      cateLNm: "의류",
      catM: "12",
      cateMNm: "남성",
      catS: "123",
      cateSNm: "남성상의",
      catD: "1234",
      cateDNm: "티셔츠",
      brand: "P1",
      brandNm: "플래티",
      plan: ['A1', 'A2', 'B1']
    }
  ]
});
```

### 장바구니 페이지 (VC)
- 장바구니 페이지 방문 이력은 장바구니 상품 정보 목록과 함께 호출해주어야 됩니다.
- 상품 정보 목록(goods)의 타입은 Goods[] 이며, 상세한 필드별 설명은 [Goods 스키마 문서](../specs/action/schema.md#goods)를 참고해주세요.
```javascript
groobee( "VC", {
  goods : [
    {
      name: "파란색 줄무늬 티셔츠",
      code: "0001",
      amt: 10000,
      prc: 15000,
      salePrc: 10000,
      cnt: 1,
      cat: "1234", 
      cateNm: "티셔츠", 
      catL: "1", 
      cateLNm: "의류", 
      catM: "12", 
      cateMNm: "남성", 
      catS: "123", 
      cateSNm: "남성상의", 
      catD: "1234", 
      cateDNm: "티셔츠", 
      brand: "P1", 
      brandNm: "플래티" 
    },
    {
      name: "흰 줄무늬 티셔츠",
      code: "0001",
      amt: 45000,
      prc: 20000,
      salePrc: 15000,
      cnt: 3,
      cat: "1235",
      cateNm: "티셔츠",
      catL: "1",
      cateLNm: "의류",
      catM: "12",
      cateMNm: "남성",
      catS: "123",
      cateSNm: "남성상의",
      catD: "1235",
      cateDNm: "티셔츠",
      brand: "P1",
      brandNm: "플래티"
    }
  ]
});
```

### 주문서 작성 페이지 (OR)
- 주문서 작성 페이지 방문 이력은 장바구니 상품 정보 목록과 함께 호출해주어야 됩니다.
- 상품 정보 목록(goods)의 타입은 Goods[] 이며, 상세한 필드별 설명은 [Goods 스키마 문서](../specs/action/schema.md#goods)를 참고해주세요.
```javascript
groobee( "OR", {
  goods : [
    {
      name: "파란색 줄무늬 티셔츠",
      code: "0001",
      amt: 10000,
      prc: 15000,
      salePrc: 10000,
      cnt: 1,
      cat: "1234", 
      cateNm: "티셔츠", 
      catL: "1", 
      cateLNm: "의류", 
      catM: "12", 
      cateMNm: "남성", 
      catS: "123", 
      cateSNm: "남성상의", 
      catD: "1234", 
      cateDNm: "티셔츠", 
      brand: "P1", 
      brandNm: "플래티" 
    },
    {
      name: "흰 줄무늬 티셔츠",
      code: "0001",
      amt: 45000,
      prc: 20000,
      salePrc: 15000,
      cnt: 3,
      cat: "1235",
      cateNm: "티셔츠",
      catL: "1",
      cateLNm: "의류",
      catM: "12",
      cateMNm: "남성",
      catS: "123",
      cateSNm: "남성상의",
      catD: "1235",
      cateDNm: "티셔츠",
      brand: "P1",
      brandNm: "플래티"
    }
  ]
});
```

### 주문완료 페이지 (PU)
- 주문완료 페이지 방문 이력은 주문번호와 함께 호출해주어야 됩니다.
- 주문번호(orderNo)는 반드시 문자열(String) 타입으로 전달해야 합니다.
- 상품 정보가 있는 경우에는 상품 정보 목록 값을 추가로 전달 할 수 있습니다.  
- 상품 정보 목록(goods)의 타입은 Goods[] 이며, 상세한 필드별 설명은 [Goods 스키마 문서](../specs/action/schema.md#goods)를 참고해주세요.


- 상품 정보가 없는 경우 orderNo만 전달하는 예시
```javascript
groobee( "PU", { orderNo : "PU1234567890" } );
```

- 상품 정보가 있는 경우 orderNo와 Goods[]를 함께 전달하는 예시
```javascript
groobee( "PU", { 
  orderNo : "PU0102030405",
  goods : [
    {
      name: "파란색 줄무늬 티셔츠",
      code: "0001",
      amt: 10000,
      prc: 15000,
      salePrc: 10000,
      cnt: 1,
      cat: "1234", 
      cateNm: "티셔츠", 
      catL: "1", 
      cateLNm: "의류", 
      catM: "12", 
      cateMNm: "남성", 
      catS: "123", 
      cateSNm: "남성상의", 
      catD: "1234", 
      cateDNm: "티셔츠", 
      brand: "P1", 
      brandNm: "플래티" 
    },
    {
      name: "흰 줄무늬 티셔츠",
      code: "0001",
      amt: 45000,
      prc: 20000,
      salePrc: 15000,
      cnt: 3,
      cat: "1235",
      cateNm: "티셔츠",
      catL: "1",
      cateLNm: "의류",
      catM: "12",
      cateMNm: "남성",
      catS: "123",
      cateSNm: "남성상의",
      catD: "1235",
      cateDNm: "티셔츠",
      brand: "P1",
      brandNm: "플래티"
    }
  ]
});
```

### 카테고리 페이지 (CA)
- 카테고리 페이지 방문 이력은 카테고리 정보와 함께 호출해주어야 됩니다.
- 카테고리 정보(category)의 타입은 Category 이며, 상세한 필드별 설명은 [Category 스키마 문서](../specs/action/schema.md#category)를 참고해주세요.
```javascript
groobee( "CA", {
  category : {
    cateCd: "1234",
    cateNm: "티셔츠",
    catL: "1",
    cateLNm: "의류",
    catM: "12",
    cateMNm: "남성",
    catS: "123",
    cateSNm: "남성상의",
    catD: "1234",
    cateDNm: "티셔츠"
  }
});
```

### 

---

## SPA 환경 (React, Vue 등)

---

## Cafe24

---

## 고도몰

---

## 고도몰 (옛날버전)

---

## 메이크샵

---

## 위사 (스마트윙)

---

## 다음 단계

- [추천 캠페인 사용법 가이드](installation-web-recommend.md)로 이동하여 추천 캠페인 사용법을 확인해보세요.
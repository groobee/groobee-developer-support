# Groobee 스크립트 설치 가이드 - 행동 이력 수집

이 문서는 웹 환경에서 Groobee 스크립트를 **실제 서비스에 맞게 설치**하기 위한 가이드 중 행동 이력 수집 방법을 기술한 문서입니다.

---

## 행동 이력 수집
- Groobee로 사용자별 맞춤 캠페인을 제공하기 위해서는 행동 이력 수집이 필요합니다.
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
- [커스텀 웹 사이트 (Custom)](#custom)
- [SPA 환경 (React, Vue 등)](#spa)
- [Cafe24](#cafe24)
- [고도몰](#godo)
- [고도몰 (옛날버전)](#oldgodo)
- [메이크샵](#makeshop)
- [위사 (스마트윙)](#wisawing)

---

<a id="custom"></a>
## 커스텀 웹 사이트 (Custom)
페이지 내에 [공통 스크립트](../installation/installation-web-common-script.md)가 custom 유형으로 정상 설치 되어 있다면,  
아래와 같은 자바스크립트 함수를 사용 할 수 있습니다.  
아래 함수를 타입에 맞는 데이터를 넣어 호출하면 해당 행동 이력이 Groobee로 전송되어 수집됩니다.

```javascript
groobee("행동코드", 값);
```

<details>
<summary>커스텀 웹 사이트 행동 이력 수집 방법 보기</summary>

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
- 상품 상태(status) 필드는 품절이거나 상품이 판매상태가 아닐 경우에만 "SS" 값을 넣어주시면 됩니다.  
  정상 판매중인 상품의 경우에는 빈 문자열("")로 전달해주세요.

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

### 장바구니 담기 (AC)
- 장바구니 담기 이벤트는 장바구니에 담긴 상품 정보와 함께 호출해주어야 됩니다.
- 상품 정보(goods)의 타입은 Goods 이며, 상세한 필드별 설명은 [Goods 스키마 문서](../specs/action/schema.md#goods)를 참고해주세요.

```javascript
groobee( "AC", {
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

### 장바구니 제거 (DC)
- 장바구니 제거 이벤트는 장바구니에서 제거된 상품 정보와 함께 호출해주어야 됩니다.
- 상품 정보(goods)의 타입은 Goods 이며, 상세한 필드별 설명은 [Goods 스키마 문서](../specs/action/schema.md#goods)를 참고해주세요.
- 상품수(cnt) 필드는 장바구니에서 제거된 수량을 의미합니다.  
  - 예) 장바구니에 3개 담긴 상품을 모두 제거한 경우 cnt: 3 으로 전달

```javascript
groobee( "DC", {
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
    }
  ]
});
```
</details>

---

<a id="spa"></a>
## SPA 환경 (React, Vue 등)
페이지 내에 [공통 스크립트](../installation/installation-web-common-script.md)가 custom spa유형으로 정상 설치 되어 있다면,  
아래와 같은 자바스크립트 함수를 사용 할 수 있습니다.  
아래 함수를 타입에 맞는 데이터를 넣어 호출하면 해당 행동 이력이 Groobee로 전송되어 수집됩니다.

```javascript
groobee.action("행동코드", 값);
```

> **중요**  
>   
> SPA 모드로 공통 스크립트를 설치한 경우,      
> groobee.start()가 호출되지 않으면, groobee.action() 함수를 사용할 수 없습니다.      
> groobee.start() 함수를 호출하여 초기화 후 사용해야 합니다.  
> [SPA 환경 공통 스크립트 설치법](../installation/installation-web-common-script.md#spa) 문서를 참고해주세요.

<details>
<summary>SPA 웹 사이트 행동 이력 수집 방법 보기</summary>

### 메인 페이지 (MA)
- 메인 페이지 방문 이력은 [웹 페이지 URL 등록](../prerequisites/web-page-url-registration.md)이 되어 있다면 자동으로 수집됩니다.  
  별도의 코드 삽입이 필요하지 않습니다.

### 검색 결과 페이지 (SE)
- 검색 결과 페이지 방문 이력은 검색어(keyword)와 함께 호출해주어야 됩니다.
```javascript
groobee.action( "SE", { keyword : "겨울옷" } );
```

### 상품 상세 페이지 (VG)
- 상품 상세 페이지 방문 이력은 상품 정보 목록과 함께 호출해주어야 됩니다.
- 상품 정보 목록(goods)의 타입은 Goods[] 이며, 상세한 필드별 설명은 [Goods 스키마 문서](../specs/action/schema.md#goods)를 참고해주세요.
- 상품 상태(status) 필드는 품절이거나 상품이 판매상태가 아닐 경우에만 "SS" 값을 넣어주시면 됩니다.  
  정상 판매중인 상품의 경우에는 빈 문자열("")로 전달해주세요.

```javascript
groobee.action( "VG", {
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
groobee.action( "VC", {
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
groobee.action( "OR", {
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
groobee.action( "PU", { orderNo : "PU1234567890" } );
```

- 상품 정보가 있는 경우 orderNo와 Goods[]를 함께 전달하는 예시

```javascript
groobee.action( "PU", { 
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
groobee.action( "CA", {
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

### 장바구니 담기 (AC)
- 장바구니 담기 이벤트는 장바구니에 담긴 상품 정보와 함께 호출해주어야 됩니다.
- 상품 정보(goods)의 타입은 Goods 이며, 상세한 필드별 설명은 [Goods 스키마 문서](../specs/action/schema.md#goods)를 참고해주세요.

```javascript
groobee.action( "AC", {
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

### 장바구니 제거 (DC)
- 장바구니 제거 이벤트는 장바구니에서 제거된 상품 정보와 함께 호출해주어야 됩니다.
- 상품 정보(goods)의 타입은 Goods 이며, 상세한 필드별 설명은 [Goods 스키마 문서](../specs/action/schema.md#goods)를 참고해주세요.
- 상품수(cnt) 필드는 장바구니에서 제거된 수량을 의미합니다.
  - 예) 장바구니에 3개 담긴 상품을 모두 제거한 경우 cnt: 3 으로 전달

```javascript
groobee( "DC", {
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
    }
  ]
});
```

</details>

---

<a id="cafe24"></a>
## Cafe24
페이지 내에 [공통 스크립트](../installation/installation-web-common-script.md)가 cafe24유형으로 정상 설치 되어 있다면,
스마트 디자인 편집기에서 아래 스크립트 들을 삽입하여 행동 이력을 수집할 수 있습니다.

<details>
<summary>CAFE24 웹 사이트 행동 이력 수집 방법 보기</summary>

### 메인 페이지 (MA)
- 메인 페이지 방문 이력은 [웹 페이지 URL 등록](../prerequisites/web-page-url-registration.md)이 되어 있다면 자동으로 수집됩니다.  
  별도의 코드 삽입이 필요하지 않습니다.

### 검색 결과 페이지 (SE)
- 검색 페이지 방문 이력은 [웹 페이지 URL 등록](../prerequisites/web-page-url-registration.md)이 되어 있다면 자동으로 수집됩니다.    
  별도의 코드 삽입이 필요하지 않습니다.

### 상품 상세 페이지 (VG)
- 상품 > 상품 상세 페이지 &lt;div module="product_detail"&gt; 바로 하단에 아래 스크립트를 삽입합니다.

##### PC  
[상품 상세 수집을 위한 스크립트 설치 위치 및 예시](../images/installation/cafe24/cafe24-detail-pos-pc.png)
```html
<!-- Groobee Selector Script -->
<div class="groobeeProductDetail" style="display: none;">
<span class="groobeeProductName">{$name}</span>
<span class="groobeeProductPrice">{$product_price}</span>
<span class="groobeeProductSalePrice">{$product_sale_price}</span>
<span class="groobeeProductCode">{$product_no}</span>
<span class="groobeeProductImage">{$medium_img}</span>
<span class="groobeeProductCategory"></span>
<span class="groobeeProductCategoryName"></span>
<span class="groobeeProductStatus">{$soldout_icon}</span>
</div>
<!-- End of Groobee Selector Script -->
```

##### 모바일  
[상품 상세 이력 수집을 위한 스크립트 설치 위치 및 예시](../images/installation/cafe24/cafe24-detail-pos-mo.png)
```html
<!-- Groobee Selector Script -->
<div class="groobeeProductDetail" style="display: none;">
<span class="groobeeProductName">{$name}</span>
<span class="groobeeProductPrice">{$product_price}</span>
<span class="groobeeProductSalePrice">{$txt_product_price_mobile}</span>
<span class="groobeeProductCode">{$product_no}</span>
<span class="groobeeProductImage">{$medium_img}</span>
<span class="groobeeProductCategory"></span>
<span class="groobeeProductCategoryName"></span>
<span class="groobeeProductStatus">{$soldout_icon}</span>
</div>
<!-- End of Groobee Selector Script -->
```

### 장바구니 페이지 (VC)
- 주문 > 장바구니 페이지 &lt;div module="Order_BasketPackage"&gt; 바로 하단에 아래 스크립트를 삽입합니다.  
[장바구니 이력 수집을 위한 스크립트 설치 위치 및 예시](../images/installation/cafe24/cafe24-cart-pos.png)
```html
<!-- Groobee Cart Selector Script -->
<div module="Order_NormNormal" style="display: none;">
<div class="groobeeCartList" module="Order_list">
<a class="groobeeProductA" href="/product/detail.html{$param}"></a>
<span class="groobeeProductName">{$name}</span>
<span class="groobeeProductAmount">{$sum_price_front}</span>
<span class="groobeeProductPrice">{$product_price_front}</span>
<span class="groobeeProductSalePrice">{$product_sale_price_front}</span>
<span class="groobeeProductCount">{$quantity}</span>
<span class="groobeeProductImage">{$img}</span>
</div>
</div>
<div module="Order_SuppNormal" style="display: none;">
<div class="groobeeCartList" module="Order_list">
<a class="groobeeProductA" href="/product/detail.html{$param}"></a>
<span class="groobeeProductName">{$name}</span>
<span class="groobeeProductAmount">{$sum_price_front}</span>
<span class="groobeeProductPrice">{$product_price_front}</span>
<span class="groobeeProductSalePrice">{$product_sale_price_front}</span>
<span class="groobeeProductCount">{$quantity}</span>
<span class="groobeeProductImage">{$img}</span>
</div>
</div>
<div module="Order_NormIndividual" style="display: none;">
<div class="groobeeCartList" module="Order_list">
<a class="groobeeProductA" href="/product/detail.html{$param}"></a>
<span class="groobeeProductName">{$name}</span>
<span class="groobeeProductAmount">{$sum_price_front}</span>
<span class="groobeeProductPrice">{$product_price_front}</span>
<span class="groobeeProductSalePrice">{$product_sale_price_front}</span>
<span class="groobeeProductCount">{$quantity}</span>
<span class="groobeeProductImage">{$img}</span>
</div>
</div>
<div module="Order_InstNormal" style="display: none;">
<div class="groobeeCartList" module="Order_list">
<a class="groobeeProductA" href="/product/detail.html{$param}"></a>
<span class="groobeeProductName">{$name}</span>
<span class="groobeeProductAmount">{$sum_price_front}</span>
<span class="groobeeProductPrice">{$product_price_front}</span>
<span class="groobeeProductSalePrice">{$product_sale_price_front}</span>
<span class="groobeeProductCount">{$quantity}</span>
<span class="groobeeProductImage">{$img}</span>
</div>
</div>
<!-- End of Groobee Cart Selector Script -->
<!-- 해외배송을 사용하는 사이트만 삽입 -->
<div module="Order_NormOversea" style="display: none;">
<div class="groobeeCartList" module="Order_list">
<a class="groobeeProductA" href="/product/detail.html{$param}"></a>
<span class="groobeeProductName">{$name}</span>
<span class="groobeeProductAmount">{$sum_price_front}</span>
<span class="groobeeProductPrice">{$product_price_front}</span>
<span class="groobeeProductSalePrice">{$product_sale_price_front}</span>
<span class="groobeeProductCount">{$quantity}</span>
<span class="groobeeProductImage">{$img}</span>
</div>
</div>
<!-- End of Groobee Cart Selector Script -->
```

### 주문서 작성 페이지 (OR)
- 주문 > 주문서 작성 페이지 &lt;div module="Order_form"&gt; 바로 하단에 아래 스크립트를 삽입합니다.  
[주문서 작성 이력 수집을 위한 스크립트 설치 위치 및 예시](../images/installation/cafe24/cafe24-order-pos.png)

```html
<!-- Groobee Order Selector Script -->
<div class="groobeeOrderList" module="Order_normallist" style="display: none;">
<a class="groobeeProductA" href="/product/detail.html{$param}"></a>
<span class="groobeeProductName">{$product_name_link}</span>
<span class="groobeeProductAmount">{$product_total_price_front}</span>
<span class="groobeeProductPrice">{$product_price_front}</span>
<span class="groobeeProductSalePrice">{$product_sale_price_front}</span>
<span class="groobeeProductCount">{$product_quantity_text}</span>
<span class="groobeeProductImage">{$product_image}</span>
</div>
<div class="groobeeOrderList" module="Order_supplierlist" style="display: none;">
<a class="groobeeProductA" href="/product/detail.html{$param}"></a>
<span class="groobeeProductName">{$product_name_link}</span>
<span class="groobeeProductAmount">{$product_total_price_front}</span>
<span class="groobeeProductPrice">{$product_price_front}</span>
<span class="groobeeProductSalePrice">{$product_sale_price_front}</span>
<span class="groobeeProductCount">{$product_quantity_text}</span>
<span class="groobeeProductImage">{$product_image}</span>
</div>
<div class="groobeeOrderList" module="Order_individuallist" style="display: none;">
<a class="groobeeProductA" href="/product/detail.html{$param}"></a>
<span class="groobeeProductName">{$product_name_link}</span>
<span class="groobeeProductAmount">{$product_total_price_front}</span>
<span class="groobeeProductPrice">{$product_price_front}</span>
<span class="groobeeProductSalePrice">{$product_sale_price_front}</span>
<span class="groobeeProductCount">{$product_quantity_text}</span>
<span class="groobeeProductImage">{$product_image}</span>
</div>
<!-- End of Groobee Order Selector Script -->
<!-- 해외배송을 사용하는 사이트만 삽입 -->
<div class="groobeeOrderList" module="Order_oversealist" style="display: none;">
<a class="groobeeProductA" href="/product/detail.html{$param}"></a>
<span class="groobeeProductName">{$product_name_link}</span>
<span class="groobeeProductAmount">{$product_total_price_front}</span>
<span class="groobeeProductPrice">{$product_price_front}</span>
<span class="groobeeProductSalePrice">{$product_sale_price_front}</span>
<span class="groobeeProductCount">{$product_quantity_text}</span>
<span class="groobeeProductImage">{$product_image}</span>
</div>
<!-- End of Groobee Order Selector Script -->
```

> **특이사항**  
> 모바일 간편(원터치) 주문서 이력은 수집 할 수 없습니다.

### 주문완료 페이지 (PU)
- 주문 완료 이력은 [웹 페이지 URL 등록](../prerequisites/web-page-url-registration.md)이 되어 있다면 자동으로 수집됩니다.  
  별도의 코드 삽입이 필요하지 않습니다.


> **특이사항**  
> 모바일 간편(원터치) 주문 이력은 수집 할 수 없습니다.

### 카테고리 페이지 (CA)
- 상품 > 상품 분류 페이지 &lt;div module="product_headcategory"&gt; 하단에 아래 스크립트를 삽입합니다.  
cafe24 유형은 현재 대카테고리 정보만 수집이 가능하며, 중/소/세부 카테고리 정보는 수집이 불가능합니다.  
[카테고리 이력 수집을 위한 스크립트 설치 위치 및 예시](../images/installation/cafe24/cafe24-category-pos.png)

```html
<div class="groobeeCategory" style="display:none">
  <span class="groobeeCategoryName">{$name_1}</span>
  <span class="groobeeCategoryCode">{$param_1}</span>
</div>
```


</details>

---

## 고도몰
페이지 내에 [공통 스크립트](../installation/installation-web-common-script.md)가 고도몰 유형 (godo5, godo5_m)으로 정상 설치 되어 있다면,
스마트 디자인 편집기에서 아래 스크립트 들을 삽입하여 행동 이력을 수집할 수 있습니다.

<details>
<summary>고도몰 웹 사이트 행동 이력 수집 방법 보기</summary>

### 메인 페이지 (MA)
- 메인 페이지 방문 이력은 [웹 페이지 URL 등록](../prerequisites/web-page-url-registration.md)이 되어 있다면 자동으로 수집됩니다.  
  별도의 코드 삽입이 필요하지 않습니다.

### 검색 결과 페이지 (SE)
- 검색 페이지 방문 이력은 [웹 페이지 URL 등록](../prerequisites/web-page-url-registration.md)이 되어 있다면 자동으로 수집됩니다.    
  별도의 코드 삽입이 필요하지 않습니다.

### 상품 상세 페이지 (VG)
- 상품 > 상품상세 페이지 > { # header } 하단에 아래 스크립트를 삽입합니다.  
[상품 상세 이력 수집을 위한 스크립트 설치 위치 및 예시](../images/installation/godo5/godo5-detail-pos.png)

```html
<!-- Groobee Selector Script -->
<div class="groobeeProductDetail" style="display: none;">
	<span class="groobeeProductName">{=goodsView['goodsNmDetail']}</span>
	<span class="groobeeProductPrice"><!--{ ? gd_isset(goodsView['fixedPrice']) > 0 }-->{=gd_isset(goodsView['fixedPrice'],0)}<!--{ : }-->{=gd_isset(goodsView['goodsPrice'],0)}<!--{ / }--></span>
	<span class="groobeeProductSalePrice">{=goodsView['goodsDcPricePrint']}</span>
	<span class="groobeeProductCode">{goodsView.goodsNo}</span>
	<span class="groobeeProductImage">{=goodsView['image']['detail']['img'][0]}</span>
	<span class="groobeeProductCategory">{=goodsView['cateCd']}</span>
	<!--{ @ goodsCategoryList }-->
	<span class="groobeeProductCategoryName">{=.cateNm}</span>
	<!--{ / }-->
	<span class="groobeeProductStatus"><!--{ ? goodsView['orderPossible'] == 'n' || goodsView['soldOut'] == 'y' }-->y<!--{ : }-->n<!--{ / }--></span>
</div>
<!-- End of Groobee Selector Script -->
```

### 장바구니 페이지 (VC)
- 주문 > 장바구니 > &lt;!--{ @ ..value_ }--&gt; 하단에 아래 스크립트를 삽입합니다.  
[장바구니 이력 수집을 위한 스크립트 설치 위치 및 예시](../images/installation/godo5/godo5-cart-pos.png)

```html
<!-- Groobee Cart Selector Script -->
<div class="groobeeCartList" style="display: none;">
  <a href="../goods/goods_view.php?goodsNo={=...goodsNo}" class="groobeeProductA"></a>
  <span class="groobeeProductName">{=...goodsNm}</span>
  <span class="groobeeProductCategory">{=...cateCd}</span>
  <span class="groobeeProductCount">{=...goodsCnt}</span>
  <span class="groobeeProductAmount">{=gd_global_currency_display(...price['goodsPriceSubtotal'])}</span>
  <span class="groobeeProductPrice"></span>
  <span class="groobeeProductSalePrice"></span>
  <span class="groobeeProductImage">{=...goodsImage}</span>
</div>
<!-- End of Groobee Cart Selector Script -->
```

### 주문서 작성 페이지 (OR)
- 주문 > 주문서 작성 > &lt;!--{ @ ..value_ }--&gt; 하단에 아래 스크립트를 삽입합니다.  
[주문서 작성 이력 수집을 위한 스크립트 설치 위치 및 예시](../images/installation/godo5/godo5-order-pos.png)

```html
<!-- Groobee Order Selector Script -->
<div class="groobeeOrderList" style="display: none;">
  <a href="../goods/goods_view.php?goodsNo={=...goodsNo}" class="groobeeProductA"></a>
  <span class="groobeeProductName">{=...goodsNm}</span>
  <span class="groobeeProductCategory">{=...cateCd}</span>
  <span class="groobeeProductCount">{=...goodsCnt}</span>
  <span class="groobeeProductAmount">{=gd_global_currency_display(...price['goodsPriceSubtotal'])}</span>
  <span class="groobeeProductPrice"></span>
  <span class="groobeeProductSalePrice"></span>
  <span class="groobeeProductImage">{=...goodsImage}</span>
</div>
<!-- End of Groobee Order Selector Script -->
```

### 주문완료 페이지 (PU)
- 주문 완료 이력은 [웹 페이지 URL 등록](../prerequisites/web-page-url-registration.md)이 되어 있다면 자동으로 수집됩니다.  
  별도의 코드 삽입이 필요하지 않습니다.

### 카테고리 페이지 (CA)
- 상품 > 상품 리스트 페이지 > { # header } 하단에 아래 스크립트를 삽입합니다.  
[카테고리 이력 수집을 위한 스크립트 설치 위치 및 예시](../images/installation/godo5/godo5-category-pos.png)

```html
<!-- Groobee Selector Script -->
<div class="groobeeCategory" style="display:none">
    <span class="groobeeCategoryName">{=goodsCategoryList[cateCd]['cateNm']}</span>
    <span class="groobeeCategoryCode">{=cateCd}</span>
</div>
<!-- End of Groobee Selector Script -->
```

---

## 고도몰 (옛날버전)

---

## 메이크샵

---

## 위사 (스마트윙)

---

## 다음 단계

- [추천 캠페인 사용법 가이드](installation-web-recommend.md)로 이동하여 추천 캠페인 사용법을 확인해보세요.
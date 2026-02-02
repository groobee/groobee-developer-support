# Schema
이 문서는 Groobee 행동 수집시 사용되는 데이터 스키마에 대해 설명합니다.

## Category (카테고리 정보)

| 필드명 | 타입 | 필수 | 설명 |
|--------|------|------|------|
| cateCd | string | O | 현재 페이지 카테고리 코드 |
| cateNm | string | O | 현재 페이지 카테고리명 |
| catL | string | - | 대분류 카테고리 코드 |
| cateLNm | string | - | 대분류 카테고리명 |
| catM | string | - | 중분류 카테고리 코드 |
| cateMNm | string | - | 중분류 카테고리명 |
| catS | string | - | 소분류 카테고리 코드 |
| cateSNm | string | - | 소분류 카테고리명 |
| catD | string | - | 세분류 카테고리 코드 |
| cateDNm | string | - | 세분류 카테고리명 |

## DetailGoods
상품 상세 화면 상품 정보

| 필드명 | 타입 | 필수 | 설명 |
|--------|------|------|------|
| name | string | O | 상품명 |
| code | string | O | 상품코드 |
| amt | number | O | 상품금액 (salePrc × 수량) |
| prc | number | - | 판매가(원가) |
| salePrc | number | O | 할인 판매가 |
| img | string | - | 상품 이미지 URL |
| status | string | - | 판매상태 (SS: 품절/중단) |
| cat | string | - | 카테고리 코드 |
| cateNm | string | - | 카테고리명 |
| catL | string | - | 대분류 코드 |
| cateLNm | string | - | 대분류명 |
| catM | string | - | 중분류 코드 |
| cateMNm | string | - | 중분류명 |
| catS | string | - | 소분류 코드 |
| cateSNm | string | - | 소분류명 |
| catD | string | - | 세분류 코드 |
| cateDNm | string | - | 세분류명 |
| brand | string | - | 브랜드 코드 |
| brandNm | string | - | 브랜드명 |
| plan | string[] | - | 기획전 코드 목록 |

## CartGoods (장바구니 화면 상품 정보)

| 필드명 | 타입 | 필수 | 설명 |
|--------|------|------|------|
| name | string | O | 상품명 |
| code | string | O | 상품코드 |
| amt | number | O | 상품금액 |
| prc | number | - | 판매가 |
| salePrc | number | O | 할인 판매가 |
| cnt | number | O | 수량 |
| cat | string | - | 카테고리 코드 |
| cateNm | string | - | 카테고리명 |
| ... | ... | ... | 동일 |
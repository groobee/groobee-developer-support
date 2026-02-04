# Schema
이 문서는 Groobee 행동 수집시 사용되는 데이터 스키마에 대해 설명합니다.

## Goods
- 상품 정보 스키마입니다.
- cat (카테고리 코드)는 현 상품의 최하위 카테고리 코드와 동일해야합니다.
  - 예) catL: 1, catM: 12, catS: 123, catD: 1234 인 경우 cat: 1234
  - 예) catL: a, catM: ab, catS: abc 인 경우 cat: abc

<table>
<thead>
<tr>
    <th rowspan="2">필드명</th>
    <th rowspan="2">타입</th>
    <th colspan="4">사용액션</th>
    <th rowspan="2">설명</th>
</tr>
<tr>
    <th>VG</th>
    <th>VC</th>
    <th>OR</th>
    <th>PU</th>
</tr>
</thead>
<tbody>
<tr>
    <td>name</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>상품명</td>
</tr>
<tr>
    <td>code</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>URL에 표시되는 상품코드</td>
</tr>
<tr>
    <td>amt</td>
    <td>Number</td>
    <td></td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>상품금액 ( 할인판매가 (salePrc) × 수량 (cnt) )</td>
</tr>
<tr>
    <td>prc</td>
    <td>Number</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>판매가(또는 원가)</td>
</tr>
<tr>
    <td>salePrc</td>
    <td>Number</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>할인 판매가 (실제 판매가)</td>
</tr>
<tr>
    <td>cnt</td>
    <td>Number</td>
    <td></td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>상품 수량 (장바구니/주문 단계)</td>
</tr>
<tr>
    <td>img</td>
    <td>String</td>
    <td>●</td>
    <td></td>
    <td></td>
    <td></td>
    <td>상품 이미지 전체 URL</td>
</tr>
<tr>
    <td>status</td>
    <td>String</td>
    <td>●</td>
    <td></td>
    <td></td>
    <td></td>
    <td>상품 판매 상태 (품절/판매중 아님 시 SS)</td>
</tr>

<tr>
    <td>cat</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>카테고리 코드</td>
</tr>
<tr>
    <td>cateNm</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>카테고리명</td>
</tr>
<tr>
    <td>catL</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>대분류 카테고리 코드</td>
</tr>
<tr>
    <td>cateLNm</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>대분류 카테고리명</td>
</tr>
<tr>
    <td>catM</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>중분류 카테고리 코드</td>
</tr>
<tr>
    <td>cateMNm</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>중분류 카테고리명</td>
</tr>
<tr>
    <td>catS</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>소분류 카테고리 코드</td>
</tr>
<tr>
    <td>cateSNm</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>소분류 카테고리명</td>
</tr>
<tr>
    <td>catD</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>세분류 카테고리 코드</td>
</tr>
<tr>
    <td>cateDNm</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>세분류 카테고리명</td>
</tr>
<tr>
    <td>brand</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>브랜드 코드</td>
</tr>
<tr>
    <td>brandNm</td>
    <td>String</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>●</td>
    <td>브랜드명</td>
</tr>
<tr>
    <td>plan[]</td>
    <td>Array&lt;String&gt;</td>
    <td>●</td>
    <td></td>
    <td></td>
    <td></td>
    <td>상품이 속한 기획전(관련 컨텐츠) 코드</td>
</tr>
</tbody>
</table>

## Category
- 카테고리 정보 스키마입니다.
- cateCd (카테고리 코드)는 현 상품의 최하위 카테고리 코드와 동일해야합니다.
    - 예) catL: 1, catM: 12, catS: 123, catD: 1234 인 경우 cateCd: 1234
    - 예) catL: a, catM: ab, catS: abc 인 경우 cateCd: abc

<table>
<thead>
<tr>
    <th>필드명</th>
    <th>타입</th>
    <th>설명</th>
</tr>
</thead>
<tbody>
<tr>
    <td>cateCd</td>
    <td>String</td>
    <td>현재 페이지의 카테고리코드</td>
</tr>
<tr>
    <td>cateNm</td>
    <td>String</td>
    <td>현재 페이지의 카테고리명</td>
</tr>
<tr>
    <td>catL</td>
    <td>String</td>
    <td>대분류 카테고리코드</td>
</tr>
<tr>
    <td>cateLNm</td>
    <td>String</td>
    <td>대분류 카테고리명</td>
</tr>
<tr>
    <td>catM</td>
    <td>String</td>
    <td>중분류 카테고리코드</td>
</tr>
<tr>
    <td>cateMNm</td>
    <td>String</td>
    <td>중분류 카테고리명</td>
</tr>
<tr>
    <td>catS</td>
    <td>String</td>
    <td>소분류 카테고리코드</td>
</tr>
<tr>
    <td>cateSNm</td>
    <td>String</td>
    <td>소분류 카테고리명</td>
</tr>
<tr>
    <td>catD</td>
    <td>String</td>
    <td>세분류 카테고리코드</td>
</tr>
<tr>
    <td>cateDNm</td>
    <td>String</td>
    <td>세분류 카테고리명</td>
</tr>

</tbody>
</table>
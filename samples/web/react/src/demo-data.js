// 행동 이력 데모 데이터 — 필드 구성은 docs/specs/action/schema.md 의 Goods/Category 스키마 기준
// cat 은 상품의 최하위 카테고리 코드와 동일해야 하며, 하위 코드가 있으면 상위 코드도 함께 보냅니다.

const CATE = {
  cat: 'C1234',
  cateNm: '티셔츠',
  catL: 'C1',
  cateLNm: '의류',
  catM: 'C12',
  cateMNm: '남성',
  catS: 'C123',
  cateSNm: '남성상의',
  catD: 'C1234',
  cateDNm: '티셔츠',
}

const BRAND = { brand: 'P1', brandNm: '플래티어' }

/** 상품 상세(VG)용 — img / status 필수 (품절·판매중지면 status: "SS") */
export const DEMO_GOODS = {
  name: '파란색 줄무늬 티셔츠',
  code: '0011',
  prc: 25000, // 판매가(원가)
  salePrc: 20000, // 할인 판매가(실제 판매가)
  status: '',
  img: 'https://shop.example.com/product/0011.png',
  ...CATE,
  ...BRAND,
}

/** 장바구니(VC)/주문(OR)/구매(PU)용 — amt(= salePrc × cnt) / cnt 포함 */
export const DEMO_CART = [
  {
    name: '파란색 줄무늬 티셔츠',
    code: '0011',
    amt: 20000,
    prc: 25000,
    salePrc: 20000,
    cnt: 1,
    ...CATE,
    ...BRAND,
  },
  {
    name: '흰색 줄무늬 티셔츠',
    code: '0012',
    amt: 45000,
    prc: 20000,
    salePrc: 15000,
    cnt: 3,
    ...CATE,
    ...BRAND,
  },
]

/** 카테고리(CA)용 — cateCd 는 최하위 카테고리 코드 */
export const DEMO_CATEGORY = {
  cateCd: 'C1234',
  cateNm: '티셔츠',
  catL: 'C1',
  cateLNm: '의류',
  catM: 'C12',
  cateMNm: '남성',
  catS: 'C123',
  cateSNm: '남성상의',
  catD: 'C1234',
  cateDNm: '티셔츠',
}

/** 로그인 데모용 회원 (값은 어드민의 회원 데이터 설정과 맞아야 합니다) */
export const DEMO_MEMBER = {
  id: 'groobee_demo_user',
  grade: 'VIP',
  gender: 'M',
  type: 'general',
  age: '30',
}

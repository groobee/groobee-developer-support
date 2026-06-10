import { groobeeAction } from './groobee'
import { DEMO_CART } from './demo-data'

// 각 페이지의 "페이지 진입" 이력은 GroobeeTracker 가 라우트 전환 시점에 보냅니다.
// 페이지 안에서는 클릭형 이벤트(AC: 담기, DC: 빼기)만 직접 호출합니다.

const box = { padding: 16, background: '#fff', borderRadius: 8 }

export function Home() {
  return (
    <div style={box}>
      <h2>메인 (MA)</h2>
      <p>
        라우트 진입 시 <code>groobee.start()</code> 가 호출되어 메인 페이지 이력이 전송됩니다.
      </p>
    </div>
  )
}

export function Search() {
  return (
    <div style={box}>
      <h2>검색 결과 (SE)</h2>
      <p>
        <code>action("SE", {'{ keyword }'})</code> — 검색어는 URL 의 <code>?q=</code> 값을 사용합니다.
      </p>
    </div>
  )
}

export function Product() {
  const addToCart = () => {
    // 장바구니 담기 이벤트 (페이지 이동 없는 클릭형 행동)
    groobeeAction('AC', { goods: [DEMO_CART[0]] })
  }
  return (
    <div style={box}>
      <h2>상품 상세 (VG)</h2>
      <p>
        <code>action("VG", {'{ goods: [...] }'})</code> — 상품 정보(이미지·카테고리 포함)가 전송됩니다.
      </p>
      <button onClick={addToCart}>장바구니 담기 (AC)</button>
    </div>
  )
}

export function Category() {
  return (
    <div style={box}>
      <h2>카테고리 (CA)</h2>
      <p>
        <code>action("CA", {'{ category }'})</code> — 대/중/소/세분류 코드가 전송됩니다.
      </p>
    </div>
  )
}

export function Cart() {
  const removeFromCart = () => {
    // 장바구니 빼기 이벤트 — cnt 는 "뺀 수량"
    groobeeAction('DC', { goods: [{ ...DEMO_CART[0], cnt: 1 }] })
  }
  return (
    <div style={box}>
      <h2>장바구니 (VC)</h2>
      <p>
        <code>action("VC", {'{ goods: [...] }'})</code> — 담긴 상품 목록이 전송됩니다.
      </p>
      <button onClick={removeFromCart}>장바구니 빼기 (DC)</button>
    </div>
  )
}

export function OrderComplete() {
  return (
    <div style={box}>
      <h2>주문 완료 (PU)</h2>
      <p>
        <code>action("PU", {'{ orderNo, goods }'})</code> — 주문번호는 문자열이어야 합니다.
      </p>
    </div>
  )
}

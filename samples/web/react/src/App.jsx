import { useEffect, useState } from 'react'
import { NavLink, Route, Routes } from 'react-router-dom'
import GroobeeTracker from './GroobeeTracker'
import Recommend from './Recommend'
import { Cart, Category, Home, OrderComplete, Product, Search } from './pages'
import { setGroobeeMemberMeta } from './groobee'
import { DEMO_MEMBER } from './demo-data'

const NAV = [
  ['/', '메인 (MA)'],
  ['/search?q=겨울옷', '검색 (SE)'],
  ['/product/0011', '상품 상세 (VG)'],
  ['/category/C1234', '카테고리 (CA)'],
  ['/cart', '장바구니 (VC)'],
  ['/order-complete/PU1234567890', '주문 완료 (PU)'],
  ['/recommend', 'AI 추천'],
]

export default function App() {
  const [isLogin, setIsLogin] = useState(false)
  const [logs, setLogs] = useState([])

  // 회원 정보 메타 태그 — 로그인 상태가 바뀔 때마다 갱신 (비로그인이면 빈 값)
  useEffect(() => {
    setGroobeeMemberMeta(isLogin ? DEMO_MEMBER : null)
  }, [isLogin])

  // 데모 전용: groobee 호출 내역을 화면 하단에 표시
  useEffect(() => {
    const onLog = (e) => setLogs((prev) => [e.detail, ...prev].slice(0, 30))
    window.addEventListener('groobee-sample-log', onLog)
    return () => window.removeEventListener('groobee-sample-log', onLog)
  }, [])

  return (
    <div style={{ maxWidth: 760, margin: '0 auto', padding: 16, fontFamily: 'sans-serif' }}>
      <header style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
        <h1 style={{ fontSize: 20, margin: 0 }}>Groobee React SPA Sample</h1>
        <button onClick={() => setIsLogin((v) => !v)} style={{ marginLeft: 'auto' }}>
          {isLogin ? `로그아웃 (${DEMO_MEMBER.id})` : '로그인'}
        </button>
      </header>

      <nav style={{ display: 'flex', flexWrap: 'wrap', gap: 8, margin: '16px 0' }}>
        {NAV.map(([to, label]) => (
          <NavLink key={to} to={to} style={{ padding: '6px 10px', background: '#e8eaf6', borderRadius: 6 }}>
            {label}
          </NavLink>
        ))}
      </nav>

      {/* 라우트 전환마다 start()/action() 을 호출하는 추적기 */}
      <GroobeeTracker />

      <main>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/search" element={<Search />} />
          <Route path="/product/:goodsCd" element={<Product />} />
          <Route path="/category/:cateCd" element={<Category />} />
          <Route path="/cart" element={<Cart />} />
          <Route path="/order-complete/:orderNo" element={<OrderComplete />} />
          <Route path="/recommend" element={<Recommend />} />
        </Routes>
      </main>

      <footer style={{ marginTop: 24 }}>
        <div style={{ fontSize: 12, color: '#5c6bc0', fontWeight: 'bold' }}>
          호출 로그 (개발자도구 Network 탭에서 *.groobee.io 요청도 확인하세요)
        </div>
        <pre style={{ background: '#1e1e2a', color: '#e0e0e0', padding: 10, borderRadius: 8, fontSize: 11, minHeight: 120, whiteSpace: 'pre-wrap', wordBreak: 'break-all' }}>
          {logs.join('\n') || '(아직 호출 없음)'}
        </pre>
      </footer>
    </div>
  )
}

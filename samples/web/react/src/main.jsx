import { createRoot } from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import App from './App'

// 참고: <StrictMode> 는 개발 모드에서 effect 를 2회 실행해
// 행동 이력이 중복 전송된 것처럼 보이므로 이 데모에서는 사용하지 않습니다.
createRoot(document.getElementById('root')).render(
  <BrowserRouter>
    <App />
  </BrowserRouter>,
)

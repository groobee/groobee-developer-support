import { useEffect } from 'react'
import { useLocation } from 'react-router-dom'
import { groobeeStart, groobeeAction } from './groobee'
import { DEMO_GOODS, DEMO_CART, DEMO_CATEGORY } from './demo-data'

/**
 * SPA 행동 이력 추적의 핵심.
 *
 * 라우트(pathname)가 바뀔 때마다 정확히 1회:
 *  - 메인(MA)/기타(LO) 페이지 → groobee.start()
 *  - 그 외 페이지            → groobee.action(행동코드, 데이터)
 *
 * 실서비스에서는 DEMO_* 자리에 해당 페이지의 실제 상품/카테고리/주문 데이터를 넣으세요.
 */
export default function GroobeeTracker() {
  const { pathname, search } = useLocation()

  useEffect(() => {
    if (pathname.startsWith('/search')) {
      const keyword = new URLSearchParams(search).get('q') || '겨울옷'
      groobeeAction('SE', { keyword })
    } else if (pathname.startsWith('/product')) {
      groobeeAction('VG', { goods: [DEMO_GOODS] })
    } else if (pathname.startsWith('/category')) {
      groobeeAction('CA', { category: DEMO_CATEGORY })
    } else if (pathname.startsWith('/cart')) {
      groobeeAction('VC', { goods: DEMO_CART })
    } else if (pathname.startsWith('/order-complete')) {
      groobeeAction('PU', { orderNo: 'PU1234567890', goods: DEMO_CART })
    } else {
      // 메인('/')과 추천 데모 등 나머지 페이지(LO)
      groobeeStart()
    }
  }, [pathname, search])

  return null
}

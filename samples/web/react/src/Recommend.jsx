import { useEffect, useState } from 'react'
import { getRecommendAsync, sendRecommendStat } from './groobee'

const CAMPAIGN_KEY = import.meta.env.VITE_GROOBEE_RECOMMEND_CAMPAIGN_KEY

/**
 * AI 추천 — 데이터 요청형 데모.
 * 캠페인키로 추천 상품 목록을 받아 렌더링하고,
 * 렌더링 후 노출(DI) 통계, 상품 클릭 시 클릭(CL) 통계를 전송합니다.
 */
export default function Recommend() {
  const [data, setData] = useState(null)
  const [error, setError] = useState(null)

  useEffect(() => {
    getRecommendAsync(CAMPAIGN_KEY)
      .then((res) => {
        setData(res)
        const goodsCds = (res?.goodsList ?? []).map((g) => g.goodsCd)
        if (goodsCds.length > 0) {
          // 추천 상품이 화면에 노출됨 → 노출(DI) 통계
          sendRecommendStat('DI', {
            campaignKey: res.campaignKey,
            algorithmCd: res.algorithmCd,
            goodsCds,
          })
        }
      })
      .catch((e) => setError(e?.message ?? String(e)))
  }, [])

  const onClickGoods = (goodsCd) => {
    // 추천 상품 클릭 → 클릭(CL) 통계
    sendRecommendStat('CL', {
      campaignKey: data.campaignKey,
      algorithmCd: data.algorithmCd,
      goodsCds: [goodsCd],
    })
  }

  return (
    <div style={{ padding: 16, background: '#fff', borderRadius: 8 }}>
      <h2>AI 추천 (데이터 요청형)</h2>
      <p>
        <code>groobee.getGroobeeRecommendAsync("{CAMPAIGN_KEY}")</code>
      </p>

      {error && <p style={{ color: '#c62828' }}>추천 요청 실패: {error}</p>}
      {!data && !error && <p>불러오는 중…</p>}

      {data && (
        <ul>
          {(data.goodsList ?? []).map((g) => (
            <li key={g.goodsCd}>
              <button onClick={() => onClickGoods(g.goodsCd)}>
                {g.goodsNm} ({g.goodsCd}) {g.goodsSalePrc?.toLocaleString?.() ?? g.goodsSalePrc}원
              </button>
            </li>
          ))}
          {(data.goodsList ?? []).length === 0 && <li>추천 결과가 비어 있습니다.</li>}
        </ul>
      )}
    </div>
  )
}

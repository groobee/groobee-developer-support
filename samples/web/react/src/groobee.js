// Groobee SPA 연동 헬퍼
//
// window.groobee 와 start/action 큐 스텁은 index.html 의 공통 스크립트에서 정의됩니다.
// 외부 스크립트(groobee.init.min.js) 로드 전에 호출해도 큐에 쌓였다가 순서대로 처리됩니다.

/** 데모 화면 하단 로그 표시용 (실제 연동에는 불필요) */
function log(label, payload) {
  console.info('[groobee]', label, payload ?? '')
  window.dispatchEvent(
    new CustomEvent('groobee-sample-log', {
      detail: payload ? `${label} ${JSON.stringify(payload)}` : label,
    }),
  )
}

/**
 * 메인(MA)/기타(LO) 페이지 진입.
 * SPA 에서는 라우트가 바뀔 때마다 start() 또는 action() 을 정확히 1회 호출해야 합니다.
 */
export function groobeeStart() {
  window.groobee.start()
  log('start()  → 페이지 이력(MA/LO) 전송')
}

/** MA/LO 외 페이지·이벤트의 행동 이력 전송 (행동 코드: docs/specs/action) */
export function groobeeAction(type, payload) {
  window.groobee.action(type, payload)
  log(`action("${type}")`, payload)
}

// ── 회원 정보 메타 태그 ────────────────────────────────────────────────
// 가이드(installation-web-member-data.md)의 meta 태그를 SPA 에서는 JS 로 동적 갱신합니다.
// ⚠️ 비로그인 상태에서는 모든 값이 빈 문자열이어야 합니다.

function setMeta(property, content) {
  let tag = document.querySelector(`meta[property="${property}"]`)
  if (!tag) {
    tag = document.createElement('meta')
    tag.setAttribute('property', property)
    document.head.appendChild(tag)
  }
  tag.setAttribute('content', content)
}

/** 로그인 시 member 객체 전달, 로그아웃 시 null 전달 */
export function setGroobeeMemberMeta(member) {
  setMeta('groobee:member_id', member?.id ?? '')
  setMeta('groobee:member_grade', member?.grade ?? '')
  setMeta('groobee:member_gender', member?.gender ?? '')
  setMeta('groobee:member_type', member?.type ?? '')
  setMeta('groobee:member_age', member?.age ?? '')
  log(member ? `회원 메타 갱신 (id=${member.id})` : '회원 메타 비움 (로그아웃)')
}

// ── AI 추천 (데이터 요청형) ────────────────────────────────────────────
// 외부 스크립트가 아직 로드되지 않았을 수 있어, 가이드 권장대로 재시도 가드를 둡니다.
// (docs/detail/web-recommend-data-request.md)

export function getRecommendAsync(campaignKey, timeoutMs = 3000) {
  return new Promise((resolve, reject) => {
    const call = () =>
      window.groobee.getGroobeeRecommendAsync(campaignKey, timeoutMs).then(resolve, reject)

    if (typeof window.groobee?.getGroobeeRecommendAsync === 'function') {
      call()
      return
    }
    let tryCnt = 0
    const timer = setInterval(() => {
      if (typeof window.groobee?.getGroobeeRecommendAsync === 'function') {
        clearInterval(timer)
        call()
      } else if (++tryCnt >= 6) {
        clearInterval(timer)
        reject(new Error('Groobee 스크립트가 로드되지 않았습니다.'))
      }
    }, 500)
  })
}

/**
 * 추천 노출(DI)/클릭(CL) 통계 전송.
 * @param type 'DI' | 'CL'
 */
export function sendRecommendStat(type, { campaignKey, algorithmCd, goodsCds }) {
  const groobeeObj = {
    algorithmCd,
    campaignKey,
    campaignTypeCd: 'RE', // 고정값
    goods: goodsCds.map((goodsCd) => ({ goodsCd })),
  }
  window.groobee.send(type, groobeeObj)
  log(`send("${type}")`, groobeeObj)
}

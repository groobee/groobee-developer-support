// Groobee 일반(custom) 웹 샘플 설정
//
// ⚠️ 아래 값을 본인의 Groobee 어드민 발급 정보로 교체하세요.
//    (공개 저장소에 실제 서비스키를 커밋하지 않도록 주의)
//
// 모든 페이지가 공통 스크립트보다 먼저 이 파일을 로드합니다.
window.GROOBEE_CONFIG = {
  // 어드민에서 발급받은 서비스키
  serviceKey: 'YOUR_GROOBEE_SERVICE_KEY',

  // AI 추천 캠페인키 (어드민 > 추천 캠페인) — recommend.html 에서 사용
  recommendCampaignKey: 'YOUR_RECOMMEND_CAMPAIGN_KEY',
}

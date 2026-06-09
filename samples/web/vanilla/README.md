# Groobee Vanilla 샘플 (일반 웹)

JSP/PHP 등 **페이지가 전체 로드되는 일반(비 SPA) 웹사이트**에 Groobee 스크립트를
설치하는 방식을 보여주는 멀티 페이지 정적 HTML 샘플입니다. 빌드 도구 없이 동작합니다.

SPA 모드와의 차이:

| | 일반(custom) — 이 샘플 | SPA — [react 샘플](../react) |
| --- | --- | --- |
| 스크립트 실행 | 페이지 전체 로드마다 자동 실행 | `isSPA: "true"` + 라우트 전환마다 직접 호출 |
| 메인(MA) 이력 | URL 등록 시 **자동 수집** (코드 불필요) | `groobee.start()` 호출 |
| 행동 이력 | `groobee("행동코드", 데이터)` | `groobee.action("행동코드", 데이터)` |
| 회원 정보 | 서버가 meta 태그에 회원 값 렌더링 | JS 로 meta 태그 동적 갱신 |

---

## 구조

```
vanilla/
├── groobee-config.js     # ⚠️ 서비스키 / 추천 캠페인키 — 여기만 수정하면 됩니다
├── index.html            # ★ 메인 (MA — 자동 수집, 공통 스크립트 설치 형태 참고)
├── search.html           # 검색 (SE)
├── product.html          # 상품 상세 (VG) + 담기 버튼 (AC)
├── category.html         # 카테고리 (CA)
├── cart.html             # 장바구니 (VC) + 빼기 버튼 (DC)
├── order-complete.html   # 주문 완료 (PU)
├── recommend.html        # ★ AI 추천 — DIV 형 + 데이터 요청형(DI/CL 통계)
└── style.css
```

모든 페이지의 `</head>` 직전에 동일한 공통 스크립트 블록이 들어갑니다.
실서비스에서는 이 블록을 공통 레이아웃(JSP include 등)에 한 번만 넣으면 됩니다.

---

## 시작하기

### 1. 키 입력

[`groobee-config.js`](groobee-config.js) 의 값을 본인 발급 정보로 교체하세요.

```js
window.GROOBEE_CONFIG = {
  serviceKey: 'YOUR_GROOBEE_SERVICE_KEY',            // 어드민 발급 서비스키
  recommendCampaignKey: 'YOUR_RECOMMEND_CAMPAIGN_KEY', // AI 추천 캠페인키
}
```

> 가이드 원문처럼 `groobee("serviceKey", "발급받은_서비스키")` 에 직접 써도 되지만,
> 이 샘플은 페이지가 여러 개라 키를 한 파일로 모았습니다.
> 공개 저장소에 실제 키를 커밋하지 않도록 주의하세요.

### 2. 로컬 서버로 실행

스크립트 주소가 `//static.groobee.io/...` (프로토콜 상대)라 `file://` 로 열면 동작하지 않습니다.

```bash
cd samples/web/vanilla
python3 -m http.server 5500        # 또는: npx serve .
# → http://localhost:5500
```

> 사전 준비: 어드민에 사이트 도메인이 등록되어 있어야 합니다. **로컬 개발은 `localhost` 를 등록**하세요.
> 👉 [도메인 등록 가이드](../../../docs/prerequisites/web-domain-registration.md)
> 메인(MA) 자동 수집은 페이지 URL 등록도 필요합니다.
> 👉 [웹 페이지 URL 등록](../../../docs/prerequisites/web-page-url-registration.md)

### 3. 확인

메뉴를 클릭해 페이지를 이동하면서 개발자도구 Network 탭에서
`*.groobee.io` 요청(인증·행동 이력 전송)을 확인하세요.

---

## 페이지별 연동 내용

| 페이지 | 호출 | 행동 코드 |
| --- | --- | --- |
| `index.html` | (코드 없음 — URL 등록 시 자동 수집) | MA |
| `search.html?q=…` | `groobee("SE", { keyword })` | SE |
| `product.html` | `groobee("VG", { goods })` + 버튼 `groobee("AC", { goods })` | VG · AC |
| `category.html` | `groobee("CA", { category })` | CA |
| `cart.html` | `groobee("VC", { goods })` + 버튼 `groobee("DC", { goods })` | VC · DC |
| `order-complete.html` | `groobee("PU", { orderNo, goods })` | PU |
| `recommend.html` | DIV 형(`groobee_recommendation`) + `getGroobeeRecommendAsync()` → `groobee.send("DI"/"CL")` | AI 추천 |

데모의 상품/카테고리 값은 [행동 스키마](../../../docs/specs/action/schema.md) 기준이며,
실서비스에서는 서버 템플릿이 실제 값을 렌더링합니다.

회원 정보는 각 페이지 `<head>` 의 `groobee:member_*` meta 태그로 전달합니다 —
로그인 시 서버에서 회원 값을 렌더링하고, **비로그인이면 모두 빈 값**이어야 합니다.

---

## 관련 문서

- [공통 스크립트 설치](../../../docs/installation/installation-web-common-script.md) ·
  [회원 정보 연동](../../../docs/installation/installation-web-member-data.md) ·
  [행동 이력 수집](../../../docs/installation/installation-web-action.md) ·
  [AI 추천](../../../docs/installation/installation-web-recommend.md)
- [추천 DIV 형](../../../docs/detail/web-recommend-div.md) ·
  [추천 데이터 요청](../../../docs/detail/web-recommend-data-request.md)

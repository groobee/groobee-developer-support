# Groobee React SPA 샘플

React(SPA) 환경에서 Groobee 공통 스크립트를 **isSPA 모드**로 설치하고,
라우트 전환마다 행동 이력을 직접 전송하는 최소 동작 샘플입니다. (Vite + React Router)

SPA 는 페이지 전체가 다시 로드되지 않으므로, 자동 수집 대신
**라우트가 바뀔 때마다 `groobee.start()`(메인/기타) 또는 `groobee.action(행동코드, 데이터)`(그 외)를
정확히 1회 호출**하는 것이 연동의 핵심입니다.

---

## 구조

```
react/
├── index.html              # ★ 공통 스크립트(SPA 모드) 설치 — serviceKey / isSPA
├── .env                    # placeholder 키 (커밋됨)
├── .env.local.example      # 실제 키 기입용 예시 → .env.local 로 복사
└── src/
    ├── GroobeeTracker.jsx   # ★ 라우트 전환 → start()/action() 매핑 (연동 핵심)
    ├── groobee.js           # ★ start/action/회원 메타/추천 헬퍼
    ├── demo-data.js         # 행동 스키마 기준 데모 상품/카테고리/회원
    ├── App.jsx              # 네비 + 로그인 토글 + 호출 로그
    ├── pages.jsx            # 데모 페이지 (AC/DC 클릭 이벤트 포함)
    ├── Recommend.jsx        # AI 추천 (데이터 요청형 + DI/CL 통계)
    └── main.jsx
```

---

## 시작하기

### 1. 설정 파일 작성 (`.env.local`)

서비스키·추천 캠페인키는 `.env.local` 에 넣습니다. (`.gitignore` 대상이라 커밋되지 않습니다.
없으면 placeholder 로 실행은 되지만 서버 전송은 인증 실패합니다.)

```bash
cp .env.local.example .env.local
```

| 키 | 설명 |
| --- | --- |
| `VITE_GROOBEE_SERVICE_KEY` | 어드민에서 발급받은 서비스키 — `index.html` 의 `%VITE_GROOBEE_SERVICE_KEY%` 자리에 빌드 시 치환됩니다 |
| `VITE_GROOBEE_RECOMMEND_CAMPAIGN_KEY` | AI 추천 캠페인키 (어드민 > 추천 캠페인) |

> 사전 준비: 어드민에 사이트 도메인이 등록되어 있어야 합니다. **로컬 개발은 `localhost` 를 등록**하세요.
> 👉 [도메인 등록 가이드](../../../docs/prerequisites/web-domain-registration.md)

### 2. 실행

```bash
npm install
npm run dev        # http://localhost:5173
```

상단 메뉴로 페이지를 이동하면서 하단 **호출 로그**와
개발자도구 Network 탭의 `*.groobee.io` 요청을 확인하세요.

---

## 데모에서 확인할 수 있는 연동

| 라우트 | 호출 | 행동 코드 |
| --- | --- | --- |
| `/` | `groobee.start()` | MA (메인) |
| `/search?q=…` | `action("SE", { keyword })` | SE (검색) |
| `/product/0011` | `action("VG", { goods })` | VG (상품 상세) |
| `/category/C1234` | `action("CA", { category })` | CA (카테고리) |
| `/cart` | `action("VC", { goods })` | VC (장바구니 조회) |
| `/order-complete/…` | `action("PU", { orderNo, goods })` | PU (구매 완료) |
| `/recommend` | `start()` + `getGroobeeRecommendAsync()` → `send("DI"/"CL")` | LO + AI 추천 |
| 버튼: 담기/빼기 | `action("AC"/"DC", { goods })` | AC / DC |
| 버튼: 로그인/로그아웃 | `groobee:member_*` meta 태그 동적 갱신 | 회원 정보 연동 |

전체 행동 코드 목록과 데이터 스키마는 👉 [행동 유형](../../../docs/specs/action/README.md) ·
[행동 스키마](../../../docs/specs/action/schema.md)

---

## SPA 연동 핵심 규칙

1. **공통 스크립트는 `</head>` 직전에, `isSPA: "true"` 와 start/action 스텁 포함** —
   [`index.html`](index.html) 의 스니펫이 가이드 표준 형태입니다.
   스텁이 호출을 큐에 쌓아 두므로 외부 스크립트 로드 전에 호출돼도 안전합니다.
2. **라우트 전환마다 start() 또는 action() 을 정확히 1회** —
   [`GroobeeTracker.jsx`](src/GroobeeTracker.jsx) 가 `useLocation()` 으로 전환을 감지합니다.
   메인(MA)·기타(LO) 페이지는 `start()`, 나머지는 `action(코드, 데이터)` 입니다.
3. **회원 메타 태그는 로그인 상태가 바뀔 때마다 갱신, 비로그인이면 모두 빈 값** —
   [`groobee.js`](src/groobee.js) 의 `setGroobeeMemberMeta()` 참고.
4. **추천은 노출(DI)/클릭(CL) 통계까지 함께** — [`Recommend.jsx`](src/Recommend.jsx) 참고.
5. React `<StrictMode>` 는 개발 모드에서 effect 를 2회 실행해 이력이 중복 전송되므로
   이 데모에서는 사용하지 않습니다. (실서비스에서 사용한다면 중복 전송 방지를 직접 처리하세요)

---

## 관련 문서

- [공통 스크립트 설치](../../../docs/installation/installation-web-common-script.md) ·
  [회원 정보 연동](../../../docs/installation/installation-web-member-data.md) ·
  [행동 이력 수집](../../../docs/installation/installation-web-action.md) ·
  [AI 추천](../../../docs/installation/installation-web-recommend.md)
- [추천 데이터 요청](../../../docs/detail/web-recommend-data-request.md)

 Web 스크립트 설치 시작하기

이 문서는 Web 환경에서 Groobee 스크립트를 설치 전 숙지할 내용을 안내합니다.

---

## 적용 대상
이 가이드는 다음과 같은 유형의 사이트들에 Groobee 스크립트를 설치 하는 방법을 안내합니다.

- 커스텀 : 직접 만든 사이트입니다. 이 문서에서는 JSP, PHP 등, 이 문서에서는 SPA가 아닌 웹사이트를 말합니다. 
- 커스텀 SPA : React, Vue, Angular 등 SPA 프레임워크로 제작된 사이트를 말합니다.
- 쇼핑몰 솔루션 (Cafe24, GodoMall, GodoMall5, MakeShop, WISA) : 쇼핑몰 솔루션을 사용해 웹사이트를 제작한 경우입니다.

---

## 사전 준비

연동을 시작하기 전에 아래 항목을 준비해주세요.

- Groobee 어드민 사이트 접속용 계정 : 계정이 없는 경우 영업팀에 문의해주세요.  
  👉 [Groobee 사이트 링크](https://groobee.net/)
- 사이트가 사용할 Groobee 서비스키 확인 
- 웹 페이지 소스 수정 권한
- 어드민 사이트에 사이트 도메인 등록 (로컬 환경인 경우에는 localhost)  
  👉 [도메인 등록 가이드](../prerequisites/web-domain-registration.md)

---

## 스크립트 설치 순서
Groobee 스크립트 설치는 다음과 같은 순서로 진행됩니다.

### [1. 공통 스크립트 설치](../installation/installation-web-common-script.md)  
웹 환경에서 Groobee를 사용하려면, 기본적으로 공통스크립트 설치가 필요합니다.  
공통 스크립트는 Groobee 서비스 사용 인증, 행동 이력 수집, AI 추천 기능 사용을 위한 필수 스크립트이며,  
이 단계에서는 Groobee 서비스 인증을 위한 공통스크립트를 설치하는 방법을 안내합니다.

### [2. 회원 정보 연동](../installation/installation-web-member-data.md)

웹 환경에서 Groobee와 회원 정보를 연동하려면, 사이트 내에 회원정보 전달용 코드를 추가해야 하며,  
이 단계에서는 회원 정보를 수집할 수 있는 추가 코드트를 작성하는 방법을 안내합니다.

### [3. 행동 이력 수집](../installation/installation-web-action.md)

웹 환경에서 Groobee 스크립트를 활용해 다양한 유형의 행동 이력을 수집하는 방법을 안내합니다.

### [4. AI 추천 사용법](../installation/installation-web-recommend.md)

웹 환경에서 Groobee 스크립트를 활용해 AI 추천을 사용하는 방법을 안내합니다.

---

## 3. 다음 단계

위 내용을 숙지하셨다면, [상세 설치 문서](../installation/README.md)를 참고하여 서비스에 맞게 추가 설정을 진행해주세요.
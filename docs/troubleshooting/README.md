# 트러블슈팅
Groobee 사용 중 발생할 수 있는 주요 문제와 해결 방법을 안내합니다.

## 문제 해결 가이드 목록
- [스크립트를 설치했는데 아무런 데이터도 수집되지 않습니다.](#no-data-collected-but-script-installed)
- [기타 행동만 수집됩니다.](#only-lo-action-collected) 
- [로컬 환경에서 Groobee가 정상 동작하지 않습니다.](#local-environment-not-working)

---

<a id="no-data-collected-but-script-installed"></a>
## Q. 스크립트를 설치했는데 아무런 데이터도 수집되지 않습니다.

### 스크립트가 실제로 로드되고 있는지 확인하세요.
- 크롬 브라우저 기준 브라우저 개발자도구(F12)를 엽니다.
- 개발자도구의 Network 탭을 열어 아래와 같은 Groobee 관련 JS 파일이 정상적으로 로드되는지 확인합니다.  
  Network 탭에서 groobee로 검색하면, 관련 요청을 쉽게 찾을 수 있습니다.
  - groobee.init.js
  - groobee.core.js
  - groobee.front.js
- 개발자도구의 콘솔(Console) 창에 Groobee 에러가 없는지 확인합니다.
      
> 스크립트 설치 방법은  
> 👉 [Web 스크립트 설치 시작하기](../getting-started/gettingstart-web.md) 문서를 참고해주세요.


### 서비스키가 정확한지 확인하세요.
- 발급받은 서비스키가 스크립트에 정확히 입력되어 있는지 확인합니다.
- 오타, 공백, 잘못된 환경(dev/prod 키 혼용)을 점검하세요.
   
> 서비스키 적용 방법은  
> 👉 [공통 스크립트 설치 가이드](../installation/installation-web-common-script.md) 문서를 참고해주세요.


### 관리자 어드민에 도메인이 등록되어 있는지 확인하세요.
- 관리자 설정 메뉴에 접속해 도메인이 등록되어 있는지 확인합니다.
- 도메인이 올바르게 등록되지 않은 경우 데이터가 수집되지 않습니다.
    
> 도메인 등록 방법은  
> 👉 [도메인 등록 가이드](../prerequisites/web-domain-registration.md) 문서를 참고해주세요.


### 사내망에서 접속하는 경우 네트워크 방화벽 또는 프록시 설정으로 인해 Groobee 서버와의 통신이 차단될 수 있습니다.
- 사내망에서 접속하는 경우, 네트워크 방화벽이나 프록시 설정으로 인해 Groobee 서버로의 통신이 차단될 수 있습니다.
- 사내 네트워크 관리자에게 문의하여 Groobee 서버로의 통신이 허용되어 있는지 확인하세요.
- Groobee 도메인은 `*.groobee.io` 입니다.


### 사이트에 Content Security Policy(CSP)가 적용된 경우 Groobee 스크립트 로드가 차단될 수 있습니다.
- CSP 정책이 적용된 사이트의 경우 **외부 리소스 로드가 차단**되어  
  Groobee 스크립트, 스타일(CSS), API 통신이 정상 동작하지 않을 수 있습니다.
- 브라우저 콘솔에서 **Content Security Policy directive violation** 오류가 발생하면 CSP 차단일 가능성이 높습니다.
- CSP 정책이 있을 경우 Groobee 도메인을 CSP 허용 목록에 추가해야 합니다.
  - 도메인 : *.groobee.io ( static.groobee.io, gau.groobee.io, gse.groobee.io, gre.groobee.io )
  - 정책 : script-src, style-src, connect-src, img-src
 

---

<a id="only-lo-action-collected"></a>
## Q. 기타 행동만 수집됩니다.
### URL이 설정되었는지 확인합니다.
- 관리자 어드민에서 각 행동 코드(MA, VG, VC, OR 등)에 대한 URL이 등록되어 있는지 확인합니다.
- URL이 등록되지 않은 경우 Groobee는 해당 행동을 기본적으로 기타 행동(LO) 으로 분류하여 수집합니다.

> 페이지 URL 설정 방법은  
> 👉 [웹 페이지 URL 등록 가이드](../prerequisites/web-page-url-registration.md) 를 참고해주세요.


### SPA 사이트인 경우, 직접 행동 이력 수집 함수를 호출해야 합니다.
- SPA 사이트의 경우, 페이지 이동 시 URL이 변경되지 않기 때문에, 각 행동에 대한 URL 등록과 함께, 페이지 이동 시점에 직접 행동 이력 수집 함수를 호출해야 합니다.
- 행동 이력 수집 함수가 호출되지 않은 경우, 페이지 방문 행동이 기타 행동(LO)으로 수집될 수 있습니다.

> 행동 이력 수집 함수 호출 방법은  
> 👉 [행동 이력 수집 가이드](../installation/installation-web-action.md) 문서를 참고해주세요.


---

<a id="local-environment-not-working"></a>
## Q. 로컬/개발 환경에서 Groobee가 정상 동작하지 않습니다.
### 로컬/개발 환경에서는 도메인 대신 로컬에서 접속하는 사이트 주소를 등록해야 합니다.
- 관리자 어드민에서 로컬/개발 환경에서 접속하는 사이트 주소(예: localhost, localhost:8080)를 추가로 등록해야 합니다.

> 도메인 등록 방법은  
> 👉 [도메인 등록 가이드](../prerequisites/web-domain-registration.md) 문서를 참고해주세요.


---


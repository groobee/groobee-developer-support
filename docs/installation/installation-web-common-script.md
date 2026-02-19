# Groobee 스크립트 설치 가이드 - 공통 스크립트 설치

이 문서는 웹 환경에서 Groobee 스크립트를 **실제 서비스에 맞게 설치**하기 위한 가이드 중 공통 스크립트 설치 방법을 기술한 문서입니다.

## 공통 스크립트을 해야 하는 이유
- Groobee 서비스를 사용하기 위해 웹 페이지에 삽입하는 기본 스크립트입니다.
- 공통 스크립트가 삽입되어 있어야 회원 정보 연동, 행동 이력 수집, AI 추천 기능이 정상적으로 동작합니다.

---

## 사전 요구 사항

공통 스크립트를 설치하기 전에 아래 사항을 확인해주세요.

- Groobee 어드민 사이트에 **서비스 도메인이 등록**되어 있는지
- 스크립트를 삽입할 수 있는 **레이아웃 / 디자인 수정 권한**
- PC / 모바일 환경 분리 여부
- SPA 환경 여부, 쇼핑몰 솔루션 사용 여부

> 도메인 등록이 되어 있지 않은 경우  
> 스크립트가 정상 삽입되어 있어도 데이터가 수집되지 않습니다.  
> 👉 [웹 도메인 등록 가이드](../prerequisites/web-domain-registration.md)

---

## 공통 스크립트 설치 원칙

- Groobee 스크립트는 **모든 페이지에 공통으로 적용되는 레이아웃**에 삽입해야 합니다.
- `<head>` 종료 태그(`</head>`) 직전에 삽입합니다.
- 공통 레이아웃이 적용되지 않는 페이지가 있다면 해당 페이지에도 추가 삽입이 필요합니다.
- PC / 모바일 환경 모두 동일한 방식으로 적용합니다.

---

## 목차
- [커스텀 웹 사이트 (Custom)](#custom)
- [SPA 환경 (React, Vue 등)](#spa)
- [Cafe24](#cafe24)
- [고도몰](#godo)
- [고도몰 (e나무)](#godoenamu)
- [메이크샵](#makeshop)
- [위사 (스마트윙)](#wisawing)
---

<a id="custom"></a>
## 커스텀 웹 사이트 (Custom)

일반적인 커스텀 웹 사이트의 경우 아래 스크립트를 적용합니다.
커스텀 웹 사이트로 설정하면 브라우저의 주소가 바뀌어 페이지가 로드됐을 때 기본 행동이력 수집 로직이 작동됩니다.

### 1. 기본 스크립트 삽입
```html
<!-- Groobee Script -->
<script type="text/javascript">
(function(a,i,u,e,o) {
  a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
})(window, document, "groobee");

groobee("serviceKey", "발급받은_서비스키");
groobee("siteType", "custom");
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->
```

---

<a id="spa"></a>
## SPA 환경 (React, Vue 등)
SPA 환경에서는 페이지 전환 시점을 직접 제어해야 할 수 있습니다.

### 1. 기본 스크립트 삽입
SPA도 기본 스크립트 설치는 [커스텀 웹 사이트](#커스텀-웹-사이트-custom)와 동일하게 적용합니다.  
단, 페이지 전환 시점을 직접 제어하는 경우에는 groobee("isSPA", "true") 옵션을 추가로 설정합니다.  
isSPA 옵션을 설정하면 Groobee 스크립트가 자동 실행되지 않으며, 페이지 전환 시점에 직접 실행 함수를 호출해 행동 이력을 서버로 전송 할 수 있습니다.

```html
<!-- Groobee Script -->
<script type="text/javascript">
    (function(a,i,u,e,o) {
        a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
    })(window, document, "groobee");

    groobee("serviceKey", "발급받은_서비스키");
    groobee("siteType", "custom");
    
    // 페이지 전환 시점을 직접 제어하는 경우에는 isSPA 옵션을 설정해 자동으로 행동이력이 수집되지 않도록 변경합니다.
    groobee("isSPA", "true");
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->
```

### 2. 행동 이력 수집 함수 호출
```javascript
// 스크립트가 로딩됐거나, 다시 로딩 되는 경우에는 groobee.start() 함수를 호출해줘야 합니다.
groobee.start();

// 메인화면(MA), 기타화면(LO)가 아닌 경우에는 아래 함수를 사용해 적절한 행동 이력을 전달해줘야 합니다.
groobee.action("행동코드", {/*행동에 맞는 데이터*/});
```

---

<a id="cafe24"></a>
## Cafe24

### 1. Cafe24 (PC)
**쇼핑몰 설정 > 기본 설정 > 고급설정 > 검색엔진 최적화(SEO) > 코드 직접입력 > PC 쇼핑몰 > Head 영역**에 아래 스크립트를 삽입합니다.  

[스크립트 설치 위치 스크린샷 보기](../images/installation/cafe24/cafe24-head-pos-pc.png)

```html
<!-- Groobee Script -->
<script type="text/javascript">
(function(a,i,u,e,o) {
a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
})(window, document, "groobee");
groobee("serviceKey", "발급 받은 서비스키");
groobee("siteType", "cafe24"); // PC : cafe24, 모바일 : cafe24_m
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->
```
    
### 2. Cafe24 (모바일)
**쇼핑몰 설정 > 기본 설정 > 고급설정 > 검색엔진 최적화(SEO) > 코드 직접입력 > 모바일 쇼핑몰 > Head 영역**에 아래 스크립트를 삽입합니다.

[스크립트 설치 위치 스크린샷 보기](../images/installation/cafe24/cafe24-head-pos-mo.png)

```html
<!-- Groobee Script -->
<script type="text/javascript">
(function(a,i,u,e,o) {
a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
})(window, document, "groobee");
groobee("serviceKey", "발급 받은 서비스키");
groobee("siteType", "cafe24_m"); // PC : cafe24, 모바일 : cafe24_m
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->
```

---

<a id="godo"></a>
## 고도몰

### 1. 고도몰 (PC)

고도몰 쇼핑몰 관리자 페이지에 로그인 한 후, ***디자인 > 전체 레이아웃 > 상단 레이아웃** 페이지 <head> 영역 종료 태그 직전에 아래 스크립트를 삽입 후 저장합니다.

[스크립트 설치 위치 스크린샷 보기](../images/installation/godo5/godo5-head-pos-pc.png)

```html
<!-- Groobee Script -->
<script type="text/javascript">
(function(a,i,u,e,o) {
a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
})(window, document, "groobee");
groobee("serviceKey", "발급 받은 서비스키");
groobee("siteType", "godo5");
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->
```

### 2. 고도몰 (모바일)

고도몰 쇼핑몰 관리자 페이지에 로그인 한 후, ***디자인 > 전체 레이아웃 > 상단 레이아웃** 페이지 <head> 영역 종료 태그 직전에 아래 스크립트를 삽입 후 저장합니다.

[스크립트 설치 위치 스크린샷 보기](../images/installation/godo5/godo5-head-pos-mo.png)

```html
<!-- Groobee Script -->
<script type="text/javascript">
    (function(a,i,u,e,o) {
        a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
    })(window, document, "groobee");
    groobee("serviceKey", "발급 받은 서비스키");
    groobee("siteType", "godo5_m");
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->
```

---

<a id="godoenamu"></a>
## 고도몰 (e나무)

### 1. 고도몰 (PC)

고도몰 쇼핑몰 관리자 페이지에 로그인 한 후, **디자인 > 전체 레이아웃 디자인 > 상단 레이아웃** 페이지 <head> 영역 종료 태그 직전에 아래 스크립트를 삽입 후 저장합니다.

1. [디자인 메뉴 위치 스크린샷 보기](../images/installation/godo/godo-design-menu-pos-pc.png)
2. [스크립트 설치 위치 스크린샷 보기](../images/installation/godo/godo-head-pos.png)

```html
<!-- Groobee Script -->
<script type="text/javascript">
(function(a,i,u,e,o) {
a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
})(window, document, "groobee");
groobee("serviceKey", "발급 받은 서비스키");
groobee("siteType", "godomall");
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->
```

### 2. 고도몰 (e나무) (모바일)
고도몰 쇼핑몰 관리자 페이지에 로그인 한 후, **모바일샵 > 모바일샵 디자인관리 > 상단 레이아웃** 페이지 <head> 영역 종료 태그 직전에 아래 스크립트를 삽입 후 저장합니다.

1. [모바일샵 디자인 관리 메뉴 위치 스크린샷 보기](../images/installation/godo/godo-design-menu-pos-mo.png)
2. [스크립트 설치 위치 스크린샷 보기](../images/installation/godo/godo-head-pos.png)

```html
<!-- Groobee Script -->
<script type="text/javascript">
(function(a,i,u,e,o) {
a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
})(window, document, "groobee");
groobee("serviceKey", "발급 받은 서비스키");
groobee("siteType", "godomall_m");
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->
```

---

<a id="makeshop"></a>
## 메이크샵

### 1. 메이크샵 (PC)
1. 메이크샵 쇼핑몰 관리자 페이지에 로그인 한 후, **디자인 > 디자인 스킨 관리 > PC > 디자인 편집** 메뉴에 진입합니다.   
[디자인 스킨 관리 메뉴 위치 스크린샷 보기](../images/installation/makeshop/makeshop-design-menu-pos-pc.png)

2. **디자인 환경 설정 > HEAD 입력** 항목에 아래 스크립트를 삽입 후 저장합니다.  
[스크립트 설치 위치 스크린샷 보기](../images/installation/makeshop/makeshop-head-pos.png)

```html
<!-- Groobee Script -->
<script type="text/javascript">
(function(a,i,u,e,o) {
a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
})(window, document, "groobee");
groobee("serviceKey", "발급 받은 서비스키");
groobee("siteType", "makeshop");
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->
```

### 2. 메이크샵 (모바일)
1. 메이크샵 쇼핑몰 관리자 페이지에 로그인 한 후, **디자인 > 디자인 스킨 관리 > 모바일 > 디자인 편집** 메뉴에 진입합니다.  
[디자인 스킨 관리 메뉴 위치 스크린샷 보기](../images/installation/makeshop/makeshop-design-menu-pos-mo.png)

2. **디자인 환경 설정 > HEAD 입력** 항목에 아래 스크립트를 삽입 후 저장합니다.  
[스크립트 설치 위치 스크린샷 보기](../images/installation/makeshop/makeshop-head-pos.png)


```html
<!-- Groobee Script -->
<script type="text/javascript">
(function(a,i,u,e,o) {
a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
})(window, document, "groobee");
groobee("serviceKey", "발급 받은 서비스키");
groobee("siteType", "makeshop_m");
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->
```

### 3. 메이크샵 (반응형)
1. 메이크샵 쇼핑몰 관리자 페이지에 로그인 한 후, **디자인 > 디자인 스킨 관리 > 모바일 > 디자인 편집** 메뉴에 진입합니다.  
[디자인 스킨 관리 메뉴 위치 스크린샷 보기](../images/installation/makeshop/makeshop-design-menu-pos-rsp.png)

2. **디자인 환경 설정 > HEAD 입력** 항목에 아래 스크립트를 삽입 후 저장합니다.  
[스크립트 설치 위치 스크린샷 보기](../images/installation/makeshop/makeshop-head-pos.png)


```html
<!-- Groobee Script -->
<script type="text/javascript">
(function(a,i,u,e,o) {
a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
})(window, document, "groobee");
groobee("serviceKey", "발급 받은 서비스키");
groobee("siteType", "makeshop");
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->
```


---

<a id="wisawing"></a>
## 위사 (스마트윙)
위사 쇼핑몰 관리자 페이지에 로그인 한 후, **디자인 > 디자인관리 > 스크립트 매니저**에 접속하여 Groobee 적용을 위한 스크립트를 생성합니다.

[스크립트 매니저 메뉴 위치 스크린샷 보기](../images/installation/wisa/wisa-script-mgr-pos.png)  
[스크립트 기본정보 입력](../images/installation/wisa/wisa-script-base.png)

### 1. 위사 (PC)
**공통헤더 > PC > 공통헤더** 항목에 아래 스크립트를 삽입 후 저장합니다.  
[스크립트 설치 위치 스크린샷 보기](../images/installation/wisa/wisa-header-pos-pc.png)
```html
<!-- Groobee Script -->
<script type="text/javascript">
    (function(a,i,u,e,o) {
        a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
    })(window, document, "groobee");
    groobee("serviceKey", "발급 받은 서비스키");
    groobee("siteType", "wisa");
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->

```
 

### 2. 위사 (MO)
**공통헤더 > Mobile > 공통헤더** 항목에 아래 스크립트를 삽입 후 저장합니다.  
[스크립트 설치 위치 스크린샷 보기](../images/installation/wisa/wisa-header-pos-mo.png)
```html
<!-- Groobee Script -->
<script type="text/javascript">
(function(a,i,u,e,o) {
a[u]=a[u]||function(){(a[u].q=a[u].q||[]).push(arguments)};
})(window, document, "groobee");
groobee("serviceKey", "발급 받은 서비스키");
groobee("siteType", "wisa_m"); // PC : wisa, 모바일 : wisa_m
</script>
<script charset="utf-8" src="//static.groobee.io/dist/g2/groobee.init.min.js"></script>
<!-- End of Groobee Script -->
```

---

### Groobee 스크립트 실행 방지법
공통 스크립트가 설치된 페이지더라도, 특정 페이지에서 Groobee 스크립트가 실행되지 않도록 막고 싶다면,  
아래와 같이 groobee("grbDisabled", true);를 넣어주세요.

```html
<!-- Disable Groobee Script -->
<script type="text/javascript">
    groobee("grbDisabled", true);
</script>
<!-- End of Disable Groobee Script -->
```

---

## 다음 단계
[회원 정보 연동](installation-web-member-data.md)로 이동하여 회원 정보 연동 설정을 해주세요. 


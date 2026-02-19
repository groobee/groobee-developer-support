# Groobee 스크립트 설치 가이드 - 회원 정보 연동

이 문서는 웹 환경에서 Groobee 스크립트를 **실제 서비스에 맞게 설치**하기 위한 가이드 중 회원 정보 연동 방법을 기술한 문서입니다.

## 회원 정보 연동
- Groobee로 회원 정보에 맞춰 맞춤형 서비스를 제공하기 위해서는 회원 정보 연동이 필요합니다.
- Groobee에서 기본적으로 지원하는 회원정보 유형은 회원 등급, 성별, 연령대, 유형이 있습니다.

> Groobee에서 지원하는 회원정보 유형 외에 추가로 수집하고자 하는 정보가 있는 경우에는 커스텀 데이터 기능을 활용하시면 됩니다.   
> 커스텀 데이터에 대한 자세한 내용은 Groobee 관리자 사이트 내 도움말에 있는 커스텀 데이터 항목을 참조해주세요.

---

## 사전 요구 사항

- **(필수)** 공통 스크립트가 설치되어 있어야 합니다.
> 공통 스크립트 설치가 안 되어 있는 경우  
> 이 가이드에 따라 회원 정보 연동 설정을 하여도 정상적으로 동작하지 않을 수 있습니다.  
> 👉 [공통 스크립트 설치 가이드](../installation/installation-web-common-script.md)
- **(필수)** 회원정보를 활용하려면 관리자 사이트에서 회원 정보를 먼저 설정해줘야 합니다.
> 관리자 사이트에서 회원 정보를 설정하지 않은 경우, 스크립트로 회원 정보를 수집해도 캠페인에서 활용 할 수 없습니다.  
> 👉 [회원 정보 설정 가이드](../prerequisites/member-data-setting.md)
- 임대형 쇼핑몰(카페24, 고도몰, 아임웹 등)을 사용하고 계신 경우 해당 쇼핑몰에서 지원하지 않는 회원 정보 유형은 사용 하실 수 없습니다.

---

## 목차
- [커스텀 웹 사이트](#custom)
- [Cafe24](#cafe24)
- [고도몰](#godo)
- [고도몰 (e나무)](#godoenamu)
- [메이크샵](#makeshop)
- [위사 (스마트윙)](#wisawing)

---

<a id="custom"></a>
## 커스텀 웹 사이트
직접 구축한 사이트를 운영 중이거나 임대형 쇼핑몰 중 가이드에 없는 쇼핑몰을 운영하시는 경우에는 아래의 방법을 참고하여 회원 정보를 연동해 주세요.
- 모든 페이지에 공통으로 적용되는 공통 레이아웃에 아래의 메타태그를 삽입하고  
로그인 되어있는 회원의 회원 아이디, 등급, 성별, 유형, 연령대를 content에 할당해 주세요.
이 때 content에 들어가는 값은 관리자 사이트에서 설정한 값이어야합니다.
> 로그인 하지 않은 경우 회원 아이디를 포함한 다른 값들은 모두 비어 있어야 합니다.  
> 회원 등급, 성별, 유형, 연령대는 생략 가능 하지만 캠페인 등록 시 해당 조건을 사용할 수 없습니다.  

```html
<meta property="groobee:member_id" content="회원 아이디"/>
<meta property="groobee:member_grade" content="회원 등급"/>
<meta property="groobee:member_gender" content="회원 성별"/>
<meta property="groobee:member_type" content="회원 유형"/>
<meta property="groobee:member_age" content="회원 연령대"/>
```

---

<a id="cafe24"></a>
## Cafe24

### 1. Cafe24 (PC)
1. **디자인 (PC/모바일) > 디자인 대시보드 > PC 대표 디자인 > 디자인 편집**에 들어가 스마트디자인 편집창을 엽니다.  
[스마트디자인 편집창 위치 스크린샷 보기](../images/installation/cafe24/cafe24-design-editor-pos-pc.png)

2. **전체화면보기 > 레이아웃 > 기본 레이아웃 > 공통 레이아웃** 파일을 열고, **&lt;div module="Layout_stateLogon"&gt;&lt;/div&gt;** 태그 안에 아래 코드를 삽입합니다.  
[회원 정보 삽입 위치 스크린샷 보기](../images/installation/cafe24/cafe24-member-pos.png)

```html
<!-- Groobee Basic Data -->
<div id="groobee-member-id" style="display: none;">{$id}</div>
<div id="groobee-member-grade" style="display: none;">{$group_name}</div>
<!-- End of Groobee Basic Data -->
```

> 만약 &lt;div module="Layout_stateLogon"&gt;&lt;/div&gt; 태그가 존재하지 않는다면  
> &lt;div module="Layout_stateLogon" style="display: none;"&gt;&lt;/div&gt;를  
> 직접입력하거나 Layout_stateLogon이 존재하는 페이지(header.html 등)를 찾아 내부 영역에 삽입g합니다.

### 2. Cafe24 (모바일)
1. **디자인 (PC/모바일) > 디자인 대시보드 > 모바일 대표 디자인 > 디자인 편집**에 들어가 스마트디자인 편집창을 엽니다.  
[스마트디자인 편집창 위치 스크린샷 보기](../images/installation/cafe24/cafe24-design-editor-pos-mo.png)

2. **전체화면보기 > 레이아웃 > 기본 레이아웃 > 공통 레이아웃** 파일을 열고, **&lt;div module="Layout_stateLogon"&gt;&lt;/div&gt;** 태그 안에 아래 코드를 삽입합니다.  
[회원 정보 삽입 위치 스크린샷 보기](../images/installation/cafe24/cafe24-member-pos.png)

```html
<!-- Groobee Basic Data -->
<div id="groobee-member-id" style="display: none;">{$id}</div>
<div id="groobee-member-grade" style="display: none;">{$group_name}</div>
<!-- End of Groobee Basic Data -->
```

> 만약 &lt;div module="Layout_stateLogon"&gt;&lt;/div&gt; 태그가 존재하지 않는다면  
> &lt;div module="Layout_stateLogon" style="display: none;"&gt;&lt;/div&gt;를  
> 직접입력하거나 Layout_stateLogon이 존재하는 페이지(header.html 등)를 찾아 내부 영역에 삽입g합니다

> 만약 페이지가 공통 레이아웃을 포함하지 않는 페이지라면,  
> 해당 페이지 상단에 회원 정보 스크립트를 직접 삽입해 주세요.  
> (예: 주문서 작성, 주문완료 페이지 등에서 공통 레이아웃을 사용하지 않는경우 해당 페이지 상단에 직접 아래 스크립트를 추가합니다.)
> ```html
> <!-- Groobee Basic Data -->
> <div module="Layout_statelogon" style="display:none;">
> <div id="groobee-member-id" style="display: none;">{$id}</div>
> <div id="groobee-member-grade" style="display: none;">{$group_name}</div>
> </div>
> <!-- End of Groobee Basic Data -->
> ```

---

<a id="godo"></a>
## 고도몰

### 1. 고도몰 (PC)

고도몰 쇼핑몰 관리자 페이지에 로그인 한 후, ***디자인 > 전체 레이아웃 > 상단 레이아웃** 페이지에 작성한 [Groobee 공통 스크립트](../installation/installation-web-common-script.md) 하단에 아래 스크립트를 삽입합니다.

[스크립트 설치 위치 스크린샷 보기](../images/installation/godo5/godo5-head-pos-pc.png)

```html
<!-- Groobee Basic Data -->
<meta property="groobee:member_id" content="{=gSess.memId}"/>
<meta property="groobee:member_grade" content="{=gSess.groupNm}"/>
<!-- End of Groobee Basic Data -->
```

아래는 공통스크립트와 회원정보 스크립트가 둘 다 설치된 코드의 예시입니다.
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

<!-- Groobee Basic Data -->
<meta property="groobee:member_id" content="{=gSess.memId}"/>
<meta property="groobee:member_grade" content="{=gSess.groupNm}"/>
<!-- End of Groobee Basic Data -->
```

### 2. 고도몰 (모바일)

고도몰 쇼핑몰 관리자 페이지에 로그인 한 후, ***디자인 > 전체 레이아웃 > 상단 레이아웃**

[스크립트 설치 위치 스크린샷 보기](../images/installation/godo5/godo5-head-pos-mo.png)

```html
<!-- Groobee Basic Data -->
<meta property="groobee:member_id" content="{=gSess.memId}"/>
<meta property="groobee:member_grade" content="{=gSess.groupNm}"/>
<!-- End of Groobee Basic Data -->
```

아래는 공통스크립트와 회원정보 스크립트가 둘 다 설치된 코드의 예시입니다.
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

<!-- Groobee Basic Data -->
<meta property="groobee:member_id" content="{=gSess.memId}"/>
<meta property="groobee:member_grade" content="{=gSess.groupNm}"/>
<!-- End of Groobee Basic Data -->
```

---

<a id="godoenamu"></a>
## 고도몰 (e나무)

### 1. 고도몰 (PC)

고도몰 쇼핑몰 관리자 페이지에 로그인 한 후, **디자인 > 전체 레이아웃 디자인 > 상단 레이아웃** 페이지에 작성한 [Groobee 공통 스크립트](../installation/installation-web-common-script.md) 하단에 아래 스크립트를 삽입합니다.

1. [디자인 메뉴 위치 스크린샷 보기](../images/installation/godo/godo-design-menu-pos-pc.png)
2. [스크립트 설치 위치 스크린샷 보기](../images/installation/godo/godo-head-pos.png)

```html
<meta property="groobee:member_id" content="{_sess.m_id}"/>
<meta property="groobee:member_grade" content="{_sess.level}"/>
```

### 2. 고도몰 (e나무) (모바일)
고도몰 쇼핑몰 관리자 페이지에 로그인 한 후, **모바일샵 > 모바일샵 디자인관리 > 상단 레이아웃**  페이지에 작성한 [Groobee 공통 스크립트](../installation/installation-web-common-script.md) 하단에 아래 스크립트를 삽입합니다.

1. [모바일샵 디자인 관리 메뉴 위치 스크린샷 보기](../images/installation/godo/godo-design-menu-pos-mo.png)
2. [스크립트 설치 위치 스크린샷 보기](../images/installation/godo/godo-head-pos.png)

```html
<meta property="groobee:member_id" content="{_sess.m_id}"/>
<meta property="groobee:member_grade" content="{_sess.level}"/>
```

---

<a id="makeshop"></a>
## 메이크샵

### 1. 메이크샵 (PC)
1. 메이크샵 쇼핑몰 관리자 페이지에 로그인 한 후, **디자인 > 디자인 스킨 관리 > PC > 디자인 편집** 메뉴에 진입합니다.   
   [디자인 스킨 관리 메뉴 위치 스크린샷 보기](../images/installation/makeshop/makeshop-design-menu-pos-pc.png)

2. **상단 > 기본 상단** 편집 화면에서 아래 스크립트를 삽입 후 저장합니다.  
[스크립트 설치 위치 스크린샷 보기](../images/installation/makeshop/makeshop-mmember-pos.png) 
   
```html
<!-- Groobee Basic Data -->
<meta property="groobee:member_id" content="<!--/user_id/-->"/>
<meta property="groobee:member_grade" content="<!--/group_name/-->"/>
<!--End of Groobee Basic Data -->
```

### 2. 메이크샵 (모바일)
1. 메이크샵 쇼핑몰 관리자 페이지에 로그인 한 후, **디자인 > 디자인 스킨 관리 > 모바일 > 디자인 편집** 메뉴에 진입합니다.  
   [디자인 스킨 관리 메뉴 위치 스크린샷 보기](../images/installation/makeshop/makeshop-design-menu-pos-mo.png)


2. **상단 > 기본 상단** 편집 화면에서 아래 스크립트를 삽입 후 저장합니다.  
   [스크립트 설치 위치 스크린샷 보기](../images/installation/makeshop/makeshop-mmember-pos.png)

```html
<!-- Groobee Basic Data -->
<meta property="groobee:member_id" content="<!--/user_id/-->"/>
<meta property="groobee:member_grade" content="<!--/group_name/-->"/>
<!--End of Groobee Basic Data -->
```

---

<a id="wisawing"></a>
## 위사 (스마트윙)

**디자인 > HTML 편집 > 상단공통페이지 편집** 메뉴에 들어가 아래 스크립트를 삽입합니다.  
[스크립트 설치 위치 스크린샷 보기](../images/installation/wisa/wisa-member-pos.png)

```html
<!-- Groobee Basic Data -->
<meta property="groobee:member_id" content="{{$회원아이디}}">
<meta property="groobee:member_grade" content="{{$회원등급}}">
<!-- End of Groobee Basic Data -->
```

---

## 다음 단계
[행동 이력 수집](installation-web-action.md) 가이드로 이동하여 행동 이력 수집 설정을 진행해 주세요.
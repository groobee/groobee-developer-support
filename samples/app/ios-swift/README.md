# Groobee iOS SDK 샘플 (Swift)

CocoaPods 로 배포되는 **Groobee iOS SDK(`GroobeeKit`)** 를 사용하는 최소 동작 샘플입니다.
회원/로그인, 푸시, 행동 이력, AI 추천까지 SDK 의 주요 기능을 버튼 하나씩으로 호출해 볼 수 있습니다.

---

## 사용하는 SDK

| 항목 | 값 |
| --- | --- |
| 패키지 | `pod 'GroobeeKit', '~> 1.1.6'` (현재 Stable 1.1.6) |
| 배포 | CocoaPods (`GroobeeKit.xcframework` 벤더링) |
| 푸시 | Firebase Cloud Messaging (`FirebaseCore`, `FirebaseMessaging`) |
| 최소 버전 | iOS 13.0 |

---

## 사전 준비 도구

- Xcode 15 이상 + CocoaPods (`sudo gem install cocoapods`)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
  - `.xcodeproj` 는 Git 에 커밋하지 않고 [`project.yml`](project.yml) 로부터 생성합니다.

---

## 프로젝트 구조

```
ios-swift/
├── project.yml                 # XcodeGen 프로젝트 정의 (타깃/서명/Info.plist 키)
├── Podfile                     # ★ pod 'GroobeeKit'
├── setup.sh                    # xcodegen generate + pod install 한 번에 실행
└── GroobeeSample/
    ├── AppDelegate.swift        # ★ SDK 초기화 + 푸시(FCM/APNS) 처리
    ├── SceneDelegate.swift      # ★ GroobeeKitLifeCycle 연결 (iOS 13+)
    ├── ViewController.swift     # ★ 전체 기능 데모 화면
    ├── SampleConfig.swift       # 서비스키 / 캠페인키 / screenId
    ├── DemoData.swift           # 샘플 Goods 데이터
    ├── AppLog.swift             # 화면 로그 + GroobeeLogCallback (데모 전용)
    └── Base.lproj/LaunchScreen.storyboard
```

`★` 표시가 실제 연동 시 참고할 핵심 파일입니다.

---

## 시작하기

### 1. 설정 파일 작성 (`Secrets.plist`)

서비스키·캠페인키는 소스 코드가 아니라 **`GroobeeSample/Secrets.plist`** 에 넣습니다.
(이 파일은 `.gitignore` 대상이라 커밋되지 않고, 없으면 placeholder 로 동작합니다.)

```bash
cp GroobeeSample/Secrets.example.plist GroobeeSample/Secrets.plist
```

복사한 `Secrets.plist` 를 열어 값을 채우세요.

| 키 | 설명 |
| --- | --- |
| `GROOBEE_SERVICE_KEY` | 어드민에서 발급받은 서비스키 |
| `GROOBEE_RECOMMEND_CAMPAIGN_KEY` | AI 추천 캠페인키 (어드민 > 추천 캠페인) |

> **앱 번들 ID(Bundle ID)** 는 [`project.yml`](project.yml) 의 `PRODUCT_BUNDLE_IDENTIFIER` 에서 변경합니다.
> 변경 시 Firebase 의 iOS 앱 Bundle ID 및 `GoogleService-Info.plist` 도 일치시키세요.
> ([`SampleConfig.swift`](GroobeeSample/SampleConfig.swift) 가 런타임에 Secrets.plist 를 읽습니다.)

### 2. 프로젝트 생성

```bash
cd samples/app/ios-swift
sh setup.sh          # Secrets.plist 생성(없으면) + xcodegen generate + pod install
open GroobeeSample.xcworkspace
```

> `setup.sh` 가 `.xcodeproj` 와 `.xcworkspace` 를 생성합니다. 반드시 `.xcworkspace` 를 여세요.

### 3. (푸시 사용 시) Firebase 설정

1. Firebase 콘솔에서 iOS 앱(Bundle ID `io.groobee.sample`)을 등록하고
   `GoogleService-Info.plist` 를 받아 `GroobeeSample/` 폴더에 추가합니다.
   (XcodeGen 의 `sources` 에 폴더가 포함되어 자동으로 타깃에 들어갑니다. 추가 후 `sh setup.sh` 재실행)
2. Xcode > 타깃 > Signing & Capabilities 에서 **Push Notifications** 와
   **Background Modes(Remote notifications)** 가 켜져 있는지 확인합니다.
   (entitlements / Info.plist 에 기본 설정돼 있습니다)
3. APNS 인증 키(.p8)를 Firebase 콘솔에 업로드하고, 어드민에 Firebase 비공개키를 등록합니다.
   👉 [어드민 푸시 설정 가이드](https://docs.groobee.ai/new-admin/settings/push)

> `GoogleService-Info.plist` 가 없으면 푸시 관련 초기화는 자동으로 건너뛰고,
> 나머지 기능(회원/행동/추천)은 정상 동작합니다.

### 4. 실행

`io.groobee.sample` 의 Bundle ID / 서명 팀(`DEVELOPMENT_TEAM`)을 본인 환경에 맞게 설정한 뒤 실행하세요.

---

## 문제 해결

- **`pod install` 시 `None of your spec sources contain a spec satisfying the dependency: GroobeeKit`**
  → 로컬 CocoaPods 스펙 인덱스가 오래된 경우입니다. `pod install --repo-update` 로 인덱스를 갱신하세요.
- **`pod install` 시 `Unicode Normalization ... ASCII-8BIT` 오류**
  → 터미널 로케일이 UTF-8 이 아니어서 발생합니다. 아래를 실행한 뒤 다시 시도하세요.
    ```bash
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    ```

---

## 데모 화면에서 확인할 수 있는 SDK 호출

| 섹션 | 버튼 | 호출 메소드 |
| --- | --- | --- |
| ① 회원/로그인 | 로그인 | `setServiceLogin(memberId:)` |
| | 회원정보 설정 | `setUserInfo(id:grade:age:gender:type:)` |
| | 회원가입 완료 | `setMemberJoin(memberId:screenId:)` |
| | 동의상태 동기화 | `syncMemberAgreed(memberId:)` |
| | 로그아웃 | `serviceLogout()` + `memberDataClear()` |
| ② 푸시 | FCM 토큰 조회/전송 | `setPushToken(pushToken:)` |
| | 전체/광고/야간 동의 | `setPushAgreeAP` / `setPushAgreeAA` / `setPushAgreeAN` |
| | 동의 상태 조회 | `getPushAgreed(memberId:responseAgreeds:)` |
| ③ 행동 이력 | 검색 | `setSearchKeyword(searchKwd:screenId:)` |
| | 상품 상세 | `setViewGoods(goods:screenId:)` |
| | 카테고리 | `setCategory(cateCd:cateNm:screenId:)` |
| | 장바구니 | `setShoppingCart(goods:screenId:)` |
| | 주문서 / 주문완료 | `setGoodsOrder(...)` / `setGoodsOrderComplete(orderNo:goods:screenId:)` |
| | 커스텀 이벤트 | `setCustomEvent(eventKey:screenId:eventValue:)` |
| ④ AI 추천 | 추천 상품 요청 | `getRecommendGoods(campaignKey:responseGoods:)` → `setShowRecommendGoods` / `setClickRecommendGoods` |

호출 결과는 화면 하단 로그 영역에 표시됩니다.

> 서비스키가 placeholder 이거나 네트워크가 없으면 서버 전송은 실패할 수 있지만,
> **호출 코드와 흐름**은 그대로 확인할 수 있습니다. 실제 데이터 적재는 유효한 서비스키가 필요합니다.

---

## WKWebView(하이브리드) 사용 시 주의

InAppMessage 와 WebView 를 함께 쓸 때 `WKWebView` 를 컨트롤러의 root view 로 직접 지정하면
(`loadView` 에서 `view = webView`) 인앱메시지와 WebView 가 모두 검은 화면이 되는 알려진 이슈가 있습니다.
WebView 는 반드시 root view 의 **subview** 로 추가하세요.
자세한 내용: [iOS SDK 주의사항 및 로그](../../../docs/detail/ios-sdk-cautions-log.md)

---

## 관련 문서

- [iOS SDK 설치 가이드](../../../docs/installation/installation-ios-sdk.md)
- [회원 정보 및 푸시](../../../docs/detail/ios-sdk-member-push.md) ·
  [행동 이력](../../../docs/detail/ios-sdk-actions.md) ·
  [추천 상품](../../../docs/detail/ios-sdk-recommend.md)
- [iOS SDK 변경 로그](../../../docs/changelog/sdk-ios-changelog.md)

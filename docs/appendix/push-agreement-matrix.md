# 부록: 푸시 수신 동의 값 매트릭스

이 문서는 Groobee SDK에 전달하는 **세 가지 푸시 수신 동의 값(AgreedAP · AgreedAA · AgreedAN)** 의 조합이 실제 푸시 발송 결과에 어떻게 반영되는지를 정리한 부록 문서입니다.

Android / iOS SDK 설정 메소드와 함께 보면서, 앱에서 어떤 값을 어떤 시점에 전달해야 할지 판단할 때 참고하세요.

---

## 목차

1. [개요](#overview)
2. [동의 값 정의](#agreement-values)
3. [SDK 설정 메소드 매핑](#sdk-method-mapping)
4. [동의 조합 × 발송 결과 매트릭스](#agreement-matrix)
5. [케이스별 설명](#case-details)
6. [운영 주의 사항](#operation-notes)
7. [함께 보면 좋은 문서](#related-docs)

---

<a id="overview"></a>
## 개요

Groobee의 푸시 발송 대상 필터링은 세 가지 `Bool` 동의 값에 의해 결정됩니다.

- `AgreedAP` — **전체 푸시 사용 동의**. 모든 푸시 발송의 기본 스위치 역할을 합니다.
- `AgreedAA` — **광고성 푸시 동의**. 광고 캠페인 발송 대상을 추리는 데 사용됩니다.
- `AgreedAN` — **야간 푸시 동의**. 21시 이후 시간대 발송 대상을 추리는 데 사용됩니다.

세 값은 **독립 플래그가 아니라 AND 조합으로 적용**됩니다. 즉, 광고 푸시를 받으려면 `AgreedAP && AgreedAA`가 모두 `true`여야 하고, 야간 광고 푸시를 받으려면 `AgreedAP && AgreedAA && AgreedAN`이 모두 `true`여야 합니다.

> 야간 시간대 기준은 **21시 이후**입니다.

---

<a id="agreement-values"></a>
## 동의 값 정의

| 값 | 의미 | 필터링되는 메시지 유형 |
| --- | --- | --- |
| `AgreedAP` | 전체 푸시 수신 동의 | 정보성 / 광고성 / 야간 — 모든 푸시의 마스터 스위치 |
| `AgreedAA` | 광고성 푸시 수신 동의 | 광고 캠페인 메시지 |
| `AgreedAN` | 야간 푸시 수신 동의 | 21시 이후 발송되는 메시지 |

- `AgreedAP`가 `false`면 나머지 두 값과 무관하게 **모든 푸시가 발송되지 않습니다.**
- `AgreedAA` / `AgreedAN`은 **각각 광고성 · 야간 발송에 대한 추가 필터**이며, `AgreedAP = true`인 사용자에 한해 의미를 가집니다.

---

<a id="sdk-method-mapping"></a>
## SDK 설정 메소드 매핑

각 동의 값을 SDK에 전달하는 메소드는 아래와 같습니다. 자세한 파라미터와 호출 시점은 링크한 상세 가이드를 참고하세요.

| 동의 값 | Android SDK | iOS SDK |
| --- | --- | --- |
| `AgreedAP` | [`setAgreedPush(isAgreed)`](../detail/android-sdk-member-push.md#push-agreement) | [`setPushAgreeAP(isPushAgreedAP)`](../detail/ios-sdk-member-push.md#push-consent) |
| `AgreedAA` | [`setAgreedPushAdvertising(isAgreed)`](../detail/android-sdk-member-push.md#push-agreement) | [`setPushAgreeAA(isPushAgreedAA)`](../detail/ios-sdk-member-push.md#push-consent) |
| `AgreedAN` | [`setAgreedPushNight(isAgreed)`](../detail/android-sdk-member-push.md#push-agreement) | [`setPushAgreeAN(isPushAgreedAN)`](../detail/ios-sdk-member-push.md#push-consent) |

현재 동의 상태를 조회하려면 [Android `getPushAgreed(memberId)`](../detail/android-sdk-member-push.md#push-agreement-lookup) 또는 [iOS `getPushAgreed(memberId)`](../detail/ios-sdk-member-push.md#push-consent-query)를 사용하며, 반환 객체의 프로퍼티 이름이 그대로 `agreedAP` / `agreedAA` / `agreedAN` 입니다.

### 호출 예시

=== "Android (Kotlin)"

    ```kotlin
    Groobee.getInstance().setAgreedPush(isAgreedAP)            // AgreedAP
    Groobee.getInstance().setAgreedPushAdvertising(isAgreedAA) // AgreedAA
    Groobee.getInstance().setAgreedPushNight(isAgreedAN)       // AgreedAN
    ```

=== "iOS (Swift)"

    ```swift
    Groobee.getInstance().setPushAgreeAP(isPushAgreedAP: isAgreedAP) // AgreedAP
    Groobee.getInstance().setPushAgreeAA(isPushAgreedAA: isAgreedAA) // AgreedAA
    Groobee.getInstance().setPushAgreeAN(isPushAgreedAN: isAgreedAN) // AgreedAN
    ```

=== "iOS (Objective-C)"

    ```objectivec
    [[Groobee getInstance] setPushAgreeAPWithIsPushAgreedAP:isAgreedAP]; // AgreedAP
    [[Groobee getInstance] setPushAgreeAAWithIsPushAgreedAA:isAgreedAA]; // AgreedAA
    [[Groobee getInstance] setPushAgreeANWithIsPushAgreedAN:isAgreedAN]; // AgreedAN
    ```

---

<a id="agreement-matrix"></a>
## 동의 조합 × 발송 결과 매트릭스

세 플래그의 모든 조합(2³ = 8가지)에 대해 어떤 푸시가 발송되는지 정리한 표입니다. `✅` 는 발송됨, `❌` 는 발송되지 않음을 의미합니다.

| AgreedAP | AgreedAA | AgreedAN | 정보성 (주간) | 광고성 (주간) | 정보성 (야간, 21시 이후) | 광고성 (야간, 21시 이후) |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| ✅ | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ |
| ✅ | ❌ | ✅ | ✅ | ❌ | ✅ | ❌ |
| ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| ❌ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

> `AgreedAP = false` 인 경우 다른 두 값과 무관하게 모든 푸시가 차단됩니다. 표의 아래쪽 네 행이 이에 해당합니다.

---

<a id="case-details"></a>
## 케이스별 설명

### 1. `AgreedAP`만 `true`

- 정보성 푸시 **발송됨** (주간)
- 광고성 푸시 · 야간 시간대 푸시는 모두 차단

### 2. `AgreedAP && AgreedAA`

- 정보성 푸시 및 광고성 푸시 모두 **발송됨** (주간)
- 야간 시간대(21시 이후) 발송분은 차단

### 3. `AgreedAP && AgreedAN`

- 주간 정보성 푸시 + 야간 정보성 푸시 **발송됨**
- 광고성 푸시는 주간 · 야간 모두 차단

### 4. `AgreedAP && AgreedAA && AgreedAN`

- 주간 정보성 / 주간 광고성 / 야간 정보성 / 야간 광고성 모두 **발송됨**

### 5. `!AgreedAP`

- **모든 푸시 발송 안 됨.** 다른 두 값이 무엇이든 영향을 주지 않습니다.

---

<a id="operation-notes"></a>
## 운영 주의 사항

- 세 메소드 모두 **사용자가 토글을 변경할 때뿐 아니라 현재 상태도 한 번 호출해 동기화**해야 합니다. 변경 시점에만 호출하면 초기값이 전달되지 않아 해당 사용자가 `false`로 집계될 수 있습니다.
- 설정 화면 진입 시 현재 상태를 한 번 동기화하고, 사용자가 토글을 변경할 때 다시 호출하는 방식을 권장합니다.

---

<a id="related-docs"></a>
## 함께 보면 좋은 문서

- [Android SDK 회원 정보 및 푸시](../detail/android-sdk-member-push.md)
- [iOS SDK 회원 정보 및 푸시](../detail/ios-sdk-member-push.md)
- [Android Flutter SDK MethodChannel 연동](../detail/android-flutter-method-channel.md)
- [iOS Flutter SDK MethodChannel 연동](../detail/ios-flutter-method-channel.md)

# Android SDK 회원 정보 및 푸시 상태 연동

이 문서는 Android Native SDK와 Flutter Android SDK 공통 기준으로 회원 정보, 푸시 토큰, 푸시 동의 상태 관련 메소드들을 정리한 문서입니다.

Flutter 앱은 Dart에서 값을 준비한 뒤 Android `MethodChannel` 브리지를 통해 같은 메소드를 호출합니다.  
Flutter 브리지 구현은 [Flutter Android SDK MethodChannel 연동](./android-flutter-method-channel.md)을 참고하세요.

## 호출 위치 권장 사항

- Groobee 메소드는 가능하면 `onCreate()` 또는 `onActivityCreated()`처럼 한 번만 호출되는 지점에서 사용하세요.
- `onResume()`처럼 반복 호출되는 지점에서 사용하면 인앱메시지 동작과 충돌할 수 있습니다.

## 회원 상태 연동

| 메소드 | 설명 | 권장 호출 시점 | 주의 사항 |
| --- | --- | --- | --- |
| `setServiceLogin(userId)` | 회원 ID를 Groobee에 전달합니다. | 로그인 직후, 앱 시작 시 로그인 상태 복원 시점 | 로그인 시점에만 호출하면 이미 로그인되어 있던 사용자가 비회원 데이터로 집계될 수 있습니다. 회원/비회원에 대한 정확한 데이터를 수집하려면 호출 로직을 꼼꼼히 검토하세요. |
| `setServiceLogout()` | 현재 기기에 저장된 회원 ID를 제거합니다. | 로그아웃 직후, 세션 만료 직후 | 호출하지 않으면 비로그인 상태인데도 Groobee에서 로그인 사용자로 남을 수 있습니다. |

운영 주의 사항:

- Groobee SDK는 회원 ID를 앱 재실행 후에도 유지합니다.
- 앱 토큰/세션이 만료될 때도 현재 상태에 맞게 `setServiceLogout()`를 호출해야 합니다.
- 푸시 관련 이력 역시 회원 ID와 함께 수집되므로, 푸시로 앱이 열릴 때도 로그인 상태 정합성을 맞춰야 합니다.

## 회원 속성 연동

### `setMember(memberId, grade, gender, age, type)`

회원 속성 값을 개별 파라미터로 전달합니다.

| 파라미터 | 자료형 | 설명 | 예시 |
| --- | --- | --- | --- |
| `memberId` | `String` | 회원 아이디 | `test123@test.com` |
| `grade` | `String` | 회원 등급 | `VIP` |
| `gender` | `String` | 성별 | `M` |
| `age` | `String` | 연령대 | `20-30` |
| `type` | `String` | 회원 유형 | `admin` |

- 모든 값은 필수입니다.
- 세그먼트 생성 시 방문자 유형 조건으로 사용됩니다.

### `setMember(mapOf(...))`

동일한 회원 속성을 `Map` 형태로 전달합니다.

| 키 | 자료형 | 설명 |
| --- | --- | --- |
| `id` | `String` | 회원 아이디 |
| `grade` | `String` | 회원 등급 |
| `gender` | `String` | 성별 |
| `age` | `String` | 연령대 |
| `type` | `String` | 회원 유형 |

- 위 키는 모두 필수입니다.

### `clearMemberData()`

- `setMember()`로 저장된 현재 기기의 회원 속성을 제거합니다.
- 로그인 상태 자체를 제거하려면 `setServiceLogout()`도 함께 검토하세요.

## 회원가입 전환

### `setMemberJoin(activity, userJoinId, screenId)`

회원가입 완료 시점에 호출해야 하는 메소드입니다.

| 파라미터 | 자료형 | 설명 |
| --- | --- | --- |
| `activity` | `Activity` | 호출하는 Activity |
| `userJoinId` | `String` | 회원가입한 계정 ID |
| `screenId` | `String` | 화면 식별 ID |

- 회원가입 전환을 통계에 반영합니다.
- `screenId`를 이용해 인앱메시지 노출이나 특정 화면 트리거 조건을 구성할 수 있습니다.

## 푸시 토큰 연동

### `setPushToken(token)`

| 파라미터 | 자료형 | 설명 |
| --- | --- | --- |
| `token` | `String` | FCM에서 발급받은 토큰 값 |

- FCM 토큰 생성 이후 시점에 호출해야 합니다.
- 푸시 캠페인 사용 시 사실상 필수입니다.

Flutter 앱은 Dart에서 FCM 토큰을 생성한 뒤 Android 브리지에 전달하는 형태로 사용합니다.

## 여러 기기 간 푸시 동의 동기화

### `syncMemberAgreed(memberId)`

여러 기기에서 동일한 회원이 로그인하는 경우, 최근 기기 기준 푸시 동의 상태를 동기화할 때 사용합니다.

| 파라미터 | 자료형 | 설명 |
| --- | --- | --- |
| `memberId` | `String` | 회원 아이디 |

- `setServiceLogin()` 또는 `setMemberJoin()` 호출 이후에 실행해야 합니다.

## 푸시 수신 동의 설정

| 메소드 | 설명 | 주의 사항 |
| --- | --- | --- |
| `setAgreedPush(isAgreed)` | 전체 푸시 사용 동의 상태를 전달합니다. | 초기 상태를 보내지 않으면 false로 집계될 수 있습니다. |
| `setAgreedPushAdvertising(isAgreed)` | 광고 푸시 수신 동의 상태를 전달합니다. | 클릭 시점뿐 아니라 현재 상태도 함께 보내는 것이 안전합니다. |
| `setAgreedPushNight(isAgreed)` | 야간 푸시 수신 동의 상태를 전달합니다. | 21시 이후 발송 대상 필터링에 사용됩니다. |

운영 팁:

- 설정 화면에 진입했을 때 현재 상태를 한 번 동기화하고,
- 사용자가 토글을 변경할 때 다시 한 번 동기화하는 방식이 안전합니다.

## 푸시 동의 상태 조회

### 동기식: `getPushAgreed(memberId)`

- 최근 푸시 동의 상태를 동기 방식으로 조회합니다.
- 인증 전에 호출되면 `null`이 반환될 수 있으므로 null 처리가 필요합니다.

반환값에서 확인할 수 있는 값:

- `isPush`
- `isAdvert`
- `isNight`

### 비동기식: `getPushAgreed(memberId, callback)`

- 최근 푸시 동의 상태를 비동기 콜백으로 조회합니다.
- UI 스레드를 막지 않으려면 이 방식을 권장합니다.

Flutter 앱에서는 Android에서 응답을 JSON 문자열로 직렬화해 Dart로 넘기는 방식이 일반적입니다.  
구현 예시는 [Flutter Android SDK MethodChannel 연동](./android-flutter-method-channel.md)을 참고하세요.

## 함께 보면 좋은 문서

- [Android SDK 개요 및 캠페인](./android-sdk-overview.md)
- [Android SDK 화면 이벤트 및 행동 이력 연동](./android-sdk-screen-events.md)
- [Android Flutter SDK MethodChannel 연동](./android-flutter-method-channel.md)

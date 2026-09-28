# Groobee Android SDK 설치 가이드 (Native)

이 문서는 Groobee Android Native SDK의 설치 절차만 정리한 문서입니다. 현재 권장 버전은 [Android SDK 변경 로그](../changelog/sdk-android-changelog.md)에서 확인하세요.

캠페인 개요와 기능별 사용 문서는 아래 문서를 참고하세요.

- [Android SDK 개요 및 캠페인](../detail/android-sdk-overview.md)
- [Android SDK 회원 정보 및 푸시 상태 연동](../detail/android-sdk-member-push.md)
- [Android SDK 행동 이력 수집](../detail/android-sdk-actions.md)
- [Android SDK 하이브리드 앱 데이터 동기화](../detail/android-sdk-hybrid-sync.md)
- [Android SDK 추천 상품 연동](../detail/android-sdk-recommend.md)

Flutter 앱(Android 빌드)에서 `MethodChannel`로 연동하는 경우에는 [Android Flutter SDK 설치 가이드](./installation-android-flutter-sdk.md)를 참고하세요.

---

## 목차

1. [설치 전 확인](#sdk-overview)
2. [SDK 설치](#sdk-install)
3. [Application 설정](#application-config)
4. [Push Messaging Service 설정](#push-service)
5. [설치 후 연동 문서](#sdk-methods)
6. [Android 공통 추가 설정](#android-settings)

---

<a id="sdk-overview"></a>
## 설치 전 확인

- Groobee 서비스키
- [앱 정보 등록 (앱 패키지명 / Bundle ID / 플랫폼 정보)](../prerequisites/app-name-registration.md)
- 푸시 사용 시 Firebase 프로젝트 설정과 Firebase 비공개키 업로드 — 어드민 등록 방법은 [어드민 푸시 설정 가이드](https://docs.groobee.ai/new-admin/settings/push)를 참고하세요.

SDK 개요와 캠페인 설명은 [Android SDK 개요 및 캠페인](../detail/android-sdk-overview.md) 문서에 정리했습니다.

---

<a id="sdk-install"></a>
## SDK 설치

### 1. Gradle 저장소 설정

프로젝트에서 `google()`과 `mavenCentral()` 저장소를 사용할 수 있어야 합니다. 프로젝트의 Gradle 구조에 맞춰 아래 중 하나에 두 저장소가 포함되어 있는지 확인하고, 없으면 추가합니다.

Gradle 7.0 이상 / 최신 Android Studio 기본 구조 — `settings.gradle(.kts)`:

```kotlin
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
    }
}
```

구형 프로젝트 구조 — 루트 `build.gradle`:

```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

> `repositoriesMode`(`FAIL_ON_PROJECT_REPOS` 등) 옵션은 프로젝트의 저장소 관리 정책에 따라 결정되는 설정으로, Groobee SDK 설치와 직접 관련이 없습니다. 기존 프로젝트의 값을 그대로 두고 저장소만 확인하세요.

### 2. 앱 모듈 의존성 추가

```kotlin
dependencies {
    implementation("io.groobee.message:groobee-sdk-message:<version>")
}
```

적용 버전은 [Android SDK 변경 로그](../changelog/sdk-android-changelog.md)에서 최신 안정 버전을 확인한 뒤 설정하세요.

### 3. Gradle Sync 및 빌드 확인

- Gradle Sync가 정상적으로 완료되는지 확인합니다.
- 앱을 한 번 빌드해 의존성 충돌이 없는지 확인합니다.

---

<a id="application-config"></a>
## Application 설정

Groobee 초기화는 `Application.onCreate()`에서 수행하는 것을 권장합니다.

> **기존에 커스텀 `Application` 클래스를 이미 사용 중인 경우**에는 **새로 만들지 말고** 기존 클래스의 `onCreate()`에 아래 초기화 코드를 추가하세요. `AndroidManifest.xml`의 `<application android:name="...">` 값도 그대로 유지하면 됩니다.
> **커스텀 `Application` 클래스가 없는 경우**에만 아래 예시처럼 `MyApplication` 클래스를 새로 만들고 `AndroidManifest.xml`의 `<application>`에 `android:name=".MyApplication"`을 추가하세요.

### Kotlin 예시

```kotlin
class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        val groobeeConfig = GroobeeConfig.Builder()
            .setApiKey("발급받은_서비스키")
            .setPushMoveActivityEnabled(true)
            .setPushMoveActivityClassName(MainActivity::class.java)
            .setHandlePushDeepLinks(true)
            .setSmallNotificationIcon(resources.getResourceName(R.drawable.ic_push))
            .setNotificationSettingsButton(
                R.string.txt_notification_setting,
                "myapp://setting/notification"
            )
            .setInAppMsgMarginTop(30)
            .setInAppMsgMarginBottom(40)

        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.N) {
            groobeeConfig.setPushImportance(NotificationManager.IMPORTANCE_HIGH)
        }

        Groobee.configure(this, groobeeConfig.build())
        registerActivityLifecycleCallbacks(Groobee.getInstance().activityLifecycleCallbacks)

        LoggerUtils.setLogLevel(Log.VERBOSE)
        FirebaseApp.initializeApp(this)
    }
}
```

### Java 예시

```java
public class MyApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();

        GroobeeConfig.Builder groobeeConfig = new GroobeeConfig.Builder()
                .setApiKey("발급받은_서비스키")
                .setPushMoveActivityEnabled(true)
                .setPushMoveActivityClassName(MainActivity.class)
                .setHandlePushDeepLinks(true)
                .setSmallNotificationIcon(getResources().getResourceName(R.drawable.ic_push))
                .setNotificationSettingsButton(
                        R.string.txt_notification_setting,
                        "myapp://setting/notification"
                )
                .setInAppMsgMarginTop(30)
                .setInAppMsgMarginBottom(40);

        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.N) {
            groobeeConfig.setPushImportance(NotificationManager.IMPORTANCE_HIGH);
        }

        Groobee.configure(this, groobeeConfig.build());
        registerActivityLifecycleCallbacks(Groobee.getInstance().getActivityLifecycleCallbacks());

        LoggerUtils.setLogLevel(Log.VERBOSE);
        FirebaseApp.initializeApp(this);
    }
}
```

### 주요 설정 항목

| 클래스 | 메소드 | 필수 여부 | 설명                                                                                                                                                                              |
| --- | --- | --- |---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `GroobeeConfig` | `setApiKey()` | 필수 | Groobee 어드민에서 발급받은 서비스키를 등록합니다.                                                                                                                                                 |
| `GroobeeConfig` | `setSmallNotificationIcon()` | 필수 | 푸시 알림에 사용할 small icon을 등록합니다.                                                                                                                                                   |
| `GroobeeConfig` | `setPushMoveActivityEnabled()` | 선택 | 푸시 클릭 시 특정 액티비티로 이동할지 여부를 설정합니다.                                                                                                                                                |
| `GroobeeConfig` | `setPushMoveActivityClassName()` | 조건부 필수 | `setPushMoveActivityEnabled(true)`일 때 이동할 액티비티를 지정합니다.                                                                                                                          |
| `GroobeeConfig` | `setHandlePushDeepLinks()` | 선택 | 푸시 클릭 시 딥링크 이동을 허용할지 설정합니다.                                                                                                                                                     |
| `GroobeeConfig` | `setInAppMsgMarginTop()` | 선택 | 인앱메시지 상단 여백을 설정합니다.                                                                                                                                                             |
| `GroobeeConfig` | `setInAppMsgMarginBottom()` | 선택 | 인앱메시지 하단 여백을 설정합니다.                                                                                                                                                             |
| `GroobeeConfig` | `setInAppMsgMaxHeightRatioPortrait()` | 선택 | 세로 화면에서 인앱 팝업 이미지가 쓸 수 있는 높이 비율의 상한을 설정합니다. 기본값 `0.9`, 허용 범위 `0.4` ~ `0.9`. (SDK 1.0.88 신설)                                                                                              |
| `GroobeeConfig` | `setInAppMsgMaxHeightRatioLandscape()` | 선택 | 가로 화면에서 인앱 팝업 이미지가 쓸 수 있는 높이 비율의 상한을 설정합니다. 기본값 `0.9`, 허용 범위 `0.4` ~ `0.9`. (SDK 1.0.88 신설)                                                                                              |
| `GroobeeConfig` | `setPushImportance()` | 선택 | 푸시 메시지 중요도를 설정합니다.                                                                                                                                                              |
| `GroobeeConfig` | `setRetryAuthConnection()` | 선택 | Groobee 인증 실패 시 재인증 여부를 설정합니다.                                                                                                                                                  |
| `GroobeeConfig` | `setNotificationSettingsButton()` | 선택 | 푸시 알림 하단에 수신 설정 버튼을 추가합니다. 문자열 리소스와 설정 화면 딥링크가 필요합니다.                                                                                                                           |
| `Groobee` | `configure()` | 필수 | 구성한 `GroobeeConfig`를 앱 컨텍스트에 적용합니다.                                                                                                                                             |
| `Groobee` | `getActivityLifecycleCallbacks()` | 필수 | 앱 생명주기에 맞춰 Groobee 세션을 처리할 콜백을 반환합니다. `Application.registerActivityLifecycleCallbacks()`에 등록해 사용합니다.                                                                            |
| `LoggerUtils` | `setLogLevel()` | 선택 | 로그 레벨을 설정합니다.                                                                                                                                                                   |
| `LoggerUtils` | `setOptions()` | 선택 | 여러 로그 옵션을 키-값 형태로 한 번에 설정합니다. 지원 옵션은 아래 표 참고. |
| `FirebaseApp` | `initializeApp()` | 푸시 사용 시 필수 | FCM 연동을 초기화합니다. |

`setNotificationSettingsButton()`에 전달하는 첫 번째 값은 문자열 리소스 ID입니다. 실제 버튼에는 `groobee_noti_config` 같은 리소스 키가 아니라 현재 언어 설정에 맞는 문자열이 노출되어야 합니다.

`LoggerUtils.setOptions()` 지원 옵션:

| 키 | 자료형 | 설명 |
| --- | --- | --- |
| `DETAIL_LOG_ENABLED` | `boolean` | 상세 로그 활성화 |
| `TRACE_ENABLED` | `boolean` | 추적 아이디 활성화 |
| `LOG_CALLBACK` | `LoggerUtils.LogCallback` | 로그 콜백 등록 |

<a id="inapp-popup-height-ratio"></a>
#### 인앱 팝업 이미지 높이 상한 (SDK 1.0.88 이상)

`setInAppMsgMaxHeightRatioPortrait()` / `setInAppMsgMaxHeightRatioLandscape()`로 **인앱 팝업(POPUP) 이미지**가 차지할 수 있는 높이의 상한을 조절할 수 있습니다. 두 메소드 모두 **선택 사항**이며, 호출하지 않으면 기본값으로 동작합니다.

```java
GroobeeConfig config = new GroobeeConfig.Builder()
        .setApiKey("발급받은 서비스키")
        .setInAppMsgMaxHeightRatioPortrait(0.8f)   // 세로 화면 상한
        .setInAppMsgMaxHeightRatioLandscape(0.7f)  // 가로 화면 상한
        .build();
```

| 항목 | 값 |
| --- | --- |
| 기본값 | `0.9` (세로 · 가로 동일) |
| 허용 범위 | `0.4` ~ `0.9` |
| 범위를 벗어난 값 | 가까운 끝값으로 조정됩니다 (`0.9` 초과 → `0.9`, `0.4` 미만 → `0.4`). 경고 로그가 남고 팝업은 정상 노출됩니다 |
| `0` 이하 또는 유효하지 않은 값 | 기본값 `0.9`으로 동작합니다 |

- **기준은 화면 전체 높이가 아니라 「팝업이 쓸 수 있는 높이」입니다.** 상태바와 내비게이션 바를 제외한 높이를 기준으로 계산합니다.
- **적용 대상은 인앱 메시지 중 팝업(POPUP, 이미지 팝업)뿐입니다.**
- **세로 화면에서는 값을 낮춰도 차이가 거의 없습니다.** 세로에서는 보통 이미지의 폭이 먼저 화면에 닿기 때문에 높이 상한까지 도달하지 않습니다. 화면보다 세로로 긴 소재에서만 좌우 여백이 생기는 형태로 나타납니다.
- **가로 화면에서는 이 값이 곧 팝업 크기입니다.** 값을 낮추면 팝업이 작아지고 위아래 딤(어두운) 배경이 더 보입니다.
- 가로·세로 구분은 기기의 물리적 방향이 아니라 **그 순간 앱이 쓸 수 있는 영역의 가로세로 비율**로 판단합니다(폴더블 접기/펼치기, 멀티윈도우 포함).
- 값은 내부적으로 백분율 정수로 저장되어 **실질 정밀도는 소수점 둘째 자리(0.01 단위)** 입니다.

### 푸시 중요도 설정

Groobee SDK 1.0.44 버전부터 지원되며, Android 공식 문서 기준으로 작성되어 있습니다.

| 값 | 설명 |
| --- | --- |
| `NotificationManager.IMPORTANCE_DEFAULT` | 기본값입니다. 알림이 일반 우선순위로 표시되고 소리/진동이 발생합니다. |
| `NotificationManager.IMPORTANCE_HIGH` | 높은 우선순위로 표시되며, 푸시 수신 시 Toast 노출도 지원합니다. |

> Android 공식 문서에는 `IMPORTANCE_LOW`, `IMPORTANCE_MIN`도 존재하지만, 그루비 푸시 메시지 지원 기능 특성상 부적합하다고 판단되어 `IMPORTANCE_DEFAULT`보다 낮은 값은 적용되지 않습니다.
> `setPushImportance()`를 호출하지 않으면 `IMPORTANCE_DEFAULT`가 기본값으로 적용됩니다.

`IMPORTANCE_HIGH` 설정 시에는 아래와 같이 푸시 수신 순간 상단에 Toast 메시지가 함께 노출됩니다.

![IMPORTANCE_HIGH Toast 노출 예시](../images/sdk/android/push-importance-high-toast.png){ width="280" }

---

<a id="push-service"></a>
## Push Messaging Service 설정

### 기본 서비스 등록

```xml
<application
    android:name=".MyApplication"
    ...>

    <service
        android:name="io.groobee.message.GroobeeFirebaseMessagingService"
        android:exported="false">
        <intent-filter>
            <action android:name="com.google.firebase.MESSAGING_EVENT" />
        </intent-filter>
    </service>
</application>
```

> 일반 FCM 서비스 등록 시에는 Android 최신 보안 관행에 맞춰 `exported="false"`를 권장합니다. 잠금 상태(Direct Boot) 기기에서도 푸시를 수신해야 하는 경우에는 [Android 공통 추가 설정](./installation-android-common-settings.md)에서 `exported="true"`와 `directBootAware="true"`를 함께 설정하는 별도 예시를 참고하세요.

### 기존 FirebaseMessagingService를 이미 사용 중인 경우

Kotlin:

```kotlin
class CustomService : FirebaseMessagingService() {
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)

        if (GroobeeFirebaseMessagingService.handleRemoteMessage(this, remoteMessage)) {
            return
        }

        remoteMessage.notification?.let {
            Log.d("CustomService", "Message Notification Body: ${it.body}")
        }
    }
}
```

Java:

```java
public class CustomService extends FirebaseMessagingService {
    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);

        if (GroobeeFirebaseMessagingService.handleRemoteMessage(this, remoteMessage)) {
            return;
        }

        if (remoteMessage.getNotification() != null) {
            Log.d("CustomService", "Message Notification Body: "
                    + remoteMessage.getNotification().getBody());
        }
    }
}
```

이 경우 `AndroidManifest.xml`에는 **기본 `GroobeeFirebaseMessagingService`가 아니라 직접 만든 `CustomService`만** 등록합니다. `<action>`은 동일하게 `com.google.firebase.MESSAGING_EVENT`를 선언해야 FCM이 이 서비스로 메시지를 전달합니다.

```xml
<application
    android:name=".MyApplication"
    ...>

    <service
        android:name=".CustomService"
        android:exported="false">
        <intent-filter>
            <action android:name="com.google.firebase.MESSAGING_EVENT" />
        </intent-filter>
    </service>
</application>
```

> 기존에 등록된 FCM 서비스가 있다면 하나의 엔트리만 남기고 정리하세요. `GroobeeFirebaseMessagingService`와 `CustomService`가 동시에 등록되어 있으면 동일 메시지가 중복 처리될 수 있습니다.

---

<a id="sdk-methods"></a>
## 설치 후 연동 문서

<a id="member-push-methods"></a>
### 회원 정보 및 푸시 상태

- [Android SDK 회원 정보 및 푸시 상태 연동](../detail/android-sdk-member-push.md)

<a id="screen-methods"></a>
### 행동 이력 수집

- [Android SDK 행동 이력 수집](../detail/android-sdk-actions.md)

<a id="hybrid-methods"></a>
### 하이브리드 앱 데이터 동기화

- [Android SDK 하이브리드 앱 데이터 동기화](../detail/android-sdk-hybrid-sync.md)

<a id="recommend-methods"></a>
### 추천 상품 연동

- [Android SDK 추천 상품 연동](../detail/android-sdk-recommend.md)

---

<a id="android-settings"></a>
## Android 공통 추가 설정

- [Android 공통 추가 설정](./installation-android-common-settings.md)

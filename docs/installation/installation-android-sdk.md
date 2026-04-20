# Groobee Android SDK 설치 가이드 (Native)

이 문서는 `[Native] Groobee Android SDK 설정 가이드 v1.0.80` 기준으로 Android 네이티브 앱의 설치 절차만 정리한 문서입니다.

캠페인 개요와 기능별 사용 문서는 아래 문서를 참고하세요.

- [Android SDK 개요 및 캠페인](../detail/android-sdk-overview.md)
- [Android SDK 회원 정보 및 푸시 상태 연동](../detail/android-sdk-member-push.md)
- [Android SDK 화면 이벤트 및 행동 이력 연동](../detail/android-sdk-screen-events.md)
- [Android SDK 하이브리드 앱 데이터 동기화](../detail/android-sdk-hybrid-sync.md)
- [Android SDK 추천 상품 연동](../detail/android-sdk-recommend.md)

Flutter 앱(Android 빌드)에서 `MethodChannel`로 연동하는 경우에는 [Android Flutter SDK 설치 가이드](./installation-android-flutter-sdk.md)를 참고하세요.

<a id="sdk-overview"></a>
## 설치 전 확인

- Groobee 서비스키
- [앱 패키지명 등록](../prerequisites/app-name-registration.md)
- [사용 플랫폼 정보 등록](../prerequisites/app-platform-registration.md)
- 푸시 사용 시 Firebase 프로젝트 설정과 Firebase 비공개키 업로드

SDK 개요와 캠페인 설명은 [Android SDK 개요 및 캠페인](../detail/android-sdk-overview.md) 문서에 정리했습니다.

---

<a id="sdk-install"></a>
## SDK 설치

### 1. Gradle 저장소 설정

프로젝트에서 `google()`과 `mavenCentral()` 저장소를 사용할 수 있어야 합니다.

```kotlin
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
```

구형 프로젝트 구조에서는 루트 `build.gradle`의 `allprojects.repositories`에 동일하게 추가하면 됩니다.

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

| 설정 | 필수 여부 | 설명 |
| --- | --- | --- |
| `setApiKey()` | 필수 | Groobee 어드민에서 발급받은 서비스키를 등록합니다. |
| `setSmallNotificationIcon()` | 필수 | 푸시 알림에 사용할 small icon을 등록합니다. |
| `setPushMoveActivityEnabled()` | 선택 | 푸시 클릭 시 특정 액티비티로 이동할지 여부를 설정합니다. |
| `setPushMoveActivityClassName()` | 조건부 필수 | `setPushMoveActivityEnabled(true)`일 때 이동할 액티비티를 지정합니다. |
| `setHandlePushDeepLinks()` | 선택 | 푸시 클릭 시 딥링크 이동을 허용할지 설정합니다. |
| `setInAppMsgMarginTop()` | 선택 | 인앱메시지 상단 여백을 설정합니다. |
| `setInAppMsgMarginBottom()` | 선택 | 인앱메시지 하단 여백을 설정합니다. |
| `setPushImportance()` | 선택 | 푸시 메시지 중요도를 설정합니다. |
| `setRetryAuthConnection()` | 선택 | Groobee 인증 실패 시 재인증 여부를 설정합니다. |
| `setNotificationSettingsButton()` | 선택 | 푸시 알림 하단에 수신 설정 버튼을 추가합니다. 문자열 리소스와 설정 화면 딥링크가 필요합니다. |
| `Groobee.configure()` | 필수 | 구성한 `GroobeeConfig`를 앱 컨텍스트에 적용합니다. |
| `registerActivityLifecycleCallbacks()` | 필수 | 앱 생명주기에 맞춰 Groobee 세션을 처리합니다. |
| `LoggerUtils.setLogLevel()` | 선택 | 로그 레벨을 설정합니다. |
| `LoggerUtils.setOptions()` | 선택 | 상세 로그, 트레이스, 로그 콜백 등 추가 로그 옵션을 설정합니다. |
| `FirebaseApp.initializeApp()` | 푸시 사용 시 필수 | FCM 연동을 초기화합니다. |

`setNotificationSettingsButton()`에 전달하는 첫 번째 값은 문자열 리소스 ID입니다. 실제 버튼에는 `groobee_noti_config` 같은 리소스 키가 아니라 현재 언어 설정에 맞는 문자열이 노출되어야 합니다.

### 푸시 중요도 설정

| 값 | 설명 |
| --- | --- |
| `NotificationManager.IMPORTANCE_DEFAULT` | 기본값입니다. 알림이 일반 우선순위로 표시되고 소리/진동이 발생합니다. |
| `NotificationManager.IMPORTANCE_HIGH` | 높은 우선순위로 표시되며, 푸시 수신 시 Toast 노출도 지원합니다. |

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

> 기존에 등록된 FCM 서비스가 있다면 하나의 엔트리만 남기고 정리하세요.

---

<a id="sdk-methods"></a>
## 설치 후 연동 문서

<a id="member-push-methods"></a>
### 회원 정보 및 푸시 상태

- [Android SDK 회원 정보 및 푸시 상태 연동](../detail/android-sdk-member-push.md)

<a id="screen-methods"></a>
### 화면 이벤트 및 행동 이력

- [Android SDK 화면 이벤트 및 행동 이력 연동](../detail/android-sdk-screen-events.md)

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

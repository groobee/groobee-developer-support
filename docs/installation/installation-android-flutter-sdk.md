# Groobee Android SDK 설치 가이드 (Flutter)

이 문서는 Groobee Android SDK(Flutter) `1.0.80` 기준으로 Flutter 앱(Android 빌드)의 설치 절차만 정리한 문서입니다.

캠페인 개요와 기능별 사용 문서는 아래 문서를 참고하세요.

- [Android SDK 개요 및 캠페인](../detail/android-sdk-overview.md)
- [Android SDK 회원 정보 및 푸시 상태 연동](../detail/android-sdk-member-push.md)
- [Android SDK 화면 이벤트 및 행동 이력 연동](../detail/android-sdk-screen-events.md)
- [Android SDK 하이브리드 앱 데이터 동기화](../detail/android-sdk-hybrid-sync.md)
- [Android SDK 추천 상품 연동](../detail/android-sdk-recommend.md)
- [Flutter Android SDK MethodChannel 연동](../detail/android-flutter-method-channel.md)

<a id="flutter-install"></a>
## 설치 전 확인

- Groobee 서비스키
- [앱 정보 등록 (앱 패키지명 / Bundle ID / 플랫폼 정보)](../prerequisites/app-name-registration.md)
- 푸시 사용 시 Firebase 프로젝트 설정
- `android/app/google-services.json` 파일 준비
- Flutter 프로젝트에서 Android 모듈을 수정할 수 있는 환경

---

## SDK 설치

### 1. `pubspec.yaml`에 Firebase 패키지 추가

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^<compatible-version>
  firebase_core_platform_interface: ^<compatible-version>
  firebase_messaging: ^<compatible-version>
```

문서 원본 예시는 `firebase_messaging: ^14.1.0`, `firebase_core: ^2.7.0`, `firebase_core_platform_interface: ^4.5.3` 기준입니다. 실제 적용 시에는 현재 사용하는 Flutter SDK 및 Firebase 설정과 호환되는 버전을 사용하세요.

### 2. Flutter 패키지 동기화 후 Android 모듈 열기

```bash
flutter pub get
```

- 명령 실행 후 Android Studio에서 프로젝트를 연 뒤 Android 관련 설정 파일을 직접 편집하거나
- Flutter 프로젝트에서 `Open Android module in Android Studio`를 사용합니다.

### 3. 최상위 `build.gradle` 설정

```gradle
buildscript {
    ext.kotlin_version = '<kotlin-version>'

    dependencies {
        classpath 'com.android.tools.build:gradle:<gradle-plugin-version>'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:<version>'
    }
}
```

문서 원본 예시는 `com.google.gms:google-services:4.3.15` 기준이며, Android Gradle Plugin과 Kotlin 플러그인은 프로젝트의 Flutter/Android 환경에 맞는 버전을 사용해야 합니다. PDF에는 `classpath 'com.android.tools.build:gradle:<gradle-version>'`, `classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"` 두 항목이 함께 예시로 포함되어 있습니다.

### 4. `android/app/build.gradle` 설정

```gradle
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'com.google.gms.google-services'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

android {
    defaultConfig {
        multiDexEnabled true
    }
}

dependencies {
    implementation "androidx.multidex:multidex:2.0.1"

    implementation platform('com.google.firebase:firebase-bom:<version>')
    implementation 'com.google.firebase:firebase-messaging'

    implementation 'io.groobee.message:groobee-sdk-message:<version>'
}
```

문서 원본 예시는 Firebase BOM `26.4.0`, Groobee SDK `1.0.77` 기준입니다. Groobee SDK 버전은 [Android SDK 변경 로그](../changelog/sdk-android-changelog.md)에서 최신 안정 버전을 확인한 뒤 적용하세요.

### 5. Gradle Sync 확인

- Gradle Sync가 정상 완료되는지 확인합니다.
- Android 모듈이 정상 빌드되는지 확인합니다.

---

<a id="application-config"></a>
## Application 설정

Flutter 앱에서도 Groobee 초기화는 Android `Application` 클래스에서 수행하는 것을 권장합니다.

1. `android/app/src/main/kotlin/...` 또는 `java/...` 아래에 `MyApplication` 클래스를 생성합니다.
2. `onCreate()`에서 Groobee SDK를 초기화합니다.
3. `AndroidManifest.xml`의 `<application>`에 `android:name=".MyApplication"`을 설정합니다.

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
                "myapp://setting/notify"
            )
            .setInAppMsgMarginTop(30)
            .setInAppMsgMarginBottom(40)

        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.N) {
            groobeeConfig.setPushImportance(NotificationManager.IMPORTANCE_HIGH)
        }

        Groobee.configure(this, groobeeConfig.build())
        registerActivityLifecycleCallbacks(Groobee.getInstance().activityLifecycleCallbacks)

        LoggerUtils.setLogLevel(Log.VERBOSE)
    }
}
```

### Java 예시

Java 프로젝트를 사용하는 경우에는 `android/app/src/main/java/...` 아래에 동일한 역할의 `Application` 클래스를 만들면 됩니다.

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
                        "myapp://setting/notify"
                )
                .setInAppMsgMarginTop(30)
                .setInAppMsgMarginBottom(40);

        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.N) {
            groobeeConfig.setPushImportance(NotificationManager.IMPORTANCE_HIGH);
        }

        Groobee.configure(this, groobeeConfig.build());
        registerActivityLifecycleCallbacks(Groobee.getInstance().getActivityLifecycleCallbacks());

        LoggerUtils.setLogLevel(Log.VERBOSE);
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
| `FirebaseApp.initializeApp()` | PDF 설정표 기준 필수 | 원문 표에는 FCM 연동 필수 항목으로 포함되어 있습니다. |

`setNotificationSettingsButton()`에 전달하는 첫 번째 값은 문자열 리소스 ID입니다. 실제 버튼에는 `groobee_noti_config` 같은 리소스 키가 아니라 현재 언어 설정에 맞는 문자열이 노출되어야 합니다.

> Flutter PDF는 `FirebaseApp.initializeApp()`를 설정표에 포함하지만, 예제 코드에서는 Dart 측 `Firebase.initializeApp()`만 안내합니다. 실제 프로젝트의 Firebase 초기화 방식과 SDK 요구사항을 함께 확인하세요.

> Flutter 앱에서는 FCM 토큰 생성 전에 Dart 측에서 `Firebase.initializeApp()`을 먼저 호출해야 합니다.

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

> 원본 PDF 예시에는 `android:exported` 속성이 별도로 명시되어 있지 않습니다. Android 최신 보안 관행에 맞춰 `exported="false"`를 권장하며, Direct Boot 지원이 필요한 경우에만 [Android 공통 추가 설정](./installation-android-common-settings.md)의 `exported="true"` 예시를 사용하세요.

### 기존 FirebaseMessagingService가 있는 경우

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

이 경우 `AndroidManifest.xml`에는 `CustomService`만 등록하고, 기존 중복 서비스 엔트리는 제거하세요.

---

<a id="method-channel"></a>
## Flutter 브리지 구현 문서

- [Flutter Android SDK MethodChannel 연동](../detail/android-flutter-method-channel.md)

---

<a id="sdk-methods"></a>
## 설치 후 연동 문서

- [Android SDK 회원 정보 및 푸시 상태 연동](../detail/android-sdk-member-push.md)
- [Android SDK 화면 이벤트 및 행동 이력 연동](../detail/android-sdk-screen-events.md)
- [Android SDK 하이브리드 앱 데이터 동기화](../detail/android-sdk-hybrid-sync.md)
- [Android SDK 추천 상품 연동](../detail/android-sdk-recommend.md)

---

<a id="android-settings"></a>
## Android 공통 추가 설정

- [Android 공통 추가 설정](./installation-android-common-settings.md)

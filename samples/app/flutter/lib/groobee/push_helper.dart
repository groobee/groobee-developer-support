import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'groobee_bridge.dart';

/// FCM 토큰을 발급받아 Groobee 로 전달하는 헬퍼.
///
/// Flutter 앱에서는 보통 Dart 측 firebase_messaging 으로 토큰을 받아
/// MethodChannel(setPushToken) 로 네이티브 Groobee SDK 에 전달합니다.
class PushHelper {
  static Future<void> initAndRegisterToken({void Function(String) log = print}) async {
    // GoogleService-Info.plist / google-services.json 이 없으면 초기화 실패 → 건너뜀
    try {
      await Firebase.initializeApp();
    } catch (e) {
      log('Firebase 초기화 건너뜀 (Firebase 설정 파일 필요): $e');
      return;
    }

    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();

      final token = await messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await GroobeeBridge.instance.setPushToken(token);
        final preview = token.length > 24 ? token.substring(0, 24) : token;
        log('FCM 토큰 → setPushToken(): $preview…');
      }

      messaging.onTokenRefresh.listen((newToken) {
        GroobeeBridge.instance.setPushToken(newToken);
        log('FCM 토큰 갱신 → setPushToken()');
      });
    } catch (e) {
      log('FCM 토큰 처리 실패: $e');
    }
  }
}

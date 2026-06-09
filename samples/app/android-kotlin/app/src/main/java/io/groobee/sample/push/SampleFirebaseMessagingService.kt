package io.groobee.sample.push

import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import io.groobee.message.Groobee
import io.groobee.message.GroobeeFirebaseMessagingService
import io.groobee.sample.LogBus

/**
 * FCM 메시지 수신 서비스.
 *
 * 가장 간단한 방법은 AndroidManifest.xml 에 Groobee 기본 서비스
 * (io.groobee.message.GroobeeFirebaseMessagingService) 를 직접 등록하는 것입니다.
 *
 * 이 샘플은 "이미 자체 FirebaseMessagingService 가 있는 앱"을 가정하여,
 * 커스텀 서비스에서 Groobee 핸들러로 위임하는 패턴을 보여줍니다.
 *
 * ⚠️ 기본 서비스와 커스텀 서비스를 동시에 등록하지 마세요(푸시 중복 처리).
 */
class SampleFirebaseMessagingService : FirebaseMessagingService() {

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d(TAG, "onNewToken: $token")
        // 토큰이 갱신되면 Groobee 로 전달합니다.
        Groobee.getInstance().setPushToken(token)
        LogBus.log("FCM 토큰 갱신 → Groobee.setPushToken()")
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)

        // Groobee 가 보낸 푸시라면 SDK 가 처리합니다. (true 반환 시 처리 완료)
        if (GroobeeFirebaseMessagingService.handleRemoteMessage(this, remoteMessage)) {
            LogBus.log("Groobee 푸시 수신 처리됨")
            return
        }

        // Groobee 외 다른 푸시는 앱에서 직접 처리
        remoteMessage.notification?.let {
            Log.d(TAG, "Non-Groobee message body: ${it.body}")
            LogBus.log("일반 푸시 수신: ${it.body}")
        }
    }

    companion object {
        private const val TAG = "SampleFCMService"
    }
}

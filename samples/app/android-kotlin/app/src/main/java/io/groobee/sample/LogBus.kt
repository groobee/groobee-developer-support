package io.groobee.sample

import android.os.Handler
import android.os.Looper
import android.util.Log
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * 데모 화면에 SDK 호출 결과를 보여주기 위한 단순한 인메모리 로그 버스.
 *
 * 실제 앱에는 필요 없으며, 샘플에서 어떤 SDK 메소드가 호출됐는지
 * 눈으로 확인하기 위한 용도입니다.
 */
object LogBus {

    private const val TAG = "GroobeeSample"

    private val handler = Handler(Looper.getMainLooper())
    private val builder = StringBuilder()
    private val timeFormat = SimpleDateFormat("HH:mm:ss", Locale.KOREA)

    /** 로그가 갱신될 때 UI 가 구독하는 콜백 */
    var listener: ((String) -> Unit)? = null

    fun log(message: String) {
        Log.d(TAG, message)
        val line = "[${timeFormat.format(Date())}] $message"
        val snapshot: String
        synchronized(builder) {
            builder.insert(0, line + "\n")
            snapshot = builder.toString()
        }
        handler.post { listener?.invoke(snapshot) }
    }

    fun clear() {
        synchronized(builder) { builder.setLength(0) }
        handler.post { listener?.invoke("") }
    }

    fun current(): String = synchronized(builder) { builder.toString() }
}

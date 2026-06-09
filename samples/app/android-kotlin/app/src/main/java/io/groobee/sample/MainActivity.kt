package io.groobee.sample

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.google.firebase.messaging.FirebaseMessaging
import io.groobee.message.Groobee
import io.groobee.message.common.interfaces.ResultAgreeds
import io.groobee.message.common.interfaces.ResultGoods
import io.groobee.message.models.Agreeds
import io.groobee.message.recommend.model.RecommendData
import io.groobee.sample.databinding.ActivityMainBinding

/**
 * Groobee SDK 의 주요 기능을 버튼으로 하나씩 호출해 볼 수 있는 데모 화면입니다.
 *
 *  ① 회원/로그인  ② 푸시  ③ 행동 이력  ④ AI 추천
 *
 * 호출 결과는 하단 로그(LogBus) 영역에 표시됩니다.
 * 실제 데이터가 서버에 쌓이려면 GroobeeSampleConfig.SERVICE_KEY 를
 * 유효한 서비스키로 교체해야 합니다.
 */
class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    /** getPushAgreed 결과로 스위치를 갱신할 때, 변경 리스너가 다시 호출되지 않도록 막는 플래그 */
    private var suppressSwitchEvents = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // 로그 영역 구독
        LogBus.listener = { text -> binding.tvLog.text = text }
        binding.tvLog.text = LogBus.current()

        updateStatus()
        requestNotificationPermissionIfNeeded()

        // 현재 화면(홈) 진입 이력 전송
        Groobee.getInstance().setScreenData(this, GroobeeSampleConfig.SCREEN_HOME)
        LogBus.log("화면 진입: setScreenData(HOME)")

        // 앱 시작 시 현재 FCM 토큰을 Groobee 로 전달
        fetchAndSendPushToken()

        bindMemberButtons()
        bindPushButtons()
        bindActionButtons()
        bindRecommendButton()

        binding.btnClearLog.setOnClickListener { LogBus.clear() }
    }

    // ───────────────────────── ① 회원 / 로그인 ─────────────────────────
    private fun bindMemberButtons() {
        binding.btnLogin.setOnClickListener {
            Groobee.getInstance().setServiceLogin(GroobeeSampleConfig.DEMO_MEMBER_ID)
            LogBus.log("로그인: setServiceLogin(${GroobeeSampleConfig.DEMO_MEMBER_ID})")
            updateStatus()
        }

        binding.btnSetMember.setOnClickListener {
            // 회원 속성 전달 (키: id / grade / gender / age / type)
            val member = mutableMapOf(
                "id" to GroobeeSampleConfig.DEMO_MEMBER_ID,
                "grade" to "VIP",
                "gender" to "M",
                "age" to "30",
                "type" to "general"
            )
            Groobee.getInstance().setMember(member)
            LogBus.log("회원정보: setMember($member)")
        }

        binding.btnSignup.setOnClickListener {
            Groobee.getInstance().setMemberJoin(
                this@MainActivity,
                GroobeeSampleConfig.DEMO_MEMBER_ID,
                GroobeeSampleConfig.SCREEN_SIGN_UP
            )
            LogBus.log("회원가입 완료: setMemberJoin(...)")
        }

        binding.btnSyncAgreed.setOnClickListener {
            // 로그인/회원가입 직후 호출하여 기기 간 동의 상태를 동기화
            Groobee.getInstance().syncMemberAgreed(GroobeeSampleConfig.DEMO_MEMBER_ID)
            LogBus.log("동의상태 동기화: syncMemberAgreed(...)")
        }

        binding.btnLogout.setOnClickListener {
            Groobee.getInstance().setServiceLogout()
            Groobee.getInstance().clearMemberData()
            LogBus.log("로그아웃: setServiceLogout() + clearMemberData()")
            updateStatus()
        }
    }

    // ───────────────────────── ② 푸시 (Push) ─────────────────────────
    private fun bindPushButtons() {
        binding.btnPushToken.setOnClickListener { fetchAndSendPushToken() }

        binding.switchPush.setOnCheckedChangeListener { _, isChecked ->
            if (suppressSwitchEvents) return@setOnCheckedChangeListener
            Groobee.getInstance().setAgreedPush(isChecked)
            LogBus.log("전체 푸시 동의: setAgreedPush($isChecked)")
        }
        binding.switchAd.setOnCheckedChangeListener { _, isChecked ->
            if (suppressSwitchEvents) return@setOnCheckedChangeListener
            Groobee.getInstance().setAgreedPushAdvertising(isChecked)
            LogBus.log("광고 푸시 동의: setAgreedPushAdvertising($isChecked)")
        }
        binding.switchNight.setOnCheckedChangeListener { _, isChecked ->
            if (suppressSwitchEvents) return@setOnCheckedChangeListener
            Groobee.getInstance().setAgreedPushNight(isChecked)
            LogBus.log("야간 푸시 동의: setAgreedPushNight($isChecked)")
        }

        binding.btnQueryConsent.setOnClickListener {
            Groobee.getInstance().getPushAgreed(
                GroobeeSampleConfig.DEMO_MEMBER_ID,
                object : ResultAgreeds {
                    override fun onSuccess(agreeds: Agreeds) {
                        runOnUiThread {
                            suppressSwitchEvents = true
                            binding.switchPush.isChecked = agreeds.isPush
                            binding.switchAd.isChecked = agreeds.isAdvert
                            binding.switchNight.isChecked = agreeds.isNight
                            suppressSwitchEvents = false
                        }
                        LogBus.log(
                            "동의상태 조회 성공: push=${agreeds.isPush}, " +
                                "advert=${agreeds.isAdvert}, night=${agreeds.isNight}"
                        )
                    }

                    override fun onFailed(exceptMsg: String) {
                        LogBus.log("동의상태 조회 실패: $exceptMsg")
                    }
                }
            )
        }
    }

    private fun fetchAndSendPushToken() {
        try {
            FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val token = task.result
                    Groobee.getInstance().setPushToken(token)
                    LogBus.log("FCM 토큰 → setPushToken(): ${token.take(24)}…")
                } else {
                    LogBus.log("FCM 토큰 조회 실패: ${task.exception?.message}")
                }
            }
        } catch (e: Exception) {
            LogBus.log("FCM 사용 불가 (Firebase 미구성?): ${e.message}")
        }
    }

    // ───────────────────────── ③ 행동 이력 (Actions) ─────────────────────────
    private fun bindActionButtons() {
        binding.btnSearch.setOnClickListener {
            Groobee.getInstance()
                .setSearchKeyword(this@MainActivity, "겨울 패딩", GroobeeSampleConfig.SCREEN_SEARCH)
            LogBus.log("검색: setSearchKeyword(\"겨울 패딩\")")
        }

        binding.btnViewGoods.setOnClickListener {
            val goods = DemoData.sampleGoods()
            Groobee.getInstance()
                .setViewGoods(this@MainActivity, goods, GroobeeSampleConfig.SCREEN_PRODUCT_DETAIL)
            LogBus.log("상품 상세: setViewGoods(${goods.goodsNm})")
        }

        binding.btnCategory.setOnClickListener {
            Groobee.getInstance()
                .setCategory(this@MainActivity, "C99", "티셔츠", GroobeeSampleConfig.SCREEN_CATEGORY)
            LogBus.log("카테고리: setCategory(C99, 티셔츠)")
        }

        binding.btnCart.setOnClickListener {
            val cart = DemoData.sampleCart()
            Groobee.getInstance()
                .setShoppingCart(this@MainActivity, cart, GroobeeSampleConfig.SCREEN_CART)
            LogBus.log("장바구니: setShoppingCart(${cart.size}개)")
        }

        binding.btnOrder.setOnClickListener {
            val cart = DemoData.sampleCart()
            Groobee.getInstance()
                .setGoodsOrder(this@MainActivity, cart, GroobeeSampleConfig.SCREEN_ORDER)
            LogBus.log("주문서: setGoodsOrder(${cart.size}개)")
        }

        binding.btnOrderComplete.setOnClickListener {
            val cart = DemoData.sampleCart()
            val orderNo = "ORD-20260609-0001"
            Groobee.getInstance().setGoodsOrderComplete(
                this@MainActivity,
                orderNo,
                cart,
                GroobeeSampleConfig.SCREEN_ORDER_COMPLETE
            )
            LogBus.log("주문 완료: setGoodsOrderComplete($orderNo, ${cart.size}개)")
        }

        binding.btnCustomEvent.setOnClickListener {
            // 커스텀 이벤트: (eventKey, eventValue, screenId)
            Groobee.getInstance().setCustomEvent(
                this@MainActivity,
                "wishlist_add",
                "0011",
                GroobeeSampleConfig.SCREEN_HOME
            )
            LogBus.log("커스텀 이벤트: setCustomEvent(wishlist_add, 0011)")
        }
    }

    // ───────────────────────── ④ AI 추천 (Recommend) ─────────────────────────
    private fun bindRecommendButton() {
        binding.btnRecommend.setOnClickListener {
            val campaignKey = GroobeeSampleConfig.RECOMMEND_CAMPAIGN_KEY
            LogBus.log("추천 요청: getRecommendGoods($campaignKey)")

            Groobee.getInstance().getRecommendGoods(campaignKey, object : ResultGoods {
                override fun onSuccess(recommendData: RecommendData) {
                    val list = recommendData.goodsList ?: emptyList()
                    val requestId = recommendData.requestId
                    val cKey = recommendData.campaignKey
                    val algorithmCd = recommendData.algorithmCd

                    LogBus.log("추천 응답: ${list.size}개 (algorithmCd=$algorithmCd)")
                    list.take(5).forEachIndexed { i, g ->
                        LogBus.log("  #${i + 1} ${g.goodsNm} (${g.goodsCd}) ${g.goodsSalePrc}원")
                    }

                    if (list.isNotEmpty()) {
                        // 추천 상품이 화면에 노출됨 → 노출 통계 전송
                        Groobee.getInstance()
                            .setShowRecommendGoods(requestId, cKey, algorithmCd, list)
                        LogBus.log("노출 통계 전송: setShowRecommendGoods()")

                        // (데모) 첫 번째 추천 상품을 클릭했다고 가정 → 클릭 통계 전송
                        Groobee.getInstance()
                            .setClickRecommendGoods(requestId, cKey, algorithmCd, list[0])
                        LogBus.log("클릭 통계 전송: setClickRecommendGoods(${list[0].goodsNm})")
                    }
                }

                // 주의: SDK 1.0.83 의 onFailed 는 (exceptMsg, campaignKey) 2개 인자입니다.
                override fun onFailed(exceptMsg: String, campaignKey: String) {
                    LogBus.log("추천 실패: $exceptMsg (campaignKey=$campaignKey)")
                }
            })
        }
    }

    // ───────────────────────── 공통 ─────────────────────────
    private fun updateStatus() {
        val keyConfigured = GroobeeSampleConfig.SERVICE_KEY != "YOUR_GROOBEE_SERVICE_KEY"
        binding.tvStatus.text = buildString {
            append("서비스키: ")
            append(if (keyConfigured) "설정됨" else "⚠️ 미설정 (placeholder)")
            append("\n데모 회원ID: ${GroobeeSampleConfig.DEMO_MEMBER_ID}")
        }
    }

    private fun requestNotificationPermissionIfNeeded() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            val granted = ContextCompat.checkSelfPermission(
                this, Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
            if (!granted) {
                requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), REQ_NOTIFICATION)
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQ_NOTIFICATION) {
            val granted = grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
            LogBus.log("알림 권한(POST_NOTIFICATIONS): ${if (granted) "허용" else "거부"}")
        }
    }

    override fun onDestroy() {
        LogBus.listener = null
        super.onDestroy()
    }

    companion object {
        private const val REQ_NOTIFICATION = 1000
    }
}

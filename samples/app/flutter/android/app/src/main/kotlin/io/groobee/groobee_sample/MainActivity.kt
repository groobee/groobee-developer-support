package io.groobee.groobee_sample

import android.app.NotificationManager
import android.os.Build
import android.util.Log
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.groobee.message.Groobee
import io.groobee.message.GroobeeConfig
import io.groobee.message.common.interfaces.ResultAgreeds
import io.groobee.message.common.interfaces.ResultGoods
import io.groobee.message.models.Agreeds
import io.groobee.message.models.Goods
import io.groobee.message.recommend.model.RecommendData
import io.groobee.message.utils.LoggerUtils

/**
 * Dart ↔ Android Groobee SDK 브리지.
 *
 * Dart 의 공통 메소드 이름을 받아 Android SDK 메소드로 매핑합니다.
 * 행동 이력 API 는 Activity 가 필요하므로 MainActivity(this)를 넘깁니다.
 */
class MainActivity : FlutterActivity() {

    private val channelName = "io.groobee.sample/bridge"
    private val gson = Gson()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result -> handle(call, result) }
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        val g = Groobee.getInstance()
        when (call.method) {
            "configure" -> {
                // Groobee 초기화 (서비스키는 Dart 의 groobee_config.json 에서 전달받음)
                val serviceKey = call.argument<String>("serviceKey") ?: ""
                val config = GroobeeConfig.Builder()
                    .setApiKey(serviceKey)
                    .setSmallNotificationIcon(resources.getResourceName(R.drawable.ic_push))
                    .setHandlePushDeepLinks(true)
                    .setPushMoveActivityEnabled(true)
                    .setPushMoveActivityClassName(MainActivity::class.java)
                    .setNotificationSettingsButton("알림 설정", "groobeesample://setting/notification")
                    .setInAppMsgMarginTop(30)
                    .setInAppMsgMarginBottom(40)
                if (Build.VERSION.SDK_INT > Build.VERSION_CODES.N) {
                    config.setPushImportance(NotificationManager.IMPORTANCE_HIGH)
                }
                Groobee.configure(this, config.build())
                application.registerActivityLifecycleCallbacks(Groobee.getInstance().activityLifecycleCallbacks)
                LoggerUtils.setLogLevel(Log.VERBOSE)
                result.success(null)
            }
            "setServiceLogin" -> {
                g.setServiceLogin(call.argument<String>("memberId"))
                result.success(null)
            }
            "serviceLogout" -> {
                g.setServiceLogout()
                g.clearMemberData()
                result.success(null)
            }
            "setMember" -> {
                val member = mutableMapOf(
                    "id" to (call.argument<String>("id") ?: ""),
                    "grade" to (call.argument<String>("grade") ?: ""),
                    "gender" to (call.argument<String>("gender") ?: ""),
                    "age" to (call.argument<String>("age") ?: ""),
                    "type" to (call.argument<String>("type") ?: "")
                )
                g.setMember(member)
                result.success(null)
            }
            "setPushToken" -> {
                g.setPushToken(call.argument<String>("token"))
                result.success(null)
            }
            "setPushAgree" -> {
                val isAgreed = call.argument<Boolean>("isAgreed") ?: false
                when (call.argument<String>("type")) {
                    "AP" -> g.setAgreedPush(isAgreed)
                    "AA" -> g.setAgreedPushAdvertising(isAgreed)
                    "AN" -> g.setAgreedPushNight(isAgreed)
                }
                result.success(null)
            }
            "getPushAgreed" -> {
                val memberId = call.argument<String>("memberId") ?: ""
                g.getPushAgreed(memberId, object : ResultAgreeds {
                    override fun onSuccess(agreeds: Agreeds) {
                        runOnUiThread { result.success(gson.toJson(agreeds)) }
                    }
                    override fun onFailed(exceptMsg: String) {
                        runOnUiThread { result.error("GROOBEE", exceptMsg, null) }
                    }
                })
            }
            "setScreenData" -> {
                // Android 의 setScreenData 는 screenId 만 사용합니다(screenName 미사용).
                g.setScreenData(this, call.argument<String>("screenId"))
                result.success(null)
            }
            "setSearchKeyword" -> {
                g.setSearchKeyword(this, call.argument<String>("keyword"), call.argument<String>("screenId"))
                result.success(null)
            }
            "setViewGoods" -> {
                g.setViewGoods(this, goodsFromMap(call.argument("goods")), call.argument<String>("screenId"))
                result.success(null)
            }
            "setCategory" -> {
                g.setCategory(this, call.argument<String>("cateCd"), call.argument<String>("cateNm"), call.argument<String>("screenId"))
                result.success(null)
            }
            "setShoppingCart" -> {
                g.setShoppingCart(this, goodsListFromMaps(call.argument("goods")), call.argument<String>("screenId"))
                result.success(null)
            }
            "setGoodsOrder" -> {
                g.setGoodsOrder(this, goodsListFromMaps(call.argument("goods")), call.argument<String>("screenId"))
                result.success(null)
            }
            "setGoodsOrderComplete" -> {
                g.setGoodsOrderComplete(
                    this,
                    call.argument<String>("orderNo"),
                    goodsListFromMaps(call.argument("goods")),
                    call.argument<String>("screenId")
                )
                result.success(null)
            }
            "setCustomEvent" -> {
                // Android 인자 순서: (activity, eventKey, eventValue, screenId)
                g.setCustomEvent(
                    this,
                    call.argument<String>("eventKey"),
                    call.argument<String>("eventValue"),
                    call.argument<String>("screenId")
                )
                result.success(null)
            }
            "getRecommendGoods" -> {
                val campaignKey = call.argument<String>("campaignKey") ?: ""
                g.getRecommendGoods(campaignKey, object : ResultGoods {
                    override fun onSuccess(recommendData: RecommendData) {
                        val list = recommendData.goodsList ?: emptyList()
                        if (list.isNotEmpty()) {
                            // 노출/클릭 통계 전송 (데모: 첫 상품 클릭 가정)
                            g.setShowRecommendGoods(
                                recommendData.requestId, recommendData.campaignKey, recommendData.algorithmCd, list
                            )
                            g.setClickRecommendGoods(
                                recommendData.requestId, recommendData.campaignKey, recommendData.algorithmCd, list[0]
                            )
                        }
                        runOnUiThread { result.success(gson.toJson(recommendData)) }
                    }
                    override fun onFailed(exceptMsg: String, campaignKey: String) {
                        runOnUiThread { result.error("GROOBEE", exceptMsg, campaignKey) }
                    }
                })
            }
            else -> result.notImplemented()
        }
    }

    private fun goodsFromMap(map: Map<String, Any?>?): Goods {
        val m = map ?: emptyMap()
        val builder = Goods.builder()
        (m["goodsNm"] as? String)?.let { builder.goodsNm(it) }
        (m["goodsCd"] as? String)?.let { builder.goodsCd(it) }
        (m["goodsCate"] as? String)?.let { builder.goodsCate(it) }
        (m["goodsCateNm"] as? String)?.let { builder.goodsCateNm(it) }
        (m["goodsImg"] as? String)?.let { builder.goodsImg(it) }
        // Dart int → Android Long(prc/salePrc/amt), Int(cnt)
        (m["goodsPrc"] as? Number)?.let { builder.goodsPrc(it.toLong()) }
        (m["goodsSalePrc"] as? Number)?.let { builder.goodsSalePrc(it.toLong()) }
        (m["goodsAmt"] as? Number)?.let { builder.goodsAmt(it.toLong()) }
        (m["goodsCnt"] as? Number)?.let { builder.goodsCnt(it.toInt()) }
        return builder.build()
    }

    private fun goodsListFromMaps(list: List<Map<String, Any?>>?): List<Goods> =
        (list ?: emptyList()).map { goodsFromMap(it) }
}

import UIKit
import GroobeeKit
import FirebaseCore
import FirebaseMessaging

/// Groobee SDK 의 주요 기능을 버튼으로 하나씩 호출해 볼 수 있는 데모 화면.
///
///  ① 회원/로그인  ② 푸시  ③ 행동 이력  ④ AI 추천
///
/// 호출 결과는 화면 하단 로그(AppLog)에 표시됩니다.
/// 실제 데이터가 서버에 쌓이려면 SampleConfig.serviceKey 를 유효한 값으로 교체해야 합니다.
final class ViewController: UIViewController, ResponseGoods, ResponseAgreeds {

    private let logTextView = UITextView()
    private var pushSwitch: SwitchRow!
    private var adSwitch: SwitchRow!
    private var nightSwitch: SwitchRow!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Groobee Sample"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "로그 지우기", style: .plain, target: self, action: #selector(clearLog)
        )

        setupUI()
        bindLog()

        // 현재 화면(홈) 진입 이력 전송
        Groobee.getInstance().setScreenData(screenName: "홈", screenId: SampleConfig.Screen.home)
        AppLog.shared.log("화면 진입: setScreenData(HOME)")
    }

    // MARK: - UI 구성

    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        configureLogTextView()
        view.addSubview(logTextView)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

        // 상태 표시
        let status = UILabel()
        status.numberOfLines = 0
        status.font = .systemFont(ofSize: 13)
        status.textColor = .secondaryLabel
        status.text = statusText()
        stack.addArrangedSubview(status)

        // ① 회원 / 로그인
        stack.addArrangedSubview(sectionLabel("① 회원 / 로그인"))
        stack.addArrangedSubview(ActionButton(title: "로그인 (setServiceLogin)") { [weak self] in self?.login() })
        stack.addArrangedSubview(ActionButton(title: "회원정보 설정 (setUserInfo)") { [weak self] in self?.setMember() })
        stack.addArrangedSubview(ActionButton(title: "회원가입 완료 (setMemberJoin)") { [weak self] in self?.signup() })
        stack.addArrangedSubview(ActionButton(title: "동의상태 동기화 (syncMemberAgreed)") { [weak self] in self?.syncAgreed() })
        stack.addArrangedSubview(ActionButton(title: "로그아웃 (serviceLogout)") { [weak self] in self?.logout() })

        // ② 푸시
        stack.addArrangedSubview(sectionLabel("② 푸시 (Push)"))
        stack.addArrangedSubview(ActionButton(title: "FCM 토큰 조회/전송 (setPushToken)") { [weak self] in self?.requestFcmToken() })

        pushSwitch = SwitchRow(title: "전체 푸시 동의 (setPushAgreeAP)") { isOn in
            Groobee.getInstance().setPushAgreeAP(isPushAgreedAP: isOn)
            AppLog.shared.log("전체 푸시 동의: setPushAgreeAP(\(isOn))")
        }
        adSwitch = SwitchRow(title: "광고 푸시 동의 (setPushAgreeAA)") { isOn in
            Groobee.getInstance().setPushAgreeAA(isPushAgreedAA: isOn)
            AppLog.shared.log("광고 푸시 동의: setPushAgreeAA(\(isOn))")
        }
        nightSwitch = SwitchRow(title: "야간 푸시 동의 (setPushAgreeAN)") { isOn in
            Groobee.getInstance().setPushAgreeAN(isPushAgreedAN: isOn)
            AppLog.shared.log("야간 푸시 동의: setPushAgreeAN(\(isOn))")
        }
        stack.addArrangedSubview(pushSwitch)
        stack.addArrangedSubview(adSwitch)
        stack.addArrangedSubview(nightSwitch)
        stack.addArrangedSubview(ActionButton(title: "동의 상태 조회 (getPushAgreed)") { [weak self] in self?.queryConsent() })

        // ③ 행동 이력
        stack.addArrangedSubview(sectionLabel("③ 행동 이력 (Actions)"))
        stack.addArrangedSubview(ActionButton(title: "검색 (setSearchKeyword)") { [weak self] in self?.search() })
        stack.addArrangedSubview(ActionButton(title: "상품 상세 보기 (setViewGoods)") { [weak self] in self?.viewGoods() })
        stack.addArrangedSubview(ActionButton(title: "카테고리 보기 (setCategory)") { [weak self] in self?.category() })
        stack.addArrangedSubview(ActionButton(title: "장바구니 (setShoppingCart)") { [weak self] in self?.cart() })
        stack.addArrangedSubview(ActionButton(title: "주문서 (setGoodsOrder)") { [weak self] in self?.order() })
        stack.addArrangedSubview(ActionButton(title: "주문 완료 (setGoodsOrderComplete)") { [weak self] in self?.orderComplete() })
        stack.addArrangedSubview(ActionButton(title: "커스텀 이벤트 (setCustomEvent)") { [weak self] in self?.customEvent() })

        // ④ AI 추천
        stack.addArrangedSubview(sectionLabel("④ AI 추천 (Recommend)"))
        stack.addArrangedSubview(ActionButton(title: "추천 상품 요청 (getRecommendGoods)") { [weak self] in self?.requestRecommend() })

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: logTextView.topAnchor),

            logTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            logTextView.heightAnchor.constraint(equalToConstant: 220),

            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }

    private func configureLogTextView() {
        logTextView.translatesAutoresizingMaskIntoConstraints = false
        logTextView.isEditable = false
        logTextView.backgroundColor = UIColor(white: 0.11, alpha: 1)
        logTextView.textColor = UIColor(white: 0.88, alpha: 1)
        logTextView.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        logTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    private func bindLog() {
        logTextView.text = AppLog.shared.text
        AppLog.shared.onUpdate = { [weak self] text in
            self?.logTextView.text = text
        }
    }

    private func sectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = UIColor(red: 0.19, green: 0.25, blue: 0.62, alpha: 1)
        return label
    }

    private func statusText() -> String {
        let key = SampleConfig.isServiceKeyConfigured ? "설정됨" : "⚠️ 미설정 (placeholder)"
        return "서비스키: \(key)\n데모 회원ID: \(SampleConfig.demoMemberId)"
    }

    @objc private func clearLog() { AppLog.shared.clear() }

    // MARK: - ① 회원 / 로그인

    private func login() {
        Groobee.getInstance().setServiceLogin(memberId: SampleConfig.demoMemberId)
        AppLog.shared.log("로그인: setServiceLogin(\(SampleConfig.demoMemberId))")
    }

    private func setMember() {
        // setUserInfo 인자 순서: id, grade, age, gender, type
        Groobee.getInstance().setUserInfo(
            id: SampleConfig.demoMemberId,
            grade: "VIP",
            age: "30",
            gender: "M",
            type: "general"
        )
        AppLog.shared.log("회원정보: setUserInfo(id, grade, age, gender, type)")
    }

    private func signup() {
        Groobee.getInstance().setMemberJoin(
            memberId: SampleConfig.demoMemberId,
            screenId: SampleConfig.Screen.signUp
        )
        AppLog.shared.log("회원가입 완료: setMemberJoin(...)")
    }

    private func syncAgreed() {
        Groobee.getInstance().syncMemberAgreed(memberId: SampleConfig.demoMemberId)
        AppLog.shared.log("동의상태 동기화: syncMemberAgreed(...)")
    }

    private func logout() {
        Groobee.getInstance().serviceLogout()
        Groobee.getInstance().memberDataClear()
        AppLog.shared.log("로그아웃: serviceLogout() + memberDataClear()")
    }

    // MARK: - ② 푸시

    private func requestFcmToken() {
        guard FirebaseApp.app() != nil else {
            AppLog.shared.log("Firebase 미구성: GoogleService-Info.plist 를 추가하세요.")
            return
        }
        Messaging.messaging().token { token, error in
            if let token = token {
                Groobee.getInstance().setPushToken(pushToken: token)
                AppLog.shared.log("FCM 토큰 → setPushToken(): \(String(token.prefix(24)))…")
            } else {
                AppLog.shared.log("FCM 토큰 조회 실패: \(error?.localizedDescription ?? "-")")
            }
        }
    }

    private func queryConsent() {
        Groobee.getInstance().getPushAgreed(memberId: SampleConfig.demoMemberId, responseAgreeds: self)
        AppLog.shared.log("동의 상태 조회 요청: getPushAgreed(...)")
    }

    // MARK: - ③ 행동 이력

    private func search() {
        Groobee.getInstance().setSearchKeyword(searchKwd: "겨울 패딩", screenId: SampleConfig.Screen.search)
        AppLog.shared.log("검색: setSearchKeyword(\"겨울 패딩\")")
    }

    private func viewGoods() {
        let goods = DemoData.sampleGoods()
        Groobee.getInstance().setViewGoods(goods: goods, screenId: SampleConfig.Screen.productDetail)
        AppLog.shared.log("상품 상세: setViewGoods(\(goods.goodsNm ?? "-"))")
    }

    private func category() {
        Groobee.getInstance().setCategory(cateCd: "C99", cateNm: "티셔츠", screenId: SampleConfig.Screen.category)
        AppLog.shared.log("카테고리: setCategory(C99, 티셔츠)")
    }

    private func cart() {
        let cart = DemoData.sampleCart()
        Groobee.getInstance().setShoppingCart(goods: cart, screenId: SampleConfig.Screen.cart)
        AppLog.shared.log("장바구니: setShoppingCart(\(cart.count)개)")
    }

    private func order() {
        let cart = DemoData.sampleCart()
        Groobee.getInstance().setGoodsOrder(goods: cart, screenId: SampleConfig.Screen.order)
        AppLog.shared.log("주문서: setGoodsOrder(\(cart.count)개)")
    }

    private func orderComplete() {
        let cart = DemoData.sampleCart()
        Groobee.getInstance().setGoodsOrderComplete(
            orderNo: "ORD-20260609-0001",
            goods: cart,
            screenId: SampleConfig.Screen.orderComplete
        )
        AppLog.shared.log("주문 완료: setGoodsOrderComplete(ORD-20260609-0001, \(cart.count)개)")
    }

    private func customEvent() {
        // setCustomEvent 인자 순서: eventKey, screenId, eventValue
        Groobee.getInstance().setCustomEvent(
            eventKey: "wishlist_add",
            screenId: SampleConfig.Screen.home,
            eventValue: "0011"
        )
        AppLog.shared.log("커스텀 이벤트: setCustomEvent(wishlist_add, 0011)")
    }

    // MARK: - ④ AI 추천

    private func requestRecommend() {
        AppLog.shared.log("추천 요청: getRecommendGoods(\(SampleConfig.recommendCampaignKey))")
        Groobee.getInstance().getRecommendGoods(
            campaignKey: SampleConfig.recommendCampaignKey,
            responseGoods: self
        )
    }

    // ResponseGoods
    func onSuccess(aiRecommend: ArtificialRecommend) {
        let list = aiRecommend.getRecommendList() ?? []
        let campaignKey = aiRecommend.getCampaignKey() ?? ""
        let algorithmCd = aiRecommend.getAlgorithmCd() ?? ""
        let requestId = aiRecommend.getRequestId() ?? ""

        AppLog.shared.log("추천 응답: \(list.count)개 (algorithmCd=\(algorithmCd))")
        for (i, g) in list.prefix(5).enumerated() {
            AppLog.shared.log("  #\(i + 1) \(g.goodsNm ?? "-") (\(g.goodsCd ?? "-"))")
        }

        guard !list.isEmpty, !campaignKey.isEmpty, !algorithmCd.isEmpty else { return }

        // 추천 상품이 화면에 노출됨 → 노출 통계
        Groobee.getInstance().setShowRecommendGoods(
            goods: list, campaignKey: campaignKey, algorithmCd: algorithmCd, requestId: requestId
        )
        AppLog.shared.log("노출 통계 전송: setShowRecommendGoods()")

        // (데모) 첫 번째 추천 상품 클릭 가정 → 클릭 통계
        if let first = list.first {
            Groobee.getInstance().setClickRecommendGoods(
                goods: first, campaignKey: campaignKey, algorithmCd: algorithmCd, requestId: requestId
            )
            AppLog.shared.log("클릭 통계 전송: setClickRecommendGoods(\(first.goodsNm ?? "-"))")
        }
    }

    func onFailed(exceptionMsg: String, campaignKey: String) {
        AppLog.shared.log("추천 실패: \(exceptionMsg) (campaignKey=\(campaignKey))")
    }

    // ResponseAgreeds
    func onSuccess(agreeds: Agreeds) {
        DispatchQueue.main.async {
            // 프로그래매틱으로 isOn 을 바꾸면 valueChanged 가 발생하지 않으므로 안전합니다.
            self.pushSwitch.toggle.isOn = agreeds.agreedAP
            self.adSwitch.toggle.isOn = agreeds.agreedAA
            self.nightSwitch.toggle.isOn = agreeds.agreedAN
        }
        AppLog.shared.log("동의상태: AP=\(agreeds.agreedAP), AA=\(agreeds.agreedAA), AN=\(agreeds.agreedAN)")
    }

    func onFailed(exceptionMsg: String) {
        AppLog.shared.log("동의상태 조회 실패: \(exceptionMsg)")
    }
}

// MARK: - 데모용 UI 컴포넌트

/// 클로저로 동작을 지정할 수 있는 버튼
final class ActionButton: UIButton {
    private let handler: () -> Void

    init(title: String, handler: @escaping () -> Void) {
        self.handler = handler
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel?.numberOfLines = 0
        contentHorizontalAlignment = .leading
        backgroundColor = UIColor(red: 0.247, green: 0.318, blue: 0.710, alpha: 1)
        layer.cornerRadius = 8
        contentEdgeInsets = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    @objc private func didTap() { handler() }
}

/// 라벨 + 스위치 한 줄
final class SwitchRow: UIView {
    let toggle = UISwitch()
    private let handler: (Bool) -> Void

    init(title: String, isOn: Bool = false, handler: @escaping (Bool) -> Void) {
        self.handler = handler
        super.init(frame: .zero)

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        toggle.isOn = isOn
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(valueChanged), for: .valueChanged)

        addSubview(label)
        addSubview(toggle)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: toggle.leadingAnchor, constant: -12),
            toggle.trailingAnchor.constraint(equalTo: trailingAnchor),
            toggle.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            toggle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    @objc private func valueChanged() { handler(toggle.isOn) }
}

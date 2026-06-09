import Foundation
import GroobeeKit

/// 데모 화면 하단에 SDK 호출 결과를 보여주기 위한 단순 로그 버스.
/// 실제 앱에는 필요 없으며, 어떤 SDK 메소드가 호출됐는지 확인하기 위한 용도입니다.
final class AppLog {

    static let shared = AppLog()

    private(set) var text: String = ""
    /// 로그가 갱신될 때 UI 가 구독하는 콜백
    var onUpdate: ((String) -> Void)?

    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f
    }()

    func log(_ message: String) {
        print("GroobeeSample: \(message)")
        DispatchQueue.main.async {
            let line = "[\(self.formatter.string(from: Date()))] \(message)\n"
            self.text = line + self.text
            self.onUpdate?(self.text)
        }
    }

    func clear() {
        DispatchQueue.main.async {
            self.text = ""
            self.onUpdate?("")
        }
    }
}

/// (선택) Groobee SDK 내부 로그를 받는 콜백.
/// AppDelegate 에서 LoggerUtils.setLogCallback 으로 등록합니다.
final class GroobeeSampleLogger: NSObject, GroobeeLogCallback {
    func onLog(level: Int, tag: String, message: String) {
        // 콘솔로만 출력 (화면 로그가 너무 시끄러워지지 않도록)
        print("Groobee[\(tag)] \(message)")
    }
}

import Foundation
import CryptoKit

struct DoubleSHA256 {
    static func hash(data: Data) -> Data {
        let sha256 = Data(SHA256.hash(data: data))
        return Data(SHA256.hash(data: sha256))
    }
    private init() {}
}

import Foundation
import CryptoKit
import RIPEMD160

struct Hash160 {
    static func hash(data: Data) -> Data {
        let sha256 = Data(SHA256.hash(data: data))
        return RIPEMD160.hash(data: sha256)
    }
    private init() {}
}

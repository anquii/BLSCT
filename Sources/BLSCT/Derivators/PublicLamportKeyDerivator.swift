import Foundation
import CryptoKit

public protocol PublicLamportKeyDerivating {
    func publicKey(privateKey: [Data]) -> [Data]
}

public struct PublicLamportKeyDerivator {
    public init() {}
}

// MARK: - PublicLamportKeyDerivating
extension PublicLamportKeyDerivator: PublicLamportKeyDerivating {
    public func publicKey(privateKey: [Data]) -> [Data] {
        privateKey.map { Data(SHA256.hash(data: $0)) }
    }
}

import Foundation

public protocol PrivateBLSMasterKeyDerivating {
    func privateKey(base58CheckEncodedPrivateMasterKey: String) throws -> Data
}

public struct PrivateBLSMasterKeyDerivator {
    private let privateBLSKeyDerivator: PrivateBLSKeyDerivating

    public init(privateBLSKeyDerivator: PrivateBLSKeyDerivating = PrivateBLSKeyDerivator()) {
        self.privateBLSKeyDerivator = privateBLSKeyDerivator
    }
}

// MARK: - PrivateBLSMasterKeyDerivating
extension PrivateBLSMasterKeyDerivator: PrivateBLSMasterKeyDerivating {
    public func privateKey(base58CheckEncodedPrivateMasterKey: String) throws -> Data {
        let privateMasterKeyLengthByte = UInt8(base58CheckEncodedPrivateMasterKey.count)
        let privateMasterKeyWithPrependedLength = Data(privateMasterKeyLengthByte.bytes + base58CheckEncodedPrivateMasterKey.bytes)
        let privateMasterKeyData = DoubleSHA256.hash(data: privateMasterKeyWithPrependedLength)
        return try privateBLSKeyDerivator.privateKey(data: privateMasterKeyData)
    }
}

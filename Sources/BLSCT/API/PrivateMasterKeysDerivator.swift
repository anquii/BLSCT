import Foundation
import ERC2333

public protocol PrivateMasterKeysDerivating {
    func privateMasterKeys(seed: Data) -> PrivateMasterKeys
}

public struct PrivateMasterKeysDerivator {
    private let privateMasterKeyDerivator: PrivateMasterKeyDerivating = PrivateMasterKeyDerivator()
    private let privateChildKeyDerivator: PrivateChildKeyDerivating = PrivateChildKeyDerivator()

    public init() {}
}

// MARK: - PrivateMasterKeysDerivating
extension PrivateMasterKeysDerivator: PrivateMasterKeysDerivating {
    public func privateMasterKeys(seed: Data) -> PrivateMasterKeys {
        let privateMasterKey = privateMasterKeyDerivator.privateKey(seed: seed)
        let privateChildKey = privateChildKeyDerivator.privateKey(privateParentKey: privateMasterKey, index: 130)
        let privateTransactionKey = privateChildKeyDerivator.privateKey(privateParentKey: privateChildKey, index: 0)
        let privateViewKey = privateChildKeyDerivator.privateKey(privateParentKey: privateTransactionKey, index: 0)
        let privateSpendKey = privateChildKeyDerivator.privateKey(privateParentKey: privateTransactionKey, index: 1)
        let privateTokenKey = privateChildKeyDerivator.privateKey(privateParentKey: privateChildKey, index: 2)
        return PrivateMasterKeys(privateViewKey: privateViewKey, privateSpendKey: privateSpendKey, privateTokenKey: privateTokenKey)
    }
}

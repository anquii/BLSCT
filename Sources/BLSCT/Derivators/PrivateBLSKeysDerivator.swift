import Foundation

public protocol PrivateBLSKeysDerivating {
    func privateKeys(
        base58CheckEncodedPrivateMasterKey: String
    ) throws -> (
        privateBLSViewKey: Data,
        privateBLSSpendKey: Data,
        privateBLSBlindingKey: Data
    )
}

public struct PrivateBLSKeysDerivator {
    private let privateBLSMasterKeyDerivator: PrivateBLSMasterKeyDerivating
    private let privateBLSChildKeyDerivator: PrivateBLSChildKeyDerivating
    private let keyIndexHardener: KeyIndexHardening

    public init(
        privateBLSMasterKeyDerivator: PrivateBLSMasterKeyDerivating,
        privateBLSChildKeyDerivator: PrivateBLSChildKeyDerivating,
        keyIndexHardener: KeyIndexHardening = KeyIndexHardener()
    ) {
        self.privateBLSMasterKeyDerivator = privateBLSMasterKeyDerivator
        self.privateBLSChildKeyDerivator = privateBLSChildKeyDerivator
        self.keyIndexHardener = keyIndexHardener
    }
}

// MARK: - PrivateBLSKeysDerivating
extension PrivateBLSKeysDerivator: PrivateBLSKeysDerivating {
    public func privateKeys(
        base58CheckEncodedPrivateMasterKey: String
    ) throws -> (
        privateBLSViewKey: Data,
        privateBLSSpendKey: Data,
        privateBLSBlindingKey: Data
    ) {
        let privateBLSMasterKey = try privateBLSMasterKeyDerivator.privateKey(
            base58CheckEncodedPrivateMasterKey: base58CheckEncodedPrivateMasterKey
        )
        let privateBLSChildKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: 130)
        let privateBLSChildKey = try privateBLSChildKeyDerivator.privateKey(
            privateBLSParentKey: privateBLSMasterKey,
            index: privateBLSChildKeyIndex
        )
        let privateBLSTransactionKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: 0)
        let privateBLSTransactionKey = try privateBLSChildKeyDerivator.privateKey(
            privateBLSParentKey: privateBLSChildKey,
            index: privateBLSTransactionKeyIndex
        )
        let privateBLSBlindingKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: 1)
        let privateBLSBlindingKey = try privateBLSChildKeyDerivator.privateKey(
            privateBLSParentKey: privateBLSChildKey,
            index: privateBLSBlindingKeyIndex
        )
        let privateBLSViewKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: 0)
        let privateBLSViewKey = try privateBLSChildKeyDerivator.privateKey(
            privateBLSParentKey: privateBLSTransactionKey,
            index: privateBLSViewKeyIndex
        )
        let privateBLSSpendKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: 1)
        let privateBLSSpendKey = try privateBLSChildKeyDerivator.privateKey(
            privateBLSParentKey: privateBLSTransactionKey,
            index: privateBLSSpendKeyIndex
        )
        return (privateBLSViewKey, privateBLSSpendKey, privateBLSBlindingKey)
    }
}

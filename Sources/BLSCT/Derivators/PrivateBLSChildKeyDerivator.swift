import Foundation
import CryptoKit
import MCLSwiftWrapper

public protocol PrivateBLSChildKeyDerivating {
    func privateKey(privateBLSParentKey: Data, index: UInt32) throws -> Data
}

public struct PrivateBLSChildKeyDerivator {
    private static let keyLength = 32

    private let privateBLSKeyDerivator: PrivateBLSKeyDerivating
    private let privateLamportKeyDerivator: PrivateLamportKeyDerivating
    private let publicLamportKeyDerivator: PublicLamportKeyDerivating
    private let mclPreparator: MCLPreparing

    public init(
        privateBLSKeyDerivator: PrivateBLSKeyDerivating = PrivateBLSKeyDerivator(),
        privateLamportKeyDerivator: PrivateLamportKeyDerivating = PrivateLamportKeyDerivator(),
        publicLamportKeyDerivator: PublicLamportKeyDerivating = PublicLamportKeyDerivator(),
        mclPreparator: MCLPreparing = MCLPreparator()
    ) throws {
        try mclPreparator.prepareMCL()
        self.privateBLSKeyDerivator = privateBLSKeyDerivator
        self.privateLamportKeyDerivator = privateLamportKeyDerivator
        self.publicLamportKeyDerivator = publicLamportKeyDerivator
        self.mclPreparator = mclPreparator
    }
}

// MARK: - PrivateBLSChildKeyDerivating
extension PrivateBLSChildKeyDerivator: PrivateBLSChildKeyDerivating {
    public func privateKey(privateBLSParentKey: Data, index: UInt32) throws -> Data {
        guard index >= KeyIndexRange.normal.lowerBound, index <= KeyIndexRange.hardened.upperBound else {
            throw KeyIndexError.invalidIndex
        }
        let salt = Data(index.bytes)
        let privateLamportKey = privateLamportKeyDerivator.privateKey(privateBLSKey: privateBLSParentKey, salt: salt)
        let publicLamportKey = publicLamportKeyDerivator.publicKey(privateKey: privateLamportKey)
        let concatenatedPublicLamportKey = publicLamportKey.reduce(Data(), +)
        let concatenatedPublicLamportKeySHA256 = Data(SHA256.hash(data: concatenatedPublicLamportKey))
        let privateBLSChildKey = try privateBLSKeyDerivator.privateKey(data: concatenatedPublicLamportKeySHA256)
        var privateBLSChildKeyFr = mclBnFr()
        var privateBLSChildKeyBigEndianModBytes = [UInt8](repeating: 0, count: Self.keyLength)
        guard
            mclBnFr_setBigEndianMod(&privateBLSChildKeyFr, privateBLSChildKey.bytes, privateBLSChildKey.count) == 0,
            mclBnFr_isValid(&privateBLSChildKeyFr) == 1,
            mclBnFr_serialize(&privateBLSChildKeyBigEndianModBytes, Self.keyLength, &privateBLSChildKeyFr) != 0
        else {
            throw KeyDerivatorError.invalidDerivation
        }
        return Data(privateBLSChildKeyBigEndianModBytes)
    }
}

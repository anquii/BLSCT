import Foundation
import MCLSwiftWrapper

public protocol PublicBLSKeysDerivating {
    func publicKeys(accountIndex: UInt64, subAddressIndex: UInt64) throws -> (publicBLSViewKey: Data, publicBLSSpendKey: Data)
}

public final class PublicBLSKeysDerivator {
    private static let privateKeyLength = 32
    private static let publicKeyLength = 48
    private static let subAddressPrefix = "SubAddress"
    private static let hexEncodedGeneratorPointG1 = "97f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb"

    private let privateBLSViewKey: Data
    private var privateBLSViewKeyFr = mclBnFr()
    private var privateBLSSpendKeyFr = mclBnFr()
    private var generatorPointG1 = mclBnG1()
    private let mclPreparator: MCLPreparing

    private lazy var privateBLSViewKeyLengthByte = UInt8(privateBLSViewKey.count)
    private lazy var subAddressPrefixLengthByte = UInt8(Self.subAddressPrefix.count)

    public init(
        privateBLSViewKey: Data,
        privateBLSSpendKey: Data,
        mclPreparator: MCLPreparing = MCLPreparator()
    ) throws {
        try mclPreparator.prepareMCL()
        let serializedGeneratorPointG1 = Data(hex: Self.hexEncodedGeneratorPointG1)
        guard
            privateBLSViewKey.count == Self.privateKeyLength,
            privateBLSSpendKey.count == Self.privateKeyLength,
            mclBnFr_setBigEndianMod(&privateBLSViewKeyFr, privateBLSViewKey.bytes, privateBLSViewKey.count) == 0,
            mclBnFr_setBigEndianMod(&privateBLSSpendKeyFr, privateBLSSpendKey.bytes, privateBLSSpendKey.count) == 0,
            mclBnG1_deserialize(&generatorPointG1, serializedGeneratorPointG1.bytes, serializedGeneratorPointG1.count) != 0
        else {
            throw KeyDerivatorError.invalidDerivation
        }
        self.privateBLSViewKey = privateBLSViewKey
        self.mclPreparator = mclPreparator
    }
}

// MARK: - PublicBLSKeysDerivating
extension PublicBLSKeysDerivator: PublicBLSKeysDerivating {
    public func publicKeys(accountIndex: UInt64, subAddressIndex: UInt64) throws -> (publicBLSViewKey: Data, publicBLSSpendKey: Data) {
        let privateBLSKeyRepresentation = Data(
            subAddressPrefixLengthByte.bytes
            + Self.subAddressPrefix.bytes
            + privateBLSViewKeyLengthByte.bytes
            + privateBLSViewKey.bytes
            + accountIndex.bytes
            + subAddressIndex.bytes
        )
        let privateBLSKeyHash = DoubleSHA256.hash(data: privateBLSKeyRepresentation)
        var privateBLSKeyFr = mclBnFr()
        var publicBLSKeyG1 = mclBnG1()
        var publicBLSViewKeyG1 = mclBnG1()
        var publicBLSSpendKeyG1Part1 = mclBnG1()
        var publicBLSSpendKeyG1Part2 = mclBnG1()
        guard mclBnFr_setBigEndianMod(&privateBLSKeyFr, privateBLSKeyHash.bytes, privateBLSKeyHash.count) == 0 else {
            throw KeyDerivatorError.invalidDerivation
        }
        mclBnG1_mul(&publicBLSKeyG1, &generatorPointG1, &privateBLSKeyFr)
        mclBnG1_mul(&publicBLSSpendKeyG1Part1, &generatorPointG1, &privateBLSSpendKeyFr)
        mclBnG1_add(&publicBLSSpendKeyG1Part2, &publicBLSKeyG1, &publicBLSSpendKeyG1Part1)
        mclBnG1_mul(&publicBLSViewKeyG1, &publicBLSSpendKeyG1Part2, &privateBLSViewKeyFr)
        return (
            try publicKey(point: publicBLSViewKeyG1),
            try publicKey(point: publicBLSSpendKeyG1Part2)
        )
    }
}

// MARK: - Helpers
fileprivate extension PublicBLSKeysDerivator {
    func publicKey(point: mclBnG1) throws -> Data {
        var mutablePoint = point
        var bytes = [UInt8](repeating: 0, count: Self.publicKeyLength)
        guard
            mclBnG1_isValid(&mutablePoint) == 1,
            mclBnG1_serialize(&bytes, Self.publicKeyLength, &mutablePoint) != 0
        else {
            throw KeyDerivatorError.invalidDerivation
        }
        return Data(bytes)
    }
}

import Foundation
import MCLSwiftWrapper

public protocol DoublePublicKeyDerivating {
    func doublePublicKey(addressIdentifier: AddressIdentifier) -> DoublePublicKey
}

public final class DoublePublicKeyDerivator {
    private let privateViewKey: Data
    private var privateViewKeyScalar: Scalar
    private var privateSpendKeyScalar: Scalar
    private static let addressPrefix = "SubAddress"

    public init(privateViewKey: Data, privateSpendKey: Data) throws {
        guard privateViewKey.count == KeyLength.private, privateSpendKey.count == KeyLength.private else {
            throw BLSCTError.invalidKeyLength
        }
        try MCL.initializeIfNeeded()
        self.privateViewKey = privateViewKey
        privateViewKeyScalar = Scalar(data: privateViewKey)
        privateSpendKeyScalar = Scalar(data: privateSpendKey)
    }
}

// MARK: - DoublePublicKeyDerivating
extension DoublePublicKeyDerivator: DoublePublicKeyDerivating {
    public func doublePublicKey(addressIdentifier: AddressIdentifier) -> DoublePublicKey {
        var mutablePrivateKey = Data()
        mutablePrivateKey += UInt8(Self.addressPrefix.count).bytes
        mutablePrivateKey += Self.addressPrefix.data(using: .ascii)!
        mutablePrivateKey += privateViewKey.bytes
        mutablePrivateKey += addressIdentifier.accountIndex.bytes
        mutablePrivateKey += addressIdentifier.addressIndex.bytes
        let privateKey = DoubleSHA256.hash(data: mutablePrivateKey)
        var privateKeyScalar = Scalar(data: privateKey)
        var publicKeyG1Point = G1Point()
        var publicViewKeyG1Point = G1Point()
        var publicSpendKeyG1PointPart1 = G1Point()
        var publicSpendKeyG1PointPart2 = G1Point()
        mclBnG1_mul(&publicKeyG1Point, &MCL.generatorG1Point, &privateKeyScalar)
        mclBnG1_mul(&publicSpendKeyG1PointPart1, &MCL.generatorG1Point, &privateSpendKeyScalar)
        mclBnG1_add(&publicSpendKeyG1PointPart2, &publicKeyG1Point, &publicSpendKeyG1PointPart1)
        mclBnG1_mul(&publicViewKeyG1Point, &publicSpendKeyG1PointPart2, &privateViewKeyScalar)
        return DoublePublicKey(
            publicViewKey: Data(g1Point: publicViewKeyG1Point),
            publicSpendKey: Data(g1Point: publicSpendKeyG1PointPart2)
        )
    }
}

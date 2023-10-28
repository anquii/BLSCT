import Foundation
import BinaryExtensions
import MCLSwiftWrapper

public protocol OutputOwnershipValidating {
    func validateOutputViewTag(_ outputViewTag: UInt16, outputPublicNonceKey: Data) throws
    func outputPublicSpendKeyHash(outputPublicSpendKey: Data, outputPublicNonceKey: Data) throws -> Data
    func outputPublicNonceKey(outputPublicBlindKey: Data) throws -> Data
}

public final class OutputOwnershipValidator {
    private var privateViewKeyScalar: Scalar

    public init(privateViewKey: Data) throws {
        guard privateViewKey.count == KeyLength.private else {
            throw BLSCTError.invalidKeyLength
        }
        try MCL.initializeIfNeeded()
        privateViewKeyScalar = Scalar(data: privateViewKey)
    }
}

// MARK: - OutputOwnershipValidating
extension OutputOwnershipValidator: OutputOwnershipValidating {
    public func validateOutputViewTag(_ outputViewTag: UInt16, outputPublicNonceKey: Data) throws {
        guard outputPublicNonceKey.count == KeyLength.public else {
            throw BLSCTError.invalidKeyLength
        }
        let outputPublicNonceKeyHash = DoubleSHA256.hash(data: outputPublicNonceKey)
        guard outputViewTag == UInt16(data: Data(outputPublicNonceKeyHash.prefix(2).reversed())) else {
            throw BLSCTError.invalidViewTag
        }
    }

    public func outputPublicSpendKeyHash(outputPublicSpendKey: Data, outputPublicNonceKey: Data) throws -> Data {
        guard outputPublicSpendKey.count == KeyLength.public, outputPublicNonceKey.count == KeyLength.public else {
            throw BLSCTError.invalidKeyLength
        }
        let outputPublicNonceKeyHash = HashWithSalt.hash(data: outputPublicNonceKey, salt: 0)
        var outputPrivateSpendKeyScalar = Scalar(data: outputPublicNonceKeyHash)
        var outputPrivateSpendKeyScalarNegated = Scalar()
        mclBnFr_neg(&outputPrivateSpendKeyScalarNegated, &outputPrivateSpendKeyScalar)
        var mutatedOutputPublicSpendKeyG1PointPart1 = G1Point()
        var mutatedOutputPublicSpendKeyG1PointPart2 = G1Point()
        var outputPublicSpendKeyG1Point = G1Point(data: outputPublicSpendKey)
        mclBnG1_mul(&mutatedOutputPublicSpendKeyG1PointPart1, &MCL.generatorG1Point, &outputPrivateSpendKeyScalarNegated)
        mclBnG1_add(&mutatedOutputPublicSpendKeyG1PointPart2, &outputPublicSpendKeyG1Point, &mutatedOutputPublicSpendKeyG1PointPart1)
        let mutatedOutputPublicSpendKey = Data(g1Point: mutatedOutputPublicSpendKeyG1PointPart2)
        return Data(Hash160.hash(data: mutatedOutputPublicSpendKey).reversed())
    }

    public func outputPublicNonceKey(outputPublicBlindKey: Data) throws -> Data {
        guard outputPublicBlindKey.count == KeyLength.public else {
            throw BLSCTError.invalidKeyLength
        }
        var outputPublicNonceKeyG1Point = G1Point()
        var outputPublicBlindKeyG1Point = G1Point(data: outputPublicBlindKey)
        mclBnG1_mul(&outputPublicNonceKeyG1Point, &outputPublicBlindKeyG1Point, &privateViewKeyScalar)
        return Data(g1Point: outputPublicNonceKeyG1Point)
    }
}

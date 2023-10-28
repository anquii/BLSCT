import Foundation
import BinaryExtensions
import MCLSwiftWrapper

public protocol OutputDataConstructing {
    func outputDataWithSigningKeys(
        address: String,
        amount: Int64,
        memo: String,
        tokenIdentifier: TokenIdentifier
    ) throws -> OutputDataWithSigningKeys
}

public final class OutputDataConstructor {
    private let addressDecoder: AddressDecoding = AddressCoder()

    public init() throws {
        try MCL.initializeIfNeeded()
    }
}

// MARK: - OutputDataConstructing
extension OutputDataConstructor: OutputDataConstructing {
    public func outputDataWithSigningKeys(
        address: String,
        amount: Int64,
        memo: String,
        tokenIdentifier: TokenIdentifier
    ) throws -> OutputDataWithSigningKeys {
        var privateBlindKeyScalar = Scalar()
        guard mclBnFr_setByCSPRNG(&privateBlindKeyScalar) == 0 else {
            preconditionFailure()
        }
        return try outputDataWithSigningKeys(
            privateBlindKeyScalar: privateBlindKeyScalar,
            address: address,
            amount: amount,
            memo: memo,
            tokenIdentifier: tokenIdentifier
        )
    }

    func outputDataWithSigningKeys(
        privateBlindKeyScalar: Scalar,
        address: String,
        amount: Int64,
        memo: String,
        tokenIdentifier: TokenIdentifier
    ) throws -> OutputDataWithSigningKeys {
        let decodedDoublePublicKey = try addressDecoder.doublePublicKey(address: address)
        var decodedPublicViewKeyG1Point = G1Point(data: decodedDoublePublicKey.publicViewKey)
        var decodedPublicSpendKeyG1Point = G1Point(data: decodedDoublePublicKey.publicSpendKey)
        var publicNonceKeyG1Point = G1Point()
        var privateBlindKeyScalar = privateBlindKeyScalar
        mclBnG1_mul(&publicNonceKeyG1Point, &decodedPublicViewKeyG1Point, &privateBlindKeyScalar)
        let publicNonceKeyHashWithSalt100 = HashWithSalt.hash(g1Point: publicNonceKeyG1Point, salt: 100)
        let privateGammaKeyScalar = Scalar(data: publicNonceKeyHashWithSalt100)
        var publicEphemeralKeyG1Point = G1Point()
        var publicBlindKeyG1Point = G1Point()
        mclBnG1_mul(&publicEphemeralKeyG1Point, &MCL.generatorG1Point, &privateBlindKeyScalar)
        mclBnG1_mul(&publicBlindKeyG1Point, &decodedPublicSpendKeyG1Point, &privateBlindKeyScalar)
        let publicNonceKeyHashWithSalt0 = HashWithSalt.hash(g1Point: publicNonceKeyG1Point, salt: 0)
        var privateSpendKeyScalar = Scalar(data: publicNonceKeyHashWithSalt0)
        var publicSpendKeyG1PointPart1 = G1Point()
        var publicSpendKeyG1PointPart2 = G1Point()
        mclBnG1_mul(&publicSpendKeyG1PointPart1, &MCL.generatorG1Point, &privateSpendKeyScalar)
        mclBnG1_add(&publicSpendKeyG1PointPart2, &decodedPublicSpendKeyG1Point, &publicSpendKeyG1PointPart1)
        var rangeProof: RangeProof?
        if tokenIdentifier.nonFungibleTokenIdentifier == .max {
            rangeProof = nil // TODO
        }
        let publicNonceKeyDoubleSHA256 = DoubleSHA256.hash(data: Data(g1Point: publicNonceKeyG1Point))
        guard let viewTag = UInt16(data: Data(publicNonceKeyDoubleSHA256.prefix(2).reversed())) else {
            preconditionFailure()
        }
        return OutputDataWithSigningKeys(
            outputData: OutputData(
                publicEphemeralKey: Data(g1Point: publicEphemeralKeyG1Point),
                publicBlindKey: Data(g1Point: publicBlindKeyG1Point),
                publicSpendKey: Data(g1Point: publicSpendKeyG1PointPart2),
                rangeProof: rangeProof,
                viewTag: viewTag
            ),
            privateBlindKey: Data(scalar: privateBlindKeyScalar),
            privateGammaKey: Data(scalar: privateGammaKeyScalar)
        )
    }
}

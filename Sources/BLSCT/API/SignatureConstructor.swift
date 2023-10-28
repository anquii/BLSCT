import Foundation
import MCLSwiftWrapper
import BLSSwiftWrapper

public protocol SignatureConstructing {
    func signature(message: Data, privateKey: Data) throws -> Data
    func balanceSignature(privateKey: Data) throws -> Data
}

public final class SignatureConstructor {
    public init() throws {
        try MCL.initializeIfNeeded()
        try BLS.initializeIfNeeded()
    }
}

// MARK: - SignatureConstructing
extension SignatureConstructor: SignatureConstructing {
    public func signature(message: Data, privateKey: Data) throws -> Data {
        guard privateKey.count == KeyLength.private else {
            throw BLSCTError.invalidKeyLength
        }
        var privateKeyScalar = Scalar(data: privateKey)
        var publicKeyG1Point = G1Point()
        mclBnG1_mul(&publicKeyG1Point, &MCL.generatorG1Point, &privateKeyScalar)
        return try blsSignature(
            dst: "BLS_SIG_BLS12381G2_XMD:SHA-256_SSWU_RO_AUG_",
            message: Data(g1Point: publicKeyG1Point) + message,
            privateKeyScalar: privateKeyScalar
        )
    }

    public func balanceSignature(privateKey: Data) throws -> Data {
        guard privateKey.count == KeyLength.private else {
            throw BLSCTError.invalidKeyLength
        }
        return try blsSignature(
            dst: "BLS_SIG_BLS12381G2_XMD:SHA-256_SSWU_RO_NUL_",
            message: "BLSCTBALANCE".data(using: .ascii)!,
            privateKeyScalar: Scalar(data: privateKey)
        )
    }
}

// MARK: - Helpers
fileprivate extension SignatureConstructor {
    func blsSignature(dst: String, message: Data, privateKeyScalar: Scalar) throws -> Data {
        mclBnG2_setDst(dst, dst.count)
        var blsSignature = BLSSwiftWrapper.blsSignature()
        var blsSecretKey = BLSSwiftWrapper.blsSecretKey(v: privateKeyScalar)
        blsSign(&blsSignature, &blsSecretKey, message.bytes, message.count)
        mclBnG2_setDst("", 0)
        return Data(g2Point: blsSignature.v)
    }
}

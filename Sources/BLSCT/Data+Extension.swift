import Foundation
import MCLSwiftWrapper

extension Data {
    /// Represents a 32-byte private key in context of BLS12-381.
    init(scalar: Scalar) {
        var mutableScalar = scalar
        var bytes = [UInt8](repeating: 0, count: KeyLength.private)
        guard
            mclBnFr_isValid(&mutableScalar) == 1, mclBnFr_isZero(&mutableScalar) == 0,
            mclBnFr_isZero(&mutableScalar) == 0,
            mclBnFr_serialize(&bytes, KeyLength.private, &mutableScalar) != 0
        else {
            preconditionFailure()
        }
        self = Data(bytes)
    }

    /// Represents a 48-byte public key in context of BLS12-381.
    init(g1Point: G1Point) {
        var mutableG1Point = g1Point
        var bytes = [UInt8](repeating: 0, count: KeyLength.public)
        guard
            mclBnG1_isValid(&mutableG1Point) == 1,
            mclBnG1_isZero(&mutableG1Point) == 0,
            mclBnG1_serialize(&bytes, KeyLength.public, &mutableG1Point) != 0
        else {
            preconditionFailure()
        }
        self = Data(bytes)
    }

    /// Represents a 96-byte signature in context of BLS12-381.
    init(g2Point: G2Point) {
        var mutableG2Point = g2Point
        var bytes = [UInt8](repeating: 0, count: 96)
        guard
            mclBnG2_isValid(&mutableG2Point) == 1,
            mclBnG2_isZero(&mutableG2Point) == 0,
            mclBnG2_serialize(&bytes, 96, &mutableG2Point) != 0
        else {
            preconditionFailure()
        }
        self = Data(bytes)
    }
}

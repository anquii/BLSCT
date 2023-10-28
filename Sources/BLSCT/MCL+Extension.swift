import Foundation
import BinaryExtensions
import MCLSwiftWrapper

extension Scalar {
    init(data: Data) {
        var scalar = Scalar()
        guard mclBnFr_setBigEndianMod(&scalar, data.bytes, data.count) == 0 else {
            preconditionFailure()
        }
        self = scalar
    }
}

extension G1Point {
    init(data: Data) {
        var g1Point = G1Point()
        guard mclBnG1_deserialize(&g1Point, data.bytes, data.count) != 0 else {
            preconditionFailure()
        }
        self = g1Point
    }
}

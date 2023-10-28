import Foundation

struct HashWithSalt {
    static func hash(data: Data, salt: UInt64) -> Data {
        var mutableData = Data()
        mutableData += data
        mutableData += salt.bytes
        return DoubleSHA256.hash(data: mutableData)
    }
    static func hash(g1Point: G1Point, salt: UInt64) -> Data {
        let data = Data(g1Point: g1Point)
        return hash(data: data, salt: salt)
    }
    private init() {}
}

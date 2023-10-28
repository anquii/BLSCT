import Foundation
import Base58Check

public protocol PrivateViewKeyEncoding {
    func base58CheckEncodedPrivateKey(privateViewKey: Data) -> String
}

public protocol PrivateViewKeyDecoding {
    func privateKey(base58CheckEncodedPrivateViewKey: String) throws -> Data
}

public typealias PrivateViewKeyCoding = PrivateViewKeyEncoding & PrivateViewKeyDecoding

public struct PrivateViewKeyCoder {
    private let base58Check: Base58CheckCoding = Base58Check()
    private static let versionBytes: [UInt8] = [0x97, 0xB5] // 151, 181
    private static let base58CheckEncodedPrivateKeyLength = 52

    public init() {}
}

// MARK: - PrivateViewKeyEncoding
extension PrivateViewKeyCoder: PrivateViewKeyEncoding {
    public func base58CheckEncodedPrivateKey(privateViewKey: Data) -> String {
        let data = Data(Self.versionBytes + privateViewKey.bytes)
        return base58Check.encode(data: data)
    }
}

// MARK: - PrivateViewKeyDecoding
extension PrivateViewKeyCoder: PrivateViewKeyDecoding {
    public func privateKey(base58CheckEncodedPrivateViewKey: String) throws -> Data {
        guard base58CheckEncodedPrivateViewKey.count == Self.base58CheckEncodedPrivateKeyLength else {
            throw BLSCTError.invalidKeyLength
        }
        let data = try base58Check.decode(string: base58CheckEncodedPrivateViewKey)
        return data[Self.versionBytes.count..<data.count]
    }
}

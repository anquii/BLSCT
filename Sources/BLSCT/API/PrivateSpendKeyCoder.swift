import Foundation
import Base58Check

public protocol PrivateSpendKeyEncoding {
    func base58CheckEncodedPrivateKey(privateSpendKey: Data) -> String
}

public protocol PrivateSpendKeyDecoding {
    func privateKey(base58CheckEncodedPrivateSpendKey: String) throws -> Data
}

public typealias PrivateSpendKeyCoding = PrivateSpendKeyEncoding & PrivateSpendKeyDecoding

public struct PrivateSpendKeyCoder {
    private let base58Check: Base58CheckCoding = Base58Check()
    private static let versionBytes: [UInt8] = [0x98, 0x14] // 152, 20
    private static let base58CheckEncodedPrivateKeyLength = 52

    public init() {}
}

// MARK: - PrivateSpendKeyEncoding
extension PrivateSpendKeyCoder: PrivateSpendKeyEncoding {
    public func base58CheckEncodedPrivateKey(privateSpendKey: Data) -> String {
        let data = Data(Self.versionBytes + privateSpendKey.bytes)
        return base58Check.encode(data: data)
    }
}

// MARK: - PrivateSpendKeyDecoding
extension PrivateSpendKeyCoder: PrivateSpendKeyDecoding {
    public func privateKey(base58CheckEncodedPrivateSpendKey: String) throws -> Data {
        guard base58CheckEncodedPrivateSpendKey.count == Self.base58CheckEncodedPrivateKeyLength else {
            throw BLSCTError.invalidKeyLength
        }
        let data = try base58Check.decode(string: base58CheckEncodedPrivateSpendKey)
        return data[Self.versionBytes.count..<data.count]
    }
}

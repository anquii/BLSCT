import Foundation
import Base58Check

public protocol PrivateBLSSpendKeyEncoding {
    func base58CheckEncodedPrivateKey(privateBLSSpendKey: Data) -> String
}

public protocol PrivateBLSSpendKeyDecoding {
    func privateKey(base58CheckEncodedPrivateBLSSpendKey: String) throws -> Data
}

public typealias PrivateBLSSpendKeyCoding = PrivateBLSSpendKeyEncoding & PrivateBLSSpendKeyDecoding

public struct PrivateBLSSpendKeyCoder {
    private static let base58CheckEncodedPrivateKeyLength = 52
    private static let versionBytes: [UInt8] = [0x98, 0x14] // 152, 20

    private let base58Check: Base58CheckCoding

    public init(base58Check: Base58CheckCoding = Base58Check()) {
        self.base58Check = base58Check
    }
}

// MARK: - PrivateBLSSpendKeyEncoding
extension PrivateBLSSpendKeyCoder: PrivateBLSSpendKeyEncoding {
    public func base58CheckEncodedPrivateKey(privateBLSSpendKey: Data) -> String {
        let data = Data(Self.versionBytes + privateBLSSpendKey.bytes)
        return base58Check.encode(data: data)
    }
}

// MARK: - PrivateBLSSpendKeyDecoding
extension PrivateBLSSpendKeyCoder: PrivateBLSSpendKeyDecoding {
    public func privateKey(base58CheckEncodedPrivateBLSSpendKey: String) throws -> Data {
        guard base58CheckEncodedPrivateBLSSpendKey.count == Self.base58CheckEncodedPrivateKeyLength else {
            throw KeyCoderError.invalidDecoding
        }
        do {
            let data = try base58Check.decode(string: base58CheckEncodedPrivateBLSSpendKey)
            return data[Self.versionBytes.count..<data.count]
        } catch {
            throw KeyCoderError.invalidDecoding
        }
    }
}

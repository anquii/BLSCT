import Foundation
import Base58Check

public protocol PrivateBLSViewKeyEncoding {
    func base58CheckEncodedPrivateKey(privateBLSViewKey: Data) -> String
}

public protocol PrivateBLSViewKeyDecoding {
    func privateKey(base58CheckEncodedPrivateBLSViewKey: String) throws -> Data
}

public typealias PrivateBLSViewKeyCoding = PrivateBLSViewKeyEncoding & PrivateBLSViewKeyDecoding

public struct PrivateBLSViewKeyCoder {
    private static let base58CheckEncodedPrivateKeyLength = 52
    private static let versionBytes: [UInt8] = [0x97, 0xB5] // 151, 181

    private let base58Check: Base58CheckCoding

    public init(base58Check: Base58CheckCoding = Base58Check()) {
        self.base58Check = base58Check
    }
}

// MARK: - PrivateBLSViewKeyEncoding
extension PrivateBLSViewKeyCoder: PrivateBLSViewKeyEncoding {
    public func base58CheckEncodedPrivateKey(privateBLSViewKey: Data) -> String {
        let data = Data(Self.versionBytes + privateBLSViewKey.bytes)
        return base58Check.encode(data: data)
    }
}

// MARK: - PrivateBLSViewKeyDecoding
extension PrivateBLSViewKeyCoder: PrivateBLSViewKeyDecoding {
    public func privateKey(base58CheckEncodedPrivateBLSViewKey: String) throws -> Data {
        guard base58CheckEncodedPrivateBLSViewKey.count == Self.base58CheckEncodedPrivateKeyLength else {
            throw KeyCoderError.invalidDecoding
        }
        do {
            let data = try base58Check.decode(string: base58CheckEncodedPrivateBLSViewKey)
            return data[Self.versionBytes.count..<data.count]
        } catch {
            throw KeyCoderError.invalidDecoding
        }
    }
}

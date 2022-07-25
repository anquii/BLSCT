import Foundation
import Base58Check

public protocol AddressEncoding {
    func address(publicBLSViewKey: Data, publicBLSSpendKey: Data) -> String
}

public protocol AddressDecoding {
    func publicBLSKeys(address: String) throws -> (publicBLSViewKey: Data, publicBLSSpendKey: Data)
}

public typealias AddressCoding = AddressEncoding & AddressDecoding

public struct AddressCoder {
    private static let addressLength = 139
    private static let publicBLSKeyLength = 48
    private static let versionBytes: [UInt8] = [0x49, 0x21] // 73, 33

    private let base58Check: Base58CheckCoding

    public init(base58Check: Base58CheckCoding = Base58Check()) {
        self.base58Check = base58Check
    }
}

// MARK: - AddressEncoding
extension AddressCoder: AddressEncoding {
    public func address(publicBLSViewKey: Data, publicBLSSpendKey: Data) -> String {
        let data = Data(Self.versionBytes + publicBLSViewKey.bytes + publicBLSSpendKey.bytes)
        return base58Check.encode(data: data)
    }
}

// MARK: - AddressDecoding
extension AddressCoder: AddressDecoding {
    public func publicBLSKeys(address: String) throws -> (publicBLSViewKey: Data, publicBLSSpendKey: Data) {
        guard address.count == Self.addressLength else {
            throw AddressCoderError.invalidAddress
        }
        do {
            let data = try base58Check.decode(string: address)
            let publicBLSViewKey = data[Self.versionBytes.count...Self.publicBLSKeyLength + 1]
            let publicBLSSpendKey = data[Self.versionBytes.count + Self.publicBLSKeyLength..<data.count]
            return (publicBLSViewKey, publicBLSSpendKey)
        } catch {
            throw AddressCoderError.invalidAddress
        }
    }
}

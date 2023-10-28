import Foundation
import Base58Check

public protocol AddressEncoding {
    func address(doublePublicKey: DoublePublicKey) -> String
}

public protocol AddressDecoding {
    func doublePublicKey(address: String) throws -> DoublePublicKey
}

public typealias AddressCoding = AddressEncoding & AddressDecoding

public struct AddressCoder {
    private let base58Check: Base58CheckCoding = Base58Check()
    private static let versionBytes: [UInt8] = [0x49, 0x21] // 73, 33
    private static let addressLength = 139

    public init() {}
}

// MARK: - AddressEncoding
extension AddressCoder: AddressEncoding {
    public func address(doublePublicKey: DoublePublicKey) -> String {
        let data = Data(Self.versionBytes + doublePublicKey.publicViewKey.bytes + doublePublicKey.publicSpendKey.bytes)
        return base58Check.encode(data: data)
    }
}

// MARK: - AddressDecoding
extension AddressCoder: AddressDecoding {
    public func doublePublicKey(address: String) throws -> DoublePublicKey {
        guard address.count == Self.addressLength else {
            throw BLSCTError.invalidAddressLength
        }
        let data = try base58Check.decode(string: address)
        let publicViewKey = data[Self.versionBytes.count...KeyLength.public + 1]
        let publicSpendKey = data[Self.versionBytes.count + KeyLength.public..<data.count]
        return DoublePublicKey(publicViewKey: publicViewKey, publicSpendKey: publicSpendKey)
    }
}

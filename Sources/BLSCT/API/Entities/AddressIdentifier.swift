public struct AddressIdentifier {
    public let accountIndex: UInt64
    public let addressIndex: UInt64

    public init(accountIndex: UInt64, addressIndex: UInt64) {
        self.accountIndex = accountIndex
        self.addressIndex = addressIndex
    }
}

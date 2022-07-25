extension PublicBLSKeysTestVector {
    struct DerivatedKeys: Decodable {
        let accountIndex: UInt64
        let subAddressIndex: UInt64
        let hexEncodedPublicBLSViewKey: String
        let hexEncodedPublicBLSSpendKey: String
    }
}

struct PublicBLSKeysTestVector: Decodable {
    let base58CheckEncodedPrivateMasterKey: String
    let hexEncodedPrivateBLSViewKey: String
    let hexEncodedPrivateBLSSpendKey: String
    let derivatedKeys: [DerivatedKeys]
}

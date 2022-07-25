struct PrivateBLSKeysTestVector: Decodable {
    let base58CheckEncodedPrivateMasterKey: String
    let hexEncodedPrivateBLSChildKey: String
    let hexEncodedPrivateBLSTransactionKey: String
    let hexEncodedPrivateBLSBlindingKey: String
    let hexEncodedPrivateBLSViewKey: String
    let hexEncodedPrivateBLSSpendKey: String
}

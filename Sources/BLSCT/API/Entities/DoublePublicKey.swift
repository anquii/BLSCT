import Foundation

public struct DoublePublicKey {
    public let publicViewKey: Data
    public let publicSpendKey: Data
    public let publicSpendKeyHash: Data

    init(publicViewKey: Data, publicSpendKey: Data) {
        self.publicViewKey = publicViewKey
        self.publicSpendKey = publicSpendKey
        publicSpendKeyHash = Data(Hash160.hash(data: publicSpendKey).reversed())
    }
}

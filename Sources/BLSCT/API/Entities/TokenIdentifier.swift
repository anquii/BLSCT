import BigInt

public struct TokenIdentifier {
    public let fungibleTokenIdentifier: BigUInt
    public let nonFungibleTokenIdentifier: UInt64

    /// `nonFungibleTokenIdentifier` defaults to `UInt64.max` to indicate it's not in use.
    public init(fungibleTokenIdentifier: BigUInt, nonFungibleTokenIdentifier: UInt64 = .max) {
        self.fungibleTokenIdentifier = fungibleTokenIdentifier
        self.nonFungibleTokenIdentifier = nonFungibleTokenIdentifier
    }
}

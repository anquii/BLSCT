import Foundation

public struct OutputData {
    public let publicEphemeralKey: Data
    public let publicBlindKey: Data
    public let publicSpendKey: Data
    public let rangeProof: RangeProof?
    public let viewTag: UInt16
}

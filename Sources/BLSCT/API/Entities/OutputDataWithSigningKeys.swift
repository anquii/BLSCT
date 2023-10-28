import Foundation

public struct OutputDataWithSigningKeys {
    public let outputData: OutputData
    public let privateBlindKey: Data
    public let privateGammaKey: Data
}

import Foundation
import CryptoKit

public protocol PrivateLamportKeyDerivating {
    func privateKey(privateBLSKey: Data, salt: Data) -> [Data]
}

public struct PrivateLamportKeyDerivator {
    private static let outputByteCount = 8160
    private static let outputByteSegments = 32

    public init() {}
}

// MARK: - PrivateLamportKeyDerivating
extension PrivateLamportKeyDerivator: PrivateLamportKeyDerivating {
    public func privateKey(privateBLSKey: Data, salt: Data) -> [Data] {
        let setA = privateKeySet(inputKeyMaterial: privateBLSKey, salt: salt)
        let invertedInputKeyMaterial = Data(privateBLSKey.map { ~$0 })
        let setB = privateKeySet(inputKeyMaterial: invertedInputKeyMaterial, salt: salt)
        return setA + setB
    }
}

// MARK: - Helpers
fileprivate extension PrivateLamportKeyDerivator {
    func privateKeySet(inputKeyMaterial: Data, salt: Data) -> [Data] {
        let pseudoRandomKey = HKDF<SHA256>.extract(inputKeyMaterial: SymmetricKey(data: inputKeyMaterial), salt: salt)
        let outputKeyMaterial = HKDF<SHA256>.expand(pseudoRandomKey: pseudoRandomKey, info: [], outputByteCount: Self.outputByteCount)
        let outputKeyMaterialData = outputKeyMaterial.withUnsafeBytes { Data($0) }

        var slicedData = [Data]()
        for i in 0..<(outputKeyMaterialData.count / Self.outputByteSegments) {
            let startIndex = outputKeyMaterialData.index(outputKeyMaterialData.startIndex, offsetBy: i * Self.outputByteSegments)
            let endIndex = outputKeyMaterialData.index(startIndex, offsetBy: Self.outputByteSegments)
            slicedData.append(outputKeyMaterialData[startIndex..<endIndex])
        }
        return slicedData
    }
}

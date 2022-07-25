import Foundation
import CryptoKit
import BigInt

public protocol PrivateBLSKeyDerivating {
    func privateKey(data: Data) throws -> Data
}

public struct PrivateBLSKeyDerivator {
    private static let keyLength = 32
    private static let outputByteCount = 48
    private static let saltConstant = "BLS-SIG-KEYGEN-SALT-"

    public init() {}
}

// MARK: - PrivateBLSKeyDerivating
extension PrivateBLSKeyDerivator: PrivateBLSKeyDerivating {
    public func privateKey(data: Data) throws -> Data {
        do {
            let inputKeyMaterial = SymmetricKey(data: data + [UInt8(0)])
            let salt = Self.saltConstant.data(using: .ascii)!
            let pseudoRandomKey = HKDF<SHA256>.extract(inputKeyMaterial: inputKeyMaterial, salt: salt)
            let outputKeyMaterial = HKDF<SHA256>.expand(
                pseudoRandomKey: pseudoRandomKey,
                info: [UInt8(0), UInt8(Self.outputByteCount)],
                outputByteCount: Self.outputByteCount
            )
            let outputKeyMaterialData = outputKeyMaterial.withUnsafeBytes { Data($0) }
            let bigIntegerKey = BigUInt(outputKeyMaterialData)
            let bigIntegerKeyModCurveOrder = bigIntegerKey % .BLS12381CurveOrder
            guard !bigIntegerKeyModCurveOrder.isZero else {
                throw KeyDerivatorError.invalidDerivation
            }
            let serializedKey = bigIntegerKeyModCurveOrder.serialize()
            if serializedKey.count == Self.keyLength {
                return serializedKey
            } else {
                let leadingZeros = Data(repeating: 0, count: Self.keyLength - serializedKey.count)
                return leadingZeros + serializedKey
            }
        } catch {
            throw KeyDerivatorError.invalidDerivation
        }
    }
}

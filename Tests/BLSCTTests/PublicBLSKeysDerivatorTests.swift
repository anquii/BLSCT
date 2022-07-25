import Foundation
import XCTest
import BLSCT

final class PublicBLSKeysDerivatorTests: XCTestCase {
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [PublicBLSKeysTestVector]!

    override func setUpWithError() throws {
        testVectors = try jsonDecoder.decode([PublicBLSKeysTestVector].self, from: publicBLSKeysTestData)
    }

    private func sut(privateBLSViewKey: Data, privateBLSSpendKey: Data) throws -> PublicBLSKeysDerivator {
        try .init(privateBLSViewKey: privateBLSViewKey, privateBLSSpendKey: privateBLSSpendKey)
    }

    func testGivenPrivateBLSViewKey_AndPrivateBLSSpendKey_WhenDerivatePublicBLSKeys_ThenEqualVectorKeys() throws {
        for testVector in testVectors {
            let privateBLSViewKey = Data(hex: testVector.hexEncodedPrivateBLSViewKey)
            let privateBLSSpendKey = Data(hex: testVector.hexEncodedPrivateBLSSpendKey)

            for derivatedKeys in testVector.derivatedKeys {
                let sut = try self.sut(
                    privateBLSViewKey: privateBLSViewKey,
                    privateBLSSpendKey: privateBLSSpendKey
                )
                let publicKeys = try sut.publicKeys(
                    accountIndex: derivatedKeys.accountIndex,
                    subAddressIndex: derivatedKeys.subAddressIndex
                )
                XCTAssertEqual(publicKeys.publicBLSViewKey.count, 48)
                XCTAssertEqual(publicKeys.publicBLSSpendKey.count, 48)
                XCTAssertEqual(publicKeys.publicBLSViewKey.toHexString(), derivatedKeys.hexEncodedPublicBLSViewKey)
                XCTAssertEqual(publicKeys.publicBLSSpendKey.toHexString(), derivatedKeys.hexEncodedPublicBLSSpendKey)
            }
        }
    }
}

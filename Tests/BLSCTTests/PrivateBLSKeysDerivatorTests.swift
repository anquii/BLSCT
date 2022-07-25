import Foundation
import XCTest
import BLSCT

final class PrivateBLSKeysDerivatorTests: XCTestCase {
    private let privateBLSKeyDerivator = PrivateBLSKeyDerivator()
    private var privateBLSMasterKeyDerivator: PrivateBLSMasterKeyDerivating!
    private var privateBLSChildKeyDerivator: PrivateBLSChildKeyDerivating!
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [PrivateBLSKeysTestVector]!

    override func setUpWithError() throws {
        privateBLSMasterKeyDerivator = PrivateBLSMasterKeyDerivator(privateBLSKeyDerivator: privateBLSKeyDerivator)
        privateBLSChildKeyDerivator = try PrivateBLSChildKeyDerivator(privateBLSKeyDerivator: privateBLSKeyDerivator)
        testVectors = try jsonDecoder.decode([PrivateBLSKeysTestVector].self, from: privateBLSKeysTestData)
    }

    private func sut() -> PrivateBLSKeysDerivator {
        .init(
            privateBLSMasterKeyDerivator: privateBLSMasterKeyDerivator,
            privateBLSChildKeyDerivator: privateBLSChildKeyDerivator
        )
    }

    func testGivenBase58CheckEncodedPrivateMasterKey_WhenDerivatePrivateBLSKeys_ThenEqualVectorKeys() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let privateKeys = try sut.privateKeys(
                base58CheckEncodedPrivateMasterKey: testVector.base58CheckEncodedPrivateMasterKey
            )
            XCTAssertEqual(privateKeys.privateBLSViewKey.count, 32)
            XCTAssertEqual(privateKeys.privateBLSSpendKey.count, 32)
            XCTAssertEqual(privateKeys.privateBLSBlindingKey.count, 32)
            XCTAssertEqual(privateKeys.privateBLSViewKey.toHexString(), testVector.hexEncodedPrivateBLSViewKey)
            XCTAssertEqual(privateKeys.privateBLSSpendKey.toHexString(), testVector.hexEncodedPrivateBLSSpendKey)
            XCTAssertEqual(privateKeys.privateBLSBlindingKey.toHexString(), testVector.hexEncodedPrivateBLSBlindingKey)
        }
    }
}

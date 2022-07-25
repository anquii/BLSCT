import Foundation
import XCTest
import BLSCT

final class PrivateBLSChildKeyDerivatorTests: XCTestCase {
    private let privateBLSKeyDerivator = PrivateBLSKeyDerivator()
    private var privateBLSMasterKeyDerivator: PrivateBLSMasterKeyDerivating!
    private let keyIndexHardener = KeyIndexHardener()
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [PrivateBLSKeysTestVector]!

    override func setUpWithError() throws {
        privateBLSMasterKeyDerivator = PrivateBLSMasterKeyDerivator(privateBLSKeyDerivator: privateBLSKeyDerivator)
        testVectors = try jsonDecoder.decode([PrivateBLSKeysTestVector].self, from: privateBLSKeysTestData)
    }

    private func sut() throws -> PrivateBLSChildKeyDerivator {
        try .init(privateBLSKeyDerivator: privateBLSKeyDerivator)
    }

    func testGivenPrivateParentBLSKey_WhenDerivatePrivateBLSChildKey_ThenEqualVectorKey() throws {
        let sut = try self.sut()

        for testVector in testVectors {
            let privateBLSMasterKey = try privateBLSMasterKeyDerivator.privateKey(
                base58CheckEncodedPrivateMasterKey: testVector.base58CheckEncodedPrivateMasterKey
            )
            let privateBLSChildKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: 130)
            let privateBLSChildKey = try sut.privateKey(
                privateBLSParentKey: privateBLSMasterKey,
                index: privateBLSChildKeyIndex
            )
            let privateBLSTransactionKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: 0)
            let privateBLSTransactionKey = try sut.privateKey(
                privateBLSParentKey: privateBLSChildKey,
                index: privateBLSTransactionKeyIndex
            )
            let privateBLSBlindingKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: 1)
            let privateBLSBlindingKey = try sut.privateKey(
                privateBLSParentKey: privateBLSChildKey,
                index: privateBLSBlindingKeyIndex
            )
            let privateBLSViewKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: 0)
            let privateBLSViewKey = try sut.privateKey(
                privateBLSParentKey: privateBLSTransactionKey,
                index: privateBLSViewKeyIndex
            )
            let privateBLSSpendKeyIndex = try keyIndexHardener.hardenedIndex(normalIndex: 1)
            let privateBLSSpendKey = try sut.privateKey(
                privateBLSParentKey: privateBLSTransactionKey,
                index: privateBLSSpendKeyIndex
            )
            XCTAssertEqual(privateBLSChildKey.count, 32)
            XCTAssertEqual(privateBLSTransactionKey.count, 32)
            XCTAssertEqual(privateBLSBlindingKey.count, 32)
            XCTAssertEqual(privateBLSViewKey.count, 32)
            XCTAssertEqual(privateBLSSpendKey.count, 32)
            XCTAssertEqual(privateBLSChildKey.toHexString(), testVector.hexEncodedPrivateBLSChildKey)
            XCTAssertEqual(privateBLSTransactionKey.toHexString(), testVector.hexEncodedPrivateBLSTransactionKey)
            XCTAssertEqual(privateBLSBlindingKey.toHexString(), testVector.hexEncodedPrivateBLSBlindingKey)
            XCTAssertEqual(privateBLSViewKey.toHexString(), testVector.hexEncodedPrivateBLSViewKey)
            XCTAssertEqual(privateBLSSpendKey.toHexString(), testVector.hexEncodedPrivateBLSSpendKey)
        }
    }
}

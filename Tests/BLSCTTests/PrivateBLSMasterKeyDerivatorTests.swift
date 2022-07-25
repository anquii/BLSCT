import Foundation
import XCTest
import BLSCT

final class PrivateBLSMasterKeyDerivatorTests: XCTestCase {
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [PrivateBLSMasterKeyTestVector]!

    override func setUpWithError() throws {
        testVectors = try jsonDecoder.decode([PrivateBLSMasterKeyTestVector].self, from: privateBLSMasterKeyTestData)
    }

    private func sut() -> PrivateBLSMasterKeyDerivator {
        .init()
    }

    func testGivenBase58CheckEncodedPrivateMasterKey_WhenDerivatePrivateBLSMasterKey_ThenEqualVectorKey() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let privateBLSMasterKey = try sut.privateKey(
                base58CheckEncodedPrivateMasterKey: testVector.base58CheckEncodedPrivateMasterKey
            )
            XCTAssertEqual(privateBLSMasterKey.count, 32)
            XCTAssertEqual(privateBLSMasterKey.toHexString(), testVector.hexEncodedPrivateBLSMasterKey)
        }
    }
}

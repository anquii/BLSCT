import Foundation
import XCTest
import BLSCT

final class PrivateBLSViewKeyCoderTests: XCTestCase {
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [PrivateBLSKeyCoderTestVector]!

    override func setUpWithError() throws {
        testVectors = try jsonDecoder.decode([PrivateBLSKeyCoderTestVector].self, from: privateBLSViewKeyCoderTestData)
    }

    private func sut() -> PrivateBLSViewKeyCoder {
        .init()
    }

    func testGivenPrivateBLSViewKey_WhenEncode_ThenEqualVectorKey() {
        let sut = self.sut()

        for testVector in testVectors {
            let privateBLSKey = Data(hex: testVector.hexEncodedPrivateBLSKey)
            let base58CheckEncodedPrivateBLSKey = sut.base58CheckEncodedPrivateKey(privateBLSViewKey: privateBLSKey)
            XCTAssertEqual(base58CheckEncodedPrivateBLSKey.count, 52)
            XCTAssertEqual(base58CheckEncodedPrivateBLSKey, testVector.base58CheckEncodedPrivateBLSKey)
        }
    }

    func testGivenBase58CheckEncodedPrivateBLSViewKey_WhenDecode_ThenEqualVectorKey() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let privateBLSKey = try sut.privateKey(base58CheckEncodedPrivateBLSViewKey: testVector.base58CheckEncodedPrivateBLSKey)
            XCTAssertEqual(privateBLSKey.count, 32)
            XCTAssertEqual(privateBLSKey.toHexString(), testVector.hexEncodedPrivateBLSKey)
        }
    }
}

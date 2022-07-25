import Foundation
import XCTest
import BLSCT

final class AddressCoderTests: XCTestCase {
    private let jsonDecoder = JSONDecoder()
    private var testVectors: [AddressCoderTestVector]!

    override func setUpWithError() throws {
        testVectors = try jsonDecoder.decode([AddressCoderTestVector].self, from: addressCoderTestData)
    }

    private func sut() -> AddressCoder {
        .init()
    }

    func testGivenPublicBLSKeys_WhenEncode_ThenEqualVectorAddress() {
        let sut = self.sut()

        for testVector in testVectors {
            let publicBLSViewKey = Data(hex: testVector.hexEncodedPublicBLSViewKey)
            let publicBLSSpendKey = Data(hex: testVector.hexEncodedPublicBLSSpendKey)
            let address = sut.address(publicBLSViewKey: publicBLSViewKey, publicBLSSpendKey: publicBLSSpendKey)
            XCTAssertEqual(address.count, 139)
            XCTAssertEqual(address, testVector.address)
        }
    }

    func testGivenAddress_WhenDecode_ThenEqualVectorKeys() throws {
        let sut = self.sut()

        for testVector in testVectors {
            let publicKeys = try sut.publicBLSKeys(address: testVector.address)
            XCTAssertEqual(publicKeys.publicBLSViewKey.count, 48)
            XCTAssertEqual(publicKeys.publicBLSSpendKey.count, 48)
            XCTAssertEqual(publicKeys.publicBLSViewKey.toHexString(), testVector.hexEncodedPublicBLSViewKey)
            XCTAssertEqual(publicKeys.publicBLSSpendKey.toHexString(), testVector.hexEncodedPublicBLSSpendKey)
        }
    }
}

import XCTest
import Foundation
import BinaryExtensions
import BLSCT

final class PrivateSpendKeyCoderTests: XCTestCase {
    private func sut() -> PrivateSpendKeyCoder {
        .init()
    }

    func testGivenPrivateSpendKey_WhenEncode_ThenEqualVectorKey() {
        let privateKey = Data(hexEncodedString: "6063199b4c1460d7e9715883e2c053ffecddc0a663cdf2276c7244b590abf577")!
        let base58CheckEncodedPrivateKey = sut().base58CheckEncodedPrivateKey(privateSpendKey: privateKey)
        XCTAssertEqual(base58CheckEncodedPrivateKey, "PVpTF91dgTqJyxUmi2ELKWqe5vHH1iRQFtEQzavgbLbZk3M7bXoK")
    }

    func testGivenBase58CheckEncodedPrivateSpendKey_WhenDecode_ThenEqualVectorKey() throws {
        let privateKey = try sut().privateKey(base58CheckEncodedPrivateSpendKey: "PVpTF91dgTqJyxUmi2ELKWqe5vHH1iRQFtEQzavgbLbZk3M7bXoK")
        XCTAssertEqual(privateKey.hexEncodedString(), "6063199b4c1460d7e9715883e2c053ffecddc0a663cdf2276c7244b590abf577")
    }
}

import XCTest
import Foundation
import BinaryExtensions
import BLSCT

final class PrivateMasterKeysDerivatorTests: XCTestCase {
    private func sut() -> PrivateMasterKeysDerivator {
        .init()
    }

    func testGivenSeed_WhenDerivatePrivateMasterKeys_ThenEqualVectorKeys() {
        let seed = Data(hexEncodedString: "0xc55257c360c07c72029aebc1b53c05ed0362ada38ead3e3e9efa3708e53495531f09a6987599d18264c1e1c92f2cf141630c7a3c4ab7c81b2f001698e7463b04")!
        let privateMasterKeys = sut().privateMasterKeys(seed: seed)
        XCTAssertEqual(privateMasterKeys.privateViewKey.hexEncodedString(), "2c12e402aee1c7afb1dc32f1040bf4f14db8200ce4b97e95e85fc3e0edb713d")
        XCTAssertEqual(privateMasterKeys.privateSpendKey.hexEncodedString(), "6063199b4c1460d7e9715883e2c053ffecddc0a663cdf2276c7244b590abf577")
        XCTAssertEqual(privateMasterKeys.privateTokenKey.hexEncodedString(), "5bb087dac486697278f6a73aa1880766e59a006ce03f8d697644bf624ad3490f")
    }
}

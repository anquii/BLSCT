import XCTest
import Foundation
import BinaryExtensions
import BLSCT

final class OutputOwnershipValidatorTests: XCTestCase {
    private func sut(privateViewKey: Data) throws -> OutputOwnershipValidator {
        try .init(privateViewKey: privateViewKey)
    }

    func testGivenPrivateViewKey_AndOutputPublicBlindKey_WhenOutputPublicNonceKey_ThenEqualVectorKey() throws {
        let privateViewKey = Data(hexEncodedString: "2c12e402aee1c7afb1dc32f1040bf4f14db8200ce4b97e95e85fc3e0edb713d")!
        let outputPublicBlindKey = Data(hexEncodedString: "80e845ca79807a66ab93121dd57971ee2acbb3ef20d94c0750eb33eaa64bf58fe0f5cd775dcf73b49117260e806e8708")!
        let sut = try sut(privateViewKey: privateViewKey)
        let outputPublicNonceKey = try sut.outputPublicNonceKey(outputPublicBlindKey: outputPublicBlindKey)
        XCTAssertEqual(outputPublicNonceKey.hexEncodedString(), "8d2a6ed57abdc3f890acdc55f3b2cb7b35f56939053742a90c7d5442592d0ff33c2223a80f7fb8ef0f773649f2678406")
    }

    func testGivenOutputPublicNonceKey_WhenValidateOutputViewTag_ThenNoError() throws {
        let outputPublicNonceKey = Data(hexEncodedString: "8d2a6ed57abdc3f890acdc55f3b2cb7b35f56939053742a90c7d5442592d0ff33c2223a80f7fb8ef0f773649f2678406")!
        let sut = try sut(privateViewKey: Data(hexEncodedString: "2c12e402aee1c7afb1dc32f1040bf4f14db8200ce4b97e95e85fc3e0edb713d")!)
        try sut.validateOutputViewTag(20232, outputPublicNonceKey: outputPublicNonceKey)
    }

    func testGivenOutputPublicSpendKey_AndOutputPublicNonceKey_WhenOutputPublicSpendKeyHash_ThenEqualVectorHash() throws {
        let outputPublicSpendKey = Data(hexEncodedString: "84ee3e9c40fe65f91776033b5ddb3bf280bbd549924028280dad0d6ea464bb728886910f53bd66bcc2b59e37f1b8f55e")!
        let outputPublicNonceKey = Data(hexEncodedString: "8d2a6ed57abdc3f890acdc55f3b2cb7b35f56939053742a90c7d5442592d0ff33c2223a80f7fb8ef0f773649f2678406")!
        let sut = try sut(privateViewKey: Data(hexEncodedString: "2c12e402aee1c7afb1dc32f1040bf4f14db8200ce4b97e95e85fc3e0edb713d")!)
        let outputPublicSpendKeyHash = try sut.outputPublicSpendKeyHash(outputPublicSpendKey: outputPublicSpendKey, outputPublicNonceKey: outputPublicNonceKey)
        XCTAssertEqual(outputPublicSpendKeyHash.hexEncodedString(), "dc103f3afbfa5fccf51bfcba8a65fb14ddd0c1a7")
    }
}

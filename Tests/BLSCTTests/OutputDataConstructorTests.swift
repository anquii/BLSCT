import XCTest
import Foundation
import BinaryExtensions
@testable import BLSCT

final class OutputDataConstructorTests: XCTestCase {
    private func sut() throws -> OutputDataConstructor {
        try .init()
    }

    func testGivenInvalidAddress_WhenOutputDataWithSigningKeys_ThenError() {
        XCTAssertThrowsError(
            try sut().outputDataWithSigningKeys(address: "", amount: 1, memo: "", tokenIdentifier: TokenIdentifier(fungibleTokenIdentifier: 0))) {
            XCTAssertEqual($0 as? BLSCTError, .invalidAddressLength)
        }
    }

    func testGivenPrivateBlindKey_AndAddress_WhenOutputDataWithSigningKeys_ThenEqualVectorDataAndKeys() throws {
        let privateBlindKey = Data(hexEncodedString: "42c0926471b3bd01ae130d9382c5fca2e2b5000abbf826a93132696ffa5f2c65")!
        let outputDataWithSigningKeys = try sut().outputDataWithSigningKeys(
            privateBlindKeyScalar: Scalar(data: privateBlindKey),
            address: "xNTWKN8kaGR5tR8qbyMLrqkHXM8Esui3PbMBbL95EtoVsiLWTsU72E3tayw8CF81AJbSgRyV1GqyAaPnYJabZgfQYu1A11kqFhqicGTgv9J3Yk8BXSpxZmTXPRuQnyZMMHZrUxhczke",
            amount: 1,
            memo: "",
            tokenIdentifier: TokenIdentifier(fungibleTokenIdentifier: 0)
        )
        XCTAssertEqual(outputDataWithSigningKeys.outputData.publicEphemeralKey.hexEncodedString(), "935963399885ba1dd51dd272fb9be541896ac619570315e55f06c1e3a42d28ffb300fe6a3247d484bb491b25ecf7fb8a")
        XCTAssertEqual(outputDataWithSigningKeys.outputData.publicBlindKey.hexEncodedString(), "80e845ca79807a66ab93121dd57971ee2acbb3ef20d94c0750eb33eaa64bf58fe0f5cd775dcf73b49117260e806e8708")
        XCTAssertEqual(outputDataWithSigningKeys.outputData.publicSpendKey.hexEncodedString(), "84ee3e9c40fe65f91776033b5ddb3bf280bbd549924028280dad0d6ea464bb728886910f53bd66bcc2b59e37f1b8f55e")
        XCTAssertEqual(outputDataWithSigningKeys.outputData.viewTag, 20232)
        XCTAssertEqual(outputDataWithSigningKeys.privateBlindKey.hexEncodedString(), "42c0926471b3bd01ae130d9382c5fca2e2b5000abbf826a93132696ffa5f2c65")
        XCTAssertEqual(outputDataWithSigningKeys.privateGammaKey.hexEncodedString(), "77fb7a5ff31f1c28037942b94e23270338fa788e065855dffa6860be93073ee")
    }
}

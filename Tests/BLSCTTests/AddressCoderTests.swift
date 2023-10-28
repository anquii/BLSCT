import XCTest
import Foundation
import BinaryExtensions
@testable import BLSCT

final class AddressCoderTests: XCTestCase {
    private func sut() -> AddressCoder {
        .init()
    }

    func testGivenDoublePublicKey_WhenEncode_ThenEqualVectorAddress() {
        let publicViewKey = Data(hexEncodedString: "809ad665b3de4e1d44d835f1b8de36aafeea3279871aeceb56dbdda90c0426c022e8a6dda7313dc5e4c1817287805e3b")!
        let publicSpendKey = Data(hexEncodedString: "8258aadbb42f57dae65587ac18b164b538e3886ab9f0f350c96331ac7de0c2599eb88ac1464a0b0d8dda01bcf32e5dd4")!
        let doublePublicKey = DoublePublicKey(publicViewKey: publicViewKey, publicSpendKey: publicSpendKey)
        let address = sut().address(doublePublicKey: doublePublicKey)
        XCTAssertEqual(address, "xNTWKN8kaGR5tR8qbyMLrqkHXM8Esui3PbMBbL95EtoVsiLWTsU72E3tayw8CF81AJbSgRyV1GqyAaPnYJabZgfQYu1A11kqFhqicGTgv9J3Yk8BXSpxZmTXPRuQnyZMMHZrUxhczke")
    }

    func testGivenAddress_WhenDecode_ThenEqualVectorDoublePublicKey() throws {
        let doublePublicKey = try sut().doublePublicKey(address: "xNTWKN8kaGR5tR8qbyMLrqkHXM8Esui3PbMBbL95EtoVsiLWTsU72E3tayw8CF81AJbSgRyV1GqyAaPnYJabZgfQYu1A11kqFhqicGTgv9J3Yk8BXSpxZmTXPRuQnyZMMHZrUxhczke")
        XCTAssertEqual(doublePublicKey.publicViewKey.hexEncodedString(), "809ad665b3de4e1d44d835f1b8de36aafeea3279871aeceb56dbdda90c0426c022e8a6dda7313dc5e4c1817287805e3b")
        XCTAssertEqual(doublePublicKey.publicSpendKey.hexEncodedString(), "8258aadbb42f57dae65587ac18b164b538e3886ab9f0f350c96331ac7de0c2599eb88ac1464a0b0d8dda01bcf32e5dd4")
    }
}

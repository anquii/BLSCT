import XCTest
import Foundation
import BinaryExtensions
import BLSCT

final class DoublePublicKeyDerivatorTests: XCTestCase {
    private func sut(privateViewKey: Data, privateSpendKey: Data) throws -> DoublePublicKeyDerivator {
        try .init(privateViewKey: privateViewKey, privateSpendKey: privateSpendKey)
    }

    func testGivenPrivateViewKey_AndPrivateSpendKey_AndAddressIdentifier_WhenDerivateDoublePublicKey_ThenEqualVectorDoublePublicKey() throws {
        let privateViewKey = Data(hexEncodedString: "2c12e402aee1c7afb1dc32f1040bf4f14db8200ce4b97e95e85fc3e0edb713d")!
        let privateSpendKey = Data(hexEncodedString: "6063199b4c1460d7e9715883e2c053ffecddc0a663cdf2276c7244b590abf577")!
        let addressIdentifier = AddressIdentifier(accountIndex: 0, addressIndex: 0)
        let doublePublicKey = try sut(privateViewKey: privateViewKey, privateSpendKey: privateSpendKey).doublePublicKey(addressIdentifier: addressIdentifier)
        XCTAssertEqual(doublePublicKey.publicViewKey.hexEncodedString(), "809ad665b3de4e1d44d835f1b8de36aafeea3279871aeceb56dbdda90c0426c022e8a6dda7313dc5e4c1817287805e3b")
        XCTAssertEqual(doublePublicKey.publicSpendKey.hexEncodedString(), "8258aadbb42f57dae65587ac18b164b538e3886ab9f0f350c96331ac7de0c2599eb88ac1464a0b0d8dda01bcf32e5dd4")
        XCTAssertEqual(doublePublicKey.publicSpendKeyHash.hexEncodedString(), "dc103f3afbfa5fccf51bfcba8a65fb14ddd0c1a7")
    }
}

import XCTest
import Foundation
import BinaryExtensions
import BLSCT

final class SignatureConstructorTests: XCTestCase {
    private func sut() throws -> SignatureConstructor {
        try .init()
    }

    func testGivenMessage_AndPrivateKey_WhenConstructSignature_ThenEqualVectorSignature() throws {
        let message = Data(hexEncodedString: "10203040302010000")!
        let privateKey = Data(hexEncodedString: "1165f3da5b291138ec2cea55db549e58b7fd43ef5bb7c4c184e7de51e8fb1c14")!
        let signature = try sut().signature(message: message, privateKey: privateKey)
        XCTAssertEqual(signature.hexEncodedString(), "a9b65622af1750dc43fef7ea43894c8ad6ed45b3c2281dfd69e9a47ffef0dc82e4f368bd524c8bb6e1fbe40046b559ce115558e59d6f070b9938705a255dcf77dc37b2162c65fdee052baa0203c2c89609f309db65b423790e4e43175a204628")
    }

    func testGivenPrivateKey_WhenConstructBalanceSignature_ThenEqualVectorSignature() throws {
        let privateKey = Data(hexEncodedString: "1165f3da5b291138ec2cea55db549e58b7fd43ef5bb7c4c184e7de51e8fb1c14")!
        let balanceSignature = try sut().balanceSignature(privateKey: privateKey)
        XCTAssertEqual(balanceSignature.hexEncodedString(), "858ad7df3ae1d5df5fde2dd11c7b00a826652625ddaffafa412beef597bc64e5c6a9a2ac9af8e09fbbcb8a86fa21ddc90f335509b461127a52a0afb1d51abc703b79de6e07611f3aa7cdf8acfeb8a82a5b53d65a08f94b61f344ddc74258f5ff")
    }
}

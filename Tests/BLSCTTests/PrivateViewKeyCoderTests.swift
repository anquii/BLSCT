import XCTest
import Foundation
import BinaryExtensions
import BLSCT

final class PrivateViewKeyCoderTests: XCTestCase {
    private func sut() -> PrivateViewKeyCoder {
        .init()
    }

    func testGivenPrivateViewKey_WhenEncode_ThenEqualVectorKey() {
        let privateKey = Data(hexEncodedString: "2c12e402aee1c7afb1dc32f1040bf4f14db8200ce4b97e95e85fc3e0edb713d")!
        let base58CheckEncodedPrivateKey = sut().base58CheckEncodedPrivateKey(privateViewKey: privateKey)
        XCTAssertEqual(base58CheckEncodedPrivateKey, "PSd5HfRkiDnMA7GR4WMKEDeYkcKSRXm3fY1FoD4gpigxznTa6DqW")
    }

    func testGivenBase58CheckEncodedPrivateViewKey_WhenDecode_ThenEqualVectorKey() throws {
        let privateKey = try sut().privateKey(base58CheckEncodedPrivateViewKey: "PSd5HfRkiDnMA7GR4WMKEDeYkcKSRXm3fY1FoD4gpigxznTa6DqW")
        XCTAssertEqual(privateKey.hexEncodedString(), "2c12e402aee1c7afb1dc32f1040bf4f14db8200ce4b97e95e85fc3e0edb713d")
    }
}

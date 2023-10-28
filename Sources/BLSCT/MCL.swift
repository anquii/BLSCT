import Foundation
import BinaryExtensions
import MCLSwiftWrapper

typealias Scalar = mclBnFr
typealias G1Point = mclBnG1
typealias G2Point = mclBnG2

struct MCL {
    static let shared = MCL()
    static var generatorG1Point = G1Point()
    private static let curveType = Int32(MCL_BLS12_381)
    private static let compilationTime = Int32(246) // MCLBN_FR_UNIT_SIZE * 10 + MCLBN_FP_UNIT_SIZE + BLS_COMPILER_TIME_VAR_ADJ
    private static let mode = Int32(MCL_MAP_TO_MODE_HASH_TO_CURVE_07)
    private(set) static var isInitialized = false

    static func initializeIfNeeded() throws {
        guard !isInitialized else {
            return
        }
        guard
            mclBn_init(curveType, compilationTime) == 0,
            mclBn_setETHserialization(1) == (),
            mclBn_getETHserialization() == 1,
            mclBn_setMapToMode(mode) == 0
        else {
            throw BLSCTError.invalidMCLInitialization
        }
        generatorG1Point = G1Point(data: Data(hexEncodedString: "97f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb")!)
        isInitialized = true
    }
    private init() {}
}

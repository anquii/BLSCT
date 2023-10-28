import Foundation
import MCLSwiftWrapper
import BLSSwiftWrapper

struct BLS {
    static let shared = BLS()
    private static let curveType = Int32(MCL_BLS12_381)
    private static let compilationTime = Int32(246) // MCLBN_FR_UNIT_SIZE * 10 + MCLBN_FP_UNIT_SIZE + BLS_COMPILER_TIME_VAR_ADJ
    private(set) static var isInitialized = false

    static func initializeIfNeeded() throws {
        guard !isInitialized else {
            return
        }
        guard blsInit(curveType, compilationTime) == 0, mclBn_getETHserialization() == 1 else {
            throw BLSCTError.invalidBLSInitialization
        }
        isInitialized = true
    }
    private init() {}
}

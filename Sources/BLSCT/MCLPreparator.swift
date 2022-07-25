import Foundation
import MCLSwiftWrapper

public protocol MCLPreparing {
    func prepareMCL() throws
}

public struct MCLPreparator {
    private static let curveType = Int32(MCL_BLS12_381)
    private static let compilationTime = Int32(46) // MCLBN_FR_UNIT_SIZE * 10 + MCLBN_FP_UNIT_SIZE
    private static let mode = Int32(MCL_MAP_TO_MODE_HASH_TO_CURVE_07)

    public init() {}
}

// MARK: - MCLPreparing
extension MCLPreparator: MCLPreparing {
    public func prepareMCL() throws {
        guard !isPrepared else {
            return
        }
        guard
            mclBn_init(Self.curveType, Self.compilationTime) == 0,
            mclBn_setETHserialization(1) == (),
            mclBn_getETHserialization() == 1,
            mclBn_setMapToMode(Self.mode) == 0
        else {
            throw MCLPreparatorError.invalidPreparation
        }
    }
}

// MARK: - Helpers
fileprivate extension MCLPreparator {
    var isPrepared: Bool {
        let currentCurveType = Int32(mclBn_getCurveType())
        return currentCurveType == Self.curveType
    }
}

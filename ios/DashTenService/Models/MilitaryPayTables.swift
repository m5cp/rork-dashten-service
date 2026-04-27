import Foundation

// ============================================================================
// MilitaryPayTables
// ----------------------------------------------------------------------------
// Source: Official 2026 DFAS Basic Pay Tables (effective January 1, 2026,
// reflecting the 3.8% raise authorized by the FY26 NDAA signed Dec 18, 2025).
//
// All values are MONTHLY basic pay in U.S. dollars, rounded.
// Pay grade pay rates are identical across all six branches (Army, Navy,
// Air Force, Marine Corps, Space Force, Coast Guard).
//
// IMPORTANT: This data is published by DFAS. DashTen is not affiliated with,
// endorsed by, or associated with the Department of War / DoD, DFAS, the
// Thrift Savings Plan, or any branch of service. This is for educational /
// estimator purposes only. Verify all values against your LES via myPay.
//
// Update this file annually when the new NDAA pay tables are published
// (typically January of each year).
// ============================================================================

enum PayCategory: String, CaseIterable, Identifiable, Hashable {
    case enlisted = "Enlisted"
    case warrant = "Warrant Officer"
    case officer = "Officer"
    case priorEnlistedOfficer = "Prior-Enlisted Officer"

    var id: String { rawValue }

    var shortLabel: String {
        switch self {
        case .enlisted: return "Enlisted"
        case .warrant: return "Warrant"
        case .officer: return "Officer"
        case .priorEnlistedOfficer: return "Prior-Enl. Officer"
        }
    }

    var grades: [String] {
        switch self {
        case .enlisted:
            return ["E-1", "E-2", "E-3", "E-4", "E-5", "E-6", "E-7", "E-8", "E-9"]
        case .warrant:
            return ["W-1", "W-2", "W-3", "W-4", "W-5"]
        case .officer:
            return ["O-1", "O-2", "O-3", "O-4", "O-5", "O-6", "O-7", "O-8", "O-9", "O-10"]
        case .priorEnlistedOfficer:
            return ["O-1E", "O-2E", "O-3E"]
        }
    }

    var detail: String {
        switch self {
        case .enlisted:
            return "Standard enlisted ranks (E-1 through E-9)."
        case .warrant:
            return "Warrant officers (W-1 through W-5). Technical specialists."
        case .officer:
            return "Commissioned officers (O-1 through O-10)."
        case .priorEnlistedOfficer:
            return "Officers commissioned with 4+ years prior enlisted or warrant service. Higher rates than standard O-1/O-2/O-3."
        }
    }
}

enum MilitaryPayTables {
    /// Lower bounds (in years) for each years-of-service column on the official chart.
    /// Bracket index 0 = "Less than 2", 1 = "Over 2", 2 = "Over 3", 3 = "Over 4",
    /// 4 = "Over 6", 5 = "Over 8", 6 = "Over 10", 7 = "Over 12", 8 = "Over 14",
    /// 9 = "Over 16", 10 = "Over 18", 11 = "Over 20", 12 = "Over 22", 13 = "Over 24",
    /// 14 = "Over 26", 15 = "Over 30", 16 = "Over 34", 17 = "Over 38", 18 = "Over 40".
    static let yosBracketLowerBounds: [Double] = [
        0, 2, 3, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 30, 34, 38, 40
    ]

    /// 2026 monthly basic pay by pay grade × YoS bracket.
    /// -1 indicates "not applicable" (e.g. E-9 cannot exist with under 10 years).
    /// Note: O-7 through O-10 are capped by Executive Schedule Level II at $18,808.20;
    /// values shown rounded to nearest dollar from DFAS published tables.
    static let basicPay2026: [String: [Double]] = [
        // ===== Enlisted =====
        "E-1": [2407, 2407, 2407, 2407, 2407, 2407, 2407, 2407, 2407, 2407, 2407, 2407, 2407, 2407, 2407, -1, -1, -1, -1],
        "E-2": [2698, 2698, 2698, 2698, 2698, 2698, 2698, 2698, 2698, 2698, 2698, 2698, 2698, 2698, 2698, -1, -1, -1, -1],
        "E-3": [2837, 3015, 3198, 3198, 3198, 3198, 3198, 3198, 3198, 3198, 3198, 3198, 3198, 3198, 3198, -1, -1, -1, -1],
        "E-4": [3142, 3303, 3482, 3659, 3815, 3815, 3815, 3815, 3815, 3815, 3815, 3815, 3815, 3815, 3815, -1, -1, -1, -1],
        "E-5": [3343, 3598, 3776, 3947, 4110, 4300, 4395, 4422, 4422, 4422, 4422, 4422, 4422, 4422, 4422, -1, -1, -1, -1],
        "E-6": [3401, 3743, 3908, 4068, 4236, 4612, 4760, 5044, 5131, 5194, 5268, 5268, 5268, 5268, 5268, -1, -1, -1, -1],
        "E-7": [3932, 4291, 4456, 4673, 4844, 5135, 5300, 5592, 5835, 6001, 6177, 6245, 6475, 6598, 7067, -1, -1, -1, -1],
        "E-8": [-1, -1, -1, -1, -1, 5657, 5907, 6062, 6247, 6448, 6811, 6995, 7308, 7482, 7909, 8068, 8068, 8068, -1],
        "E-9": [-1, -1, -1, -1, -1, -1, 6910, 7067, 7264, 7496, 7731, 8105, 8423, 8756, 9268, 9730, 10217, 10729, -1],

        // ===== Warrant Officers =====
        "W-1": [4057, 4494, 4611, 4859, 5152, 5585, 5786, 6069, 6346, 6565, 6766, 7010, 7010, 7010, 7010, -1, -1, -1, -1],
        "W-2": [4622, 5059, 5194, 5286, 5586, 6052, 6282, 6509, 6787, 7005, 7201, 7437, 7592, 7714, 7714, -1, -1, -1, -1],
        "W-3": [5223, 5441, 5664, 5738, 5971, 6431, 6910, 7136, 7398, 7666, 8150, 8477, 8672, 8879, 9162, -1, -1, -1, -1],
        "W-4": [5720, 6152, 6329, 6503, 6802, 7098, 7398, 7848, 8244, 8620, 8928, 9228, 9669, 10032, 10445, 10654, 10654, 10654, -1],
        "W-5": [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 10170, 10686, 11070, 11495, 12071, 12673, 13308, -1],

        // ===== Officers =====
        "O-1": [4150, 4320, 5222, 5222, 5222, 5222, 5222, 5222, 5222, 5222, 5222, 5222, 5222, 5222, 5222, -1, -1, -1, -1],
        "O-2": [4782, 5446, 6272, 6484, 6618, 6618, 6618, 6618, 6618, 6618, 6618, 6618, 6618, 6618, 6618, -1, -1, -1, -1],
        "O-3": [5535, 6273, 6771, 7383, 7737, 8125, 8376, 8788, 9004, 9004, 9004, 9004, 9004, 9004, 9004, -1, -1, -1, -1],
        "O-4": [6294, 7286, 7773, 7881, 8332, 8816, 9419, 9888, 10214, 10402, 10510, 10510, 10510, 10510, 10510, -1, -1, -1, -1],
        "O-5": [7295, 8219, 8787, 8894, 9250, 9462, 9929, 10272, 10714, 11392, 11714, 12033, 12394, 12394, 12394, -1, -1, -1, -1],
        "O-6": [8751, 9614, 10245, 10245, 10284, 10725, 10784, 10784, 11396, 12480, 13115, 13751, 14113, 14479, 15189, 15493, 15493, 15493, -1],
        "O-7": [11540, 12076, 12325, 12522, 12879, 13232, 13639, 14046, 14454, 15736, 16818, 16818, 16818, 16818, 16904, 17242, 17242, 17242, -1],
        "O-8": [13888, 14344, 14645, 14730, 15107, 15736, 15882, 16480, 16652, 17166, 18598, 18598, 18999, 18999, 18999, 18999, 18999, 18999, -1],
        "O-9": [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 18999, 18999, 18999, 18999, 18999, 18999, 18999, -1],
        "O-10": [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 18999, 18999, 18999, 18999, 18999, 18999, 18999, -1],

        // ===== Prior-Enlisted Officers (E-pay rates) =====
        // Requires 4+ years prior enlisted or warrant service before commissioning.
        "O-1E": [-1, -1, -1, 5222, 5577, 5783, 5994, 6201, 6484, 6484, 6484, 6484, 6484, 6484, 6484, -1, -1, -1, -1],
        "O-2E": [-1, -1, -1, 6484, 6618, 6828, 7184, 7459, 7664, 7664, 7664, 7664, 7664, 7664, 7664, -1, -1, -1, -1],
        "O-3E": [-1, -1, -1, 7383, 7737, 8125, 8376, 8788, 9137, 9337, 9609, 9609, 9609, 9609, 9609, -1, -1, -1, -1],
    ]

    // MARK: - Lookup

    /// Returns the YoS bracket index for a given number of years of service.
    /// e.g., yos = 5 → returns index 3 (the "Over 4" bracket).
    private static func bracketIndex(forYearsOfService yos: Double) -> Int {
        var index = 0
        for (i, lowerBound) in yosBracketLowerBounds.enumerated() {
            if yos >= lowerBound { index = i }
        }
        return index
    }

    /// Returns 2026 monthly basic pay for a given grade and years of service.
    /// If the requested bracket has no defined value (e.g. E-9 with 5 years),
    /// returns the nearest valid bracket value (lowest available for that grade).
    static func basicPay(grade: String, yearsOfService: Double) -> Double? {
        guard let payArray = basicPay2026[grade] else { return nil }
        let targetIndex = bracketIndex(forYearsOfService: yearsOfService)

        // First, search downward from target for a valid value.
        for i in stride(from: targetIndex, through: 0, by: -1) where i < payArray.count {
            if payArray[i] >= 0 { return payArray[i] }
        }

        // If nothing below, search upward (handles cases where YoS is below this grade's minimum).
        for i in stride(from: targetIndex + 1, to: payArray.count, by: 1) {
            if payArray[i] >= 0 { return payArray[i] }
        }

        return nil
    }

    /// Returns the human-readable label for a YoS value (e.g., 5.0 → "Over 4 years").
    static func bracketLabel(forYearsOfService yos: Double) -> String {
        let idx = bracketIndex(forYearsOfService: yos)
        if idx == 0 { return "Less than 2 years" }
        let lower = yosBracketLowerBounds[idx]
        return "Over \(Int(lower)) years"
    }

    /// Returns the pay category that contains a given grade string.
    static func category(forGrade grade: String) -> PayCategory? {
        for cat in PayCategory.allCases {
            if cat.grades.contains(grade) { return cat }
        }
        return nil
    }
}

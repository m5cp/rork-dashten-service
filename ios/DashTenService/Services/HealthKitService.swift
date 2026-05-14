import Foundation
#if canImport(HealthKit)
import HealthKit
#endif

nonisolated struct HealthSnapshot: Sendable {
    let avgStepsLast7Days: Int
    let avgSleepHoursLast7Days: Double
    let mindfulMinutesLast7Days: Int
    let capturedAt: Date

    static let empty = HealthSnapshot(
        avgStepsLast7Days: 0,
        avgSleepHoursLast7Days: 0,
        mindfulMinutesLast7Days: 0,
        capturedAt: Date()
    )
}

@MainActor
final class HealthKitService {
    static let shared = HealthKitService()

    private let optInKey = "dashten_healthkit_opted_in"

    #if canImport(HealthKit)
    private let store = HKHealthStore()
    #endif

    private init() {}

    var isAvailable: Bool {
        #if canImport(HealthKit)
        return HKHealthStore.isHealthDataAvailable()
        #else
        return false
        #endif
    }

    var hasOptedIn: Bool {
        UserDefaults.standard.bool(forKey: optInKey)
    }

    func setOptedIn(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: optInKey)
    }

    /// Read-only authorization for Steps, Sleep, Mindfulness. Nothing is ever written.
    func requestAuthorization() async -> Bool {
        #if canImport(HealthKit)
        guard isAvailable else { return false }
        var readTypes: Set<HKObjectType> = []
        if let steps = HKObjectType.quantityType(forIdentifier: .stepCount) {
            readTypes.insert(steps)
        }
        if let sleep = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            readTypes.insert(sleep)
        }
        if let mindful = HKObjectType.categoryType(forIdentifier: .mindfulSession) {
            readTypes.insert(mindful)
        }
        do {
            try await store.requestAuthorization(toShare: [], read: readTypes)
            setOptedIn(true)
            AnalyticsService.shared.log(.featureUsed, properties: ["name": "healthkit_opt_in"])
            return true
        } catch {
            return false
        }
        #else
        return false
        #endif
    }

    func loadSnapshot() async -> HealthSnapshot {
        #if canImport(HealthKit)
        guard isAvailable, hasOptedIn else { return .empty }
        async let steps = avgStepsLast7Days()
        async let sleep = avgSleepHoursLast7Days()
        async let mindful = mindfulMinutesLast7Days()
        return await HealthSnapshot(
            avgStepsLast7Days: steps,
            avgSleepHoursLast7Days: sleep,
            mindfulMinutesLast7Days: mindful,
            capturedAt: Date()
        )
        #else
        return .empty
        #endif
    }

    #if canImport(HealthKit)
    private func avgStepsLast7Days() async -> Int {
        guard let type = HKObjectType.quantityType(forIdentifier: .stepCount) else { return 0 }
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -7, to: end) ?? end
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        return await withCheckedContinuation { (continuation: CheckedContinuation<Int, Never>) in
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, stats, _ in
                let total = stats?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                continuation.resume(returning: Int(total / 7.0))
            }
            store.execute(query)
        }
    }

    private func avgSleepHoursLast7Days() async -> Double {
        guard let type = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return 0 }
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -7, to: end) ?? end
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        return await withCheckedContinuation { (continuation: CheckedContinuation<Double, Never>) in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, _ in
                let asleepValues: Set<Int> = [
                    HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue,
                    HKCategoryValueSleepAnalysis.asleepCore.rawValue,
                    HKCategoryValueSleepAnalysis.asleepDeep.rawValue,
                    HKCategoryValueSleepAnalysis.asleepREM.rawValue
                ]
                let totalSeconds: TimeInterval = (samples ?? []).reduce(0) { acc, sample in
                    guard let cat = sample as? HKCategorySample,
                          asleepValues.contains(cat.value) else { return acc }
                    return acc + cat.endDate.timeIntervalSince(cat.startDate)
                }
                let hours = (totalSeconds / 3600.0) / 7.0
                continuation.resume(returning: hours)
            }
            store.execute(query)
        }
    }

    private func mindfulMinutesLast7Days() async -> Int {
        guard let type = HKObjectType.categoryType(forIdentifier: .mindfulSession) else { return 0 }
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -7, to: end) ?? end
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        return await withCheckedContinuation { (continuation: CheckedContinuation<Int, Never>) in
            let query = HKSampleQuery(
                sampleType: type,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, _ in
                let totalSeconds: TimeInterval = (samples ?? []).reduce(0) { acc, sample in
                    acc + sample.endDate.timeIntervalSince(sample.startDate)
                }
                continuation.resume(returning: Int(totalSeconds / 60.0))
            }
            store.execute(query)
        }
    }
    #endif
}

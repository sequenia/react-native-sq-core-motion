import React
import Foundation
import HealthKit

typealias HandleError = (SQFitnessError?) -> ()

class SQHealthKitManager {

    private let healthStore = HKHealthStore()

    public func authorize(
        readTypes: [HKTypeData],
        complete: @escaping () -> Void,
        handleError: @escaping HandleError
    ) -> Void {
        if !HKHealthStore.isHealthDataAvailable() {
            handleError(nil)
            return
        }

        var read: Set<HKSampleType>? = Set()
        readTypes.compactMap {
            self.transformDataKeyToHKSampleType($0.rawValue)
        }.forEach {
            read?.insert($0)
        }

        self.healthStore.requestAuthorization(
            toShare: [],
            read: read
        ) { success, error in
            if let error {
                handleError(SQFitnessError(with: error))
                return
            }
            complete()
        }
    }

    public func authorizationStatus(for readType: HKTypeData) -> Bool {
        guard let objectType = self.transformDataKeyToHKSampleType(readType.rawValue) else { return false }
        let status = self.healthStore.authorizationStatus(for: objectType)

        return status == .sharingAuthorized
    }

    public func queryWorkouts(
        _ workoutDataType: WorkoutDataType,
        start: Date,
        end: Date,
        complete: @escaping ([Dictionary<String, Any>]) -> Void,
        handleError: @escaping HandleError
    ) {
        let workoutTypePredicate = HKQuery.predicateForWorkouts(
            with: workoutDataType.convertToHKWorkoutActivityType()
        )

        var predicate: NSPredicate = HKQuery.predicateForSamples(
            withStart: start, end: end, options: HKQueryOptions(rawValue: 0))
        predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [predicate, workoutTypePredicate]
        )

        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false
        )

        let query: HKSampleQuery = HKSampleQuery(
            sampleType: HKWorkoutType.workoutType(),
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        ) { query, samples, error in
            if let error = error {
                handleError(SQFitnessError(with: error))
                return
            }

            let dataRecords: [Dictionary] = samples?.compactMap {
                $0.convertToDictionary()
            } ?? []

            complete(dataRecords)
        }

        self.healthStore.execute(query)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 30) {
            self.healthStore.stop(query)
        }
    }

    public func queryTotal(
        _ fitnessDataType: FitnessDataType,
        startDate: Date,
        endDate: Date,
        complete: @escaping (Double) -> Void,
        handleError: @escaping HandleError
    ) -> Void {

        guard let query = generateCollectionQuery(
            fitnessDataType: fitnessDataType,
            startDate: startDate,
            endDate: endDate,
            handleError: handleError
        ) else { return }

        query.initialResultsHandler = { query, results, error in

            if let error = error {
                handleError(SQFitnessError(with: error))
                return
            }

            guard let statsCollection = results else {
                handleError(SQFitnessError(message: "Unhandled error getting results."))
                return
            }

            var total: Double = 0;

            statsCollection.enumerateStatistics(
                from: startDate,
                to: endDate
            ) { (result, stop) in
                if let quantity: HKQuantity = result.sumQuantity() {
                    let value: Double = quantity.doubleValue(
                        for: HKUnit.init(from: fitnessDataType.defaultUnit())
                    )
                    total += value;
                }
            }

            if fitnessDataType.defaultUnit() == HKUnit.count().unitString {
                complete(total)
            } else {
                complete(total.rounded(toPlaces: 2))
            }
        }

        self.healthStore.execute(query)

        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            self.healthStore.stop(query)
        }
    }

    private func generateCollectionQuery(
        fitnessDataType: FitnessDataType,
        startDate start: Date,
        endDate end: Date,
        handleError: @escaping HandleError
    ) -> HKStatisticsCollectionQuery? {
        var interval: DateComponents = DateComponents()
        interval.day = 1

        guard let quantityType = transformDataKeyToHKQuantityType(fitnessDataType) else {
            handleError(SQFitnessError(message: "Invalid dataTypeIdentifier."))
            return nil
        }

        let query = HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: start,
            intervalComponents: interval
        )

        return query
    }

    private func transformDataKeyToHKQuantityType(_ dataKey: FitnessDataType) -> HKQuantityType? {
        HKObjectType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier(rawValue: dataKey.rawValue)
        )
    }

    private func transformDataKeyToHKSampleType(_ dataKey: String) -> HKSampleType? {
        if dataKey == HKTypeData.workout.rawValue {
            return HKSampleType.workoutType()
        }

        return HKSampleType.quantityType(
            forIdentifier: HKQuantityTypeIdentifier(rawValue: dataKey)
        )
    }
}

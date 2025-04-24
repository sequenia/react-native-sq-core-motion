import HealthKit

extension HKSample {

    func convertToDictionary(
      healthStore: HKHealthStore
    ) async -> [String: Any]? {
        guard let workout: HKWorkout = self as? HKWorkout else {
            return nil
        }

        let sourceDevice: String = self.sourceRevision.productType ?? "unknown"
        let distance: Double? = workout.totalDistance?.doubleValue(for: .meter())
        let energyBurned: Double? = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie())
        let isoStartDate = self.formatUtcIsoDateTimeString(workout.startDate)
        let isoEndDate = self.formatUtcIsoDateTimeString(workout.endDate)

        let analysisHeartRate = try? await analyzeWorkoutHeartRate(
          workout: workout,
          healthStore: healthStore
        )

        var dataRecords = [
            "uuid": workout.uuid.uuidString as Any,
            "duration": workout.duration as Any,
            "startDate": isoStartDate as Any,
            "endDate": isoEndDate as Any,
            "distance": distance as Any,
            "type": workout.workoutActivityType.rawValue as Any,
            "metadata": workout.metadata as Any,
            "heartRateAverage": analysisHeartRate?.averageBPM as Any,
            "heartRateMin": analysisHeartRate?.minBPM as Any,
            "heartRateMax": analysisHeartRate?.maxBPM as Any,
            "source": [
                "name": workout.sourceRevision.source.name as Any,
                "device": sourceDevice as Any,
                "id": workout.sourceRevision.source.bundleIdentifier as Any,
            ]
        ]

        return dataRecords
    }

    private func formatUtcIsoDateTimeString(_ date: Date) -> String {
        let formatter: ISO8601DateFormatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withFullTime]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return formatter.string(from: date)
    }
}

@available(iOS 15.0, *)
func analyzeWorkoutHeartRate(
    workout: HKWorkout,
    healthStore: HKHealthStore
) async throws -> WorkoutHeartRateAnalysis {
    async let average = workout.averageHeartRate(healthStore: healthStore)
    async let max = workout.maxHeartRate(healthStore: healthStore)
    async let min = workout.minHeartRate(healthStore: healthStore)
    async let samples = workout.heartRateSamples(healthStore: healthStore)

    return try await WorkoutHeartRateAnalysis(
        averageBPM: average,
        maxBPM: max,
        minBPM: min,
        samples: samples
    )
}

// MARK: - Data Model

struct WorkoutHeartRateAnalysis {
    let averageBPM: Double?
    let maxBPM: Double?
    let minBPM: Double?
    let samples: [HeartRateSample]

    struct HeartRateSample {
        let value: Double
        let timestamp: Date
    }
}

@available(iOS 15.0, *)
extension HKWorkout {

  func averageHeartRate(
    healthStore: HKHealthStore
  ) async throws -> Double? {
    try await getHeartRateStatistic(
      healthStore: healthStore,
      options: .discreteAverage
    )
  }

  func maxHeartRate(
    healthStore: HKHealthStore
  ) async throws -> Double? {
    try await getHeartRateStatistic(
      healthStore: healthStore,
      options: .discreteMax
    )
  }

  func minHeartRate(
    healthStore: HKHealthStore
  ) async throws -> Double? {
    try await getHeartRateStatistic(
      healthStore: healthStore,
      options: .discreteMin
    )
  }

  func heartRateSamples(
    healthStore: HKHealthStore
  ) async throws -> [WorkoutHeartRateAnalysis.HeartRateSample] {
    guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
      throw HKError(.errorInvalidArgument)
    }

    let predicate = HKQuery.predicateForSamples(
      withStart: startDate,
      end: endDate,
      options: .strictStartDate
    )

    let samples: [HKQuantitySample] = try await withCheckedThrowingContinuation { continuation in
      let query = HKSampleQuery(
        sampleType: heartRateType,
        predicate: predicate,
        limit: HKObjectQueryNoLimit,
        sortDescriptors: [.init(key: HKSampleSortIdentifierStartDate, ascending: true)]
      ) { _, samples, error in
        if let error = error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(returning: (samples as? [HKQuantitySample]) ?? [])
        }
      }
      healthStore.execute(query)
    }

    return samples.map {
      WorkoutHeartRateAnalysis.HeartRateSample(
        value: $0.quantity.doubleValue(for: .heartRateUnit),
        timestamp: $0.startDate
      )
    }
  }

  private func getHeartRateStatistic(
      healthStore: HKHealthStore,
      options: HKStatisticsOptions
  ) async throws -> Double? {
      guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
        throw HKError(.errorInvalidArgument)
      }

      let stats: HKStatistics = try await withCheckedThrowingContinuation { continuation in
          let query = HKStatisticsQuery(
              quantityType: heartRateType,
              quantitySamplePredicate: HKQuery.predicateForSamples(
                  withStart: startDate,
                  end: endDate,
                  options: .strictStartDate
              ),
              options: options
          ) { _, statistics, error in
              if let error = error {
                  continuation.resume(throwing: error)
              } else if let stats = statistics {
                  continuation.resume(returning: stats)
              } else {
                continuation.resume(throwing: HKError(.errorNoData))
              }
          }
          healthStore.execute(query)
      }

      switch options {
      case .discreteAverage: return stats.averageQuantity()?.doubleValue(for: .heartRateUnit)
      case .discreteMax: return stats.maximumQuantity()?.doubleValue(for: .heartRateUnit)
      case .discreteMin: return stats.minimumQuantity()?.doubleValue(for: .heartRateUnit)
      default: return nil
      }
  }
}

extension HKUnit {
    static var heartRateUnit: HKUnit {
        HKUnit(from: "count/min")
    }
}

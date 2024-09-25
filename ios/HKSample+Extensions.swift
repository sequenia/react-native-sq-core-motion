import HealthKit

extension HKSample {

    func convertToDictionary() -> [String: Any]? {
        guard let workout: HKWorkout = self as? HKWorkout else {
            return nil
        }

        let sourceDevice: String = self.sourceRevision.productType ?? "unknown"
        let distance: Double? = workout.totalDistance?.doubleValue(for: .meter())
        let energyBurned: Double? = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie())
        let isoStartDate = self.formatUtcIsoDateTimeString(workout.startDate)
        let isoEndDate = self.formatUtcIsoDateTimeString(workout.endDate)

        var dataRecords = [
            "uuid": workout.uuid.uuidString as Any,
            "duration": workout.duration as Any,
            "startDate": isoStartDate as Any,
            "endDate": isoEndDate as Any,
            "distance": distance as Any,
            "type": workout.workoutActivityType.rawValue as Any,
            "metadata": workout.metadata as Any,
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


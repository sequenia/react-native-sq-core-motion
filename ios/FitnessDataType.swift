enum FitnessDataType: String {
    case activeEnergyBurned = "HKQuantityTypeIdentifierActiveEnergyBurned"
    case appleExerciseTime = "HKQuantityTypeIdentifierAppleExerciseTime"
    case appleMoveTime = "HKQuantityTypeIdentifierAppleMoveTime"
    case appleStandTime = "HKQuantityTypeIdentifierAppleStandTime"
    case basalEnergyBurned = "HKQuantityTypeIdentifierBasalEnergyBurned"
    case cyclingCadence = "HKQuantityTypeIdentifierCyclingCadence"
    case cyclingFunctionalThresholdPower = "HKQuantityTypeIdentifierCyclingFunctionalThresholdPower"
    case cyclingPower = "HKQuantityTypeIdentifierCyclingPower"
    case cyclingSpeed = "HKQuantityTypeIdentifierCyclingSpeed"
    case distanceCycling = "HKQuantityTypeIdentifierDistanceCycling"
    case distanceDownhillSnowSports = "HKQuantityTypeIdentifierDistanceDownhillSnowSports"
    case distanceSwimming = "HKQuantityTypeIdentifierDistanceSwimming"
    case distanceWalkingRunning = "HKQuantityTypeIdentifierDistanceWalkingRunning"
    case distanceWheelchair = "HKQuantityTypeIdentifierDistanceWheelchair"
    case flightsClimbed = "HKQuantityTypeIdentifierFlightsClimbed"
    case nikeFuel = "HKQuantityTypeIdentifierNikeFuel"
    case physicalEffort = "HKQuantityTypeIdentifierPhysicalEffort"
    case pushCount = "HKQuantityTypeIdentifierPushCount"
    case runningPower = "HKQuantityTypeIdentifierRunningPower"
    case runningSpeed = "HKQuantityTypeIdentifierRunningSpeed"
    case stepCount = "HKQuantityTypeIdentifierStepCount"
    case swimmingStrokeCount = "HKQuantityTypeIdentifierSwimmingStrokeCount"
    case underwaterDepth = "HKQuantityTypeIdentifieUnderwaterDepth"

    func defaultUnit() -> String {
        if self == .distanceWalkingRunning {
            return "m"
        }

        return ""
    }
}

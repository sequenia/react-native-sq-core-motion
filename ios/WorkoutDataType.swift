//
//  WorkoutDataType.swift
//  react-native-sq-core-motion
//
//  Created by Ivan Mikhailovskii on 29.08.2024.
//

import HealthKit

enum WorkoutDataType: String, CaseIterable {

    case swimming
    case cycling
    case running
    case walking
    case crossCountrySkiing

    func convertToHKWorkoutActivityType() -> HKWorkoutActivityType {
        switch self {
        case .swimming:
            return .swimming

        case .cycling:
            return .cycling

        case .running:
            return .running

        case .walking:
            return .walking

        case .crossCountrySkiing:
            return .crossCountrySkiing
        }
    }
}

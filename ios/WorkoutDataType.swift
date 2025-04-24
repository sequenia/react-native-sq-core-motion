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

    case functionalStrengthTraining
    case traditionalStrengthTraining
    case coreTraining
    case elliptical
    case crossTraining
    case mixedCardio
    case highIntensityIntervalTraining
    case jumpRope
    case stairClimbing
    case stepTraining
    case stairs

    case flexibility
    case cooldown
    case yoga
    case taiChi
    case gymnastics
    case preparationAndRecovery
    case waterFitness
    case pilates
    case barre
    case mindAndBody

    case boxing
    case kickboxing
    case martialArts
    case wrestling
    case fencing

    case cardioDance
    case socialDance

    case basketball
    case soccer
    case volleyball
    case baseball
    case softball
    case americanFootball
    case australianFootball
    case rugby
    case handball
    case hockey
    case cricket
    case lacrosse
    case waterPolo
    case discSports
    case tableTennis
    case badminton
    case pickleball
    case tennis
    case racquetball
    case squash

    case climbing
    case fishing
    case hunting
    case golf
    case sailing
    case rowing
    case paddleSports
    case surfingSports
    case waterSports
    case snowboarding
    case downhillSkiing
    case snowSports
    case skatingSports
    case archery
    case bowling

    case trackAndField
    case wheelchairWalkPace
    case wheelchairRunPace
    case handCycling
    case fitnessGaming
    case equestrianSports
    case play
    case curling

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

        case .functionalStrengthTraining:
          return .functionalStrengthTraining

        case .traditionalStrengthTraining:
          return .traditionalStrengthTraining

        case .coreTraining:
          return .coreTraining

        case .elliptical:
          return .elliptical

        case .crossTraining:
          return .crossTraining

        case .mixedCardio:
          return .mixedCardio

        case .highIntensityIntervalTraining:
          return .highIntensityIntervalTraining

        case .jumpRope:
          return .jumpRope

        case .stairClimbing:
          return .stairClimbing

        case .stepTraining:
          return .stepTraining

        case .stairs:
          return .stairs

        case .flexibility:
          return .flexibility

        case .cooldown:
          if #available(iOS 14.0, *) {
            return .cooldown
          }

          return .other

        case .yoga:
          return .yoga

        case .taiChi:
          return .taiChi

        case .gymnastics:
          return .gymnastics

        case .preparationAndRecovery:
          return .preparationAndRecovery

        case .waterFitness:
          return .waterFitness

        case .pilates:
          return .pilates

        case .barre:
          return .barre

        case .mindAndBody:
          return .mindAndBody

        case .boxing:
          return .boxing

        case .kickboxing:
          return .kickboxing

        case .martialArts:
          return .martialArts

        case .wrestling:
          return .wrestling

        case .fencing:
          return .fencing

        case .cardioDance:
          if #available(iOS 14.0, *) {
            return .cardioDance
          }

          return .other

        case .socialDance:
          if #available(iOS 14.0, *) {
            return .socialDance
          }

          return .other

        case .basketball:
          return .basketball

        case .soccer:
          return .soccer

        case .volleyball:
          return .volleyball

        case .baseball:
          return .baseball

        case .softball:
          return .softball

        case .americanFootball:
          return .americanFootball

        case .australianFootball:
          return .australianFootball

        case .rugby:
          return .rugby

        case .handball:
          return .handball

        case .hockey:
          return .hockey

        case .cricket:
          return .cricket

        case .lacrosse:
          return .lacrosse

        case .waterPolo:
          return .waterPolo

        case .discSports:
          if #available(iOS 13.0, *) {
            return .discSports
          }

          return .other

        case .tableTennis:
          return .tableTennis

        case .badminton:
          return .badminton

        case .pickleball:
          if #available(iOS 14.0, *) {
            return .pickleball
          }

          return .other

        case .tennis:
          return .tennis

        case .racquetball:
          return .racquetball

        case .squash:
          return .squash

        case .climbing:
          return .climbing

        case .fishing:
          return .fishing

        case .hunting:
          return .hunting

        case .golf:
          return .golf

        case .sailing:
          return .sailing

        case .rowing:
          return .rowing

        case .paddleSports:
          return .paddleSports

        case .surfingSports:
          return .surfingSports

        case .waterSports:
          return .waterSports

        case .snowboarding:
          return .snowboarding

        case .downhillSkiing:
          return .downhillSkiing

        case .snowSports:
          return .snowSports

        case .skatingSports:
          return .skatingSports

        case .archery:
          return .archery

        case .bowling:
          return .bowling

        case .trackAndField:
          return .trackAndField

        case .wheelchairWalkPace:
          return .wheelchairWalkPace

        case .wheelchairRunPace:
          return .wheelchairRunPace

        case .handCycling:
          return .handCycling

        case .fitnessGaming:
          if #available(iOS 13.0, *) {
            return .fitnessGaming
          }

          return .other

        case .equestrianSports:
          return .equestrianSports

        case .play:
          return .play

        case .curling:
          return .curling

        }
    }
}

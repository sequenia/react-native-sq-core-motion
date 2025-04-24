import Foundation
import React

@objc(SQFitnessStatistic)
public class SQFitnessStatistic: NSObject {

    private var healthKitManager = SQHealthKitManager()
    let dateFormatter = DateFormatter()

    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }

    @objc
    public func authorize(
        _ resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        self.healthKitManager.authorize(
            readTypes: [
                .workout,
                .stepCount,
                .distanceCycling,
                .distanceWalkingRunning,
                .heartRate
            ],
            complete: { resolve(true) },
            handleError: { error in
                reject(nil, error?.message, error?.error)
            }
        )
    }

    @objc
    public func authorizationStatus(
        _ type: String,
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        guard let type = HKTypeData(rawValue: type) else {
            resolve(false)
            return
        }

        resolve(self.healthKitManager.authorizationStatus(for: type))
    }

    @objc
    public func getWorkoutData(
        _ type: String,
        startDate: String,
        endDate: String,
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        guard let startDate = self.convertStringToDate(dateString: startDate),
              let endDate = self.convertStringToDate(dateString: endDate)
        else {
            reject(nil, "Invalide date format! Format: yyyy-MM-dd'T'HH:mm:ssXXXXX", nil)
            return
        }

        guard let type = WorkoutDataType(rawValue: type) else {
            reject(nil, "Invalide WorkoutDataType!", nil)
            return
        }

        self.healthKitManager.queryWorkouts(
            type,
            start: startDate,
            end: endDate,
            complete: { value in
                resolve(value)
            }) { error in
                reject(nil, error?.message, error?.error)
            }
    }

    @objc
    public func getFitnessData(
        _ type: String,
        startDate: String,
        endDate: String,
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        guard let startDate = self.convertStringToDate(dateString: startDate),
              let endDate = self.convertStringToDate(dateString: endDate)
        else {
            reject(nil, "Invalide date format! Format: yyyy-MM-dd'T'HH:mm:ssXXXXX", nil)
            return
        }

        guard let type = FitnessDataType(rawValue: type) else {
            reject(nil, "Invalide FitnessDataType", nil)
            return
        }

        self.healthKitManager.queryTotal(
            type,
            startDate: startDate,
            endDate: endDate
        ) { value in
            resolve(value)
        } handleError: { error in
            reject(nil, error?.message, nil)
        }
    }

    private func convertStringToDate(dateString: String) -> Date? {
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        return self.dateFormatter.date(from: dateString)
    }
}

import Foundation
import CoreMotion

enum SQMotionActivityType: String {
    case stationary
    case walking
    case running
    case automotive
    case cycling
    case unknown
    case notAvailable
}

typealias StepCountHandler = ((_ stepCount: Int) -> Void)
typealias DistanceHandler = ((_ distance: Double?) -> Void)
typealias ActivityTypeHandler = ((_ activityType: SQMotionActivityType) -> Void)

class SQCoreMotionManager {

    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    private var startDate: Date? = nil

    private var stepCountHandler: StepCountHandler?
    private var activityTypeHandler: ActivityTypeHandler?
    private var distanceHandler: DistanceHandler?

    func subscribeStepCount(
        stepCountHandler: @escaping StepCountHandler,
        activityTypeHandler: ActivityTypeHandler?
    ) {
        self.stepCountHandler = stepCountHandler
        self.activityTypeHandler = activityTypeHandler

        self.onStart()
    }

    func subscribeDistance(
        distanceHandler: @escaping DistanceHandler
    ) {
        self.distanceHandler = distanceHandler

        self.onStart()
    }

    private func checkAuthorizationStatus() {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied:
            self.onStop()
            self.activityTypeHandler?(.notAvailable)
            self.stepCountHandler?(0)
        default:break
        }
    }

    private func onStart() {
        if startDate != nil { return }

        startDate = Date()
        self.checkAuthorizationStatus()
        self.startUpdating()
    }

    func onStop() {
        self.startDate = nil
        self.stopUpdating()

        self.stepCountHandler = nil
        self.activityTypeHandler = nil
        self.distanceHandler = nil
    }

    private func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.startTrackingActivityType()
        } else {
            self.activityTypeHandler?(.notAvailable)
        }

        if CMPedometer.isStepCountingAvailable() {
            self.startCountingSteps()
        } else {
            self.stepCountHandler?(0)
        }
    }

    private func stopUpdating() {
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
    }

    private func on(error: Error) {
        //handle error
    }

    private func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    self?.activityTypeHandler?(.walking)
                } else if activity.stationary {
                    self?.activityTypeHandler?(.stationary)
                } else if activity.running {
                    self?.activityTypeHandler?(.running)
                } else if activity.automotive {
                    self?.activityTypeHandler?(.automotive)
                } else {
                    self?.activityTypeHandler?(.unknown)
                }
            }
        }
    }

    private func startCountingSteps() {
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }

            DispatchQueue.main.async {
                self?.stepCountHandler?(pedometerData.numberOfSteps.intValue)
                self?.distanceHandler?(pedometerData.distance?.doubleValue ?? 0)
            }
        }
    }

}

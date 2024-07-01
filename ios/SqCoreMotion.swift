import Foundation
import React

@objc(SQCoreMotion)
class SQCoreMotion: RCTEventEmitter {

    public static var emitter: RCTEventEmitter?
    private var coreMotionManager = SQCoreMotionManager()

    override init() {
        super.init()

        RNHealthTracker.emitter = self
    }

    @objc
    override static func requiresMainQueueSetup() -> Bool {
        return false
    }

    @objc
    override func supportedEvents() -> [String]! {
      return [
        "update_step_count",
        "update_distance",
        "update_activity_type"
      ]
    }

    @objc public func subscribeStepCount(
            resolve: @escaping RCTPromiseResolveBlock,
            reject: @escaping RCTPromiseRejectBlock
    ) {
        self.coreMotionManager
            .subscribeStepCount { stepCount in
                RNHealthTracker.emitter?.sendEvent(
                    withName: "update_step_count",
                    body: [stepCount]
                )
            } activityTypeHandler: { activityType in
                RNHealthTracker.emitter?.sendEvent(
                    withName: "update_activity_type",
                    body: [activityType.rawValue]
                )
            }
        resolve(true)
    }
}

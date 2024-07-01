import Foundation
import React

@objc(SQCoreMotion)
class SQCoreMotion: RCTEventEmitter {

    public static var emitter: RCTEventEmitter?
    private var coreMotionManager = SQCoreMotionManager()

    override init() {
        super.init()

        SQCoreMotion.emitter = self
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
            _ resolve: @escaping RCTPromiseResolveBlock,
            reject: @escaping RCTPromiseRejectBlock
    ) {
        self.coreMotionManager
            .subscribeStepCount { stepCount in
                SQCoreMotion.emitter?.sendEvent(
                    withName: "update_step_count",
                    body: stepCount
                )
            } activityTypeHandler: { activityType in
                SQCoreMotion.emitter?.sendEvent(
                    withName: "update_activity_type",
                    body: activityType.rawValue
                )
            }
        resolve(())
    }

    @objc public func subscribeDistance(
            _ resolve: @escaping RCTPromiseResolveBlock,
            reject: @escaping RCTPromiseRejectBlock
    ) {
        self.coreMotionManager
            .subscribeDistance { distance in
                SQCoreMotion.emitter?.sendEvent(
                    withName: "update_distance",
                    body: distance
                )
            }
        resolve(())
    }

    @objc public func unSubscribeStepCount(
        _ resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        self.coreMotionManager.onStop()
    }

    @objc public func unSubscribeDistance(
        _ resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        self.coreMotionManager.onStop()
    }
}

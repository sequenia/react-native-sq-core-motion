#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE (SQFitnessStatistic, NSObject)

RCT_EXTERN_METHOD(getWorkoutData:
                  (NSString*)type
                  startDate:(NSString*)startDate
                  endDate:(NSString*)endDate
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getFitnessData:
                  (NSString*)type
                  startDate:(NSString*)startDate
                  endDate:(NSString*)endDate
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(authorize:
                  (RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(authorizationStatus:
                  (NSString*)type
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)

@end

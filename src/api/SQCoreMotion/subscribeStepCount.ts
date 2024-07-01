import { NativeModules } from 'react-native';
import { NativeEventEmitter } from 'react-native';

/** @internal */
const { SQCoreMotion } = NativeModules;
const EventEmitter = new NativeEventEmitter(SQCoreMotion)

export const subscribeStepCount = async (
  callback: (stepCount: number) => void,
): Promise<void> => {
  await SQCoreMotion.subscribeStepCount()

  EventEmitter.addListener('update_step_count', (stepCount) => {
    callback(stepCount)
  })
}

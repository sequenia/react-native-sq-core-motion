import { NativeModules } from 'react-native';

/** @internal */
const { SQCoreMotion } = NativeModules;

export const unSubscribeStepCount = async (): Promise<void> => {
  await SQCoreMotion.unSubscribeStepCount()
}

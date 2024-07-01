import { NativeModules } from 'react-native';

/** @internal */
const { SQCoreMotion } = NativeModules;

export const unSubscribeDistance = async (): Promise<void> => {
  await SQCoreMotion.unSubscribeDistance()
}

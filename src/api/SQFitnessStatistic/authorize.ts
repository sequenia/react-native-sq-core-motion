import { NativeModules } from 'react-native';

/** @internal */
const { SQFitnessStatistic } = NativeModules;

export const authorize = async (): Promise<boolean> => {
  return SQFitnessStatistic.authorize() ?? false
}

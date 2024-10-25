import { NativeModules } from 'react-native';
import type FitnessDataType from '../../entity/FitnessDataType';

/** @internal */
const { SQFitnessStatistic } = NativeModules;

export const authorizationStatus = async (
  type: FitnessDataType
): Promise<boolean> => {
  return SQFitnessStatistic.authorizationStatus(type) ?? false
}

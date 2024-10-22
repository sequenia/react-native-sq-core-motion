import { NativeModules } from 'react-native';
import FitnessDataType from "react-native-sq-core-motion/src/entity/FitnessDataType"

/** @internal */
const { SQFitnessStatistic } = NativeModules;

export const authorizationStatus = async (
  type: FitnessDataType
): Promise<boolean> => {
  return SQFitnessStatistic.authorizationStatus(type) ?? false
}

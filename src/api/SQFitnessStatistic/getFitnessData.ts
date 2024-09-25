import { NativeModules } from 'react-native';
import FitnessDataType from "../../entity/FitnessDataType"

/** @internal */
const { SQFitnessStatistic } = NativeModules;

export const getFitnessData = async (): Promise<{ [key: string]: any }> => {
  const startDate = "2024-08-17T09:45:00Z"
  const endDate = "2024-09-19T12:45:00Z"
  const type = FitnessDataType.StepCount

  return SQFitnessStatistic.getFitnessData(type, startDate, endDate);
};

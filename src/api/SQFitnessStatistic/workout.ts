import { NativeModules } from 'react-native';

/** @internal */
const { SQFitnessStatistic } = NativeModules;

export const getWorkoutData = async (
  type: string,
  startDate: string,
  endDate: string
): Promise<{ [key: string]: any }[]> => {
  return SQFitnessStatistic.getWorkoutData(type, startDate, endDate);
};

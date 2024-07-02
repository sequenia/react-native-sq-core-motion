import { NativeModules } from 'react-native'
import { NativeEventEmitter } from 'react-native'

/** @internal */
const { SQCoreMotion } = NativeModules
const EventEmitter = new NativeEventEmitter(SQCoreMotion)

const subscribeDistance = async (
  callback: (distance: number) => void
): Promise<void> => {
  await SQCoreMotion.subscribeDistance()

  EventEmitter.addListener('update_distance', (distance) => {
    callback(distance)
  })
}

export default subscribeDistance
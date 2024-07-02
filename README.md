# react-native-sq-core-motion

step counter

## Installation

```sh
npm install git@github.com:sequenia/react-native-sq-core-motion.git#0.2.0
```

## Usage

```js
import { SQCoreMotion } from "react-native-sq-core-motion"

// ...

await SQCoreMotion.subscribeDistance(distance => {
    this.distance = distance
})

// ...

await SQCoreMotion.unSubscribeDistance()

// ...

await SQCoreMotion.subscribeStepCount(stepCount => {
    this.stepCount = stepCount
})

// ...

await SQCoreMotion.unSubscribeStepCount()

```

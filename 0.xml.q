//This file was generated from (Academic) UPPAAL 5.0.0 (rev. 714BA9DB36F49691), 2023-06-21

/*

*/
A[] fsms._0.isFinished == 0 imply not deadlock

/*

*/
A[] fsms._0.isFinished == 1 imply fsms._0.variables.convertedValue.rawValue == fsms._0.environment._sensorReading.wrappedValue.value * 10
A[] fsms._0.isFinished == 1 imply fsms._0.variables.convertedValue.rawValue == fsms._0.environment._sensorReading.wrappedValue.value * 8

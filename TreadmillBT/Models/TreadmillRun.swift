//
//  TreadmillRun.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 24/05/2021.
//

import Foundation

struct TreadmillRun {
    let targetSpeed: Speed
    let currentSpeed: Speed
    let distance: Length
    let duration: Duration
    let raw: [Int]
    
    init(targetSpeed: Double, currentSpeed: Double, distance: Double, distanceOffset: Double, minutes: Double, seconds: Double, hoursOffset: Double, raw: [Int]) {
        self.targetSpeed = Speed(value: targetSpeed, unit: .kilometersPerHour)
        self.currentSpeed = Speed(value: currentSpeed, unit: .kilometersPerHour)
        self.distance = Length(value: distance, unit: .kilometers) + Length(value: distanceOffset * 256, unit: .kilometers)
        let additionalDurationOffset = Duration(value: hoursOffset * 100.0, unit: .minutes)
        self.duration = Duration(value: minutes, unit: .minutes) + Duration(value: seconds, unit: .seconds) + additionalDurationOffset
        self.raw = raw
    }
    
    var timeDisplay: String {
        let seconds = duration.converted(to: .seconds).value
        return Constants.Formatters.durationFormatter.string(from: seconds)!
    }
    
    var calorieBurn: Energy {
        let calorieBurn = (0.0215 * currentSpeed.value - 0.1765 * currentSpeed.value + 0.87210 * currentSpeed.value + 1.4577) * 90.0 * duration.converted(to: .hours).value
        return Energy(value: calorieBurn, unit: .calories)
    }
}

//
//  TreadmillParser.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 24/05/2021.
//

import Foundation

class TreadmillParser {
    class func parse(values: [Int], hoursOffset: Double) -> TreadmillState {
        if values.count == 6 {
            return values[1] == 4 ? .hibernated : .unknown
        }
        
        if values.count == 7 {
            return values[1] == 5 ? .standby : .unknown
        }
        
        if values.count == 18 {
            return parseRunning(values, hoursOffset: hoursOffset)
        }
        
        return .unknown
    }
    
    fileprivate class func parseRunning(_ values: [Int], hoursOffset: Double) -> TreadmillState {
        switch values[3] {
        case 1:
            return .countdown(secondsLeft: values[10])
        case 2:
            return .running(run: parseRun(values, hoursOffset: hoursOffset))
        case 4, 5:
            return .stopping
        default:
            return .unknown
        }
    }
    
    fileprivate class func parseRun(_ values: [Int], hoursOffset: Double) -> TreadmillRun {
        let doubleValues = values.map { Double($0) }
        let targetSpeed = doubleValues[4] / 10.0
        let currentSpeed = doubleValues[5] / 10.0
        let distance = doubleValues[12] / 100.0
        let distanceOffset = doubleValues[11] / 100.0
        let minutes = doubleValues[9]
        let seconds = doubleValues[10]
        
        return TreadmillRun(targetSpeed: targetSpeed,
                            currentSpeed: currentSpeed,
                            distance: distance,
                            distanceOffset: distanceOffset,
                            minutes: minutes,
                            seconds: seconds,
                            hoursOffset: hoursOffset,
                            raw: values)
    }
    
}

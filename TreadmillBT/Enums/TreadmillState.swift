//
//  TreadmillState.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 24/05/2021.
//

import Foundation

enum TreadmillState {
    case unknown
    
    /// Treadmill is turned on, but nothing is being shown on display
    case hibernated
    
    /// Treadmill is turned on, display is being shown and awaits commands
    case standby
    
    case countdown(secondsLeft: Int)
    case running(run: TreadmillRun)
    case stopping

    var asString: String {
        switch self {
        case .hibernated:
            return "Hibernated"
        case .standby:
            return "Standby"
        case let .countdown(secondsLeft):
            return "Countdown \(secondsLeft)"
        case let .running(run):
            return "Running (\(run.currentSpeed), \(run.distance), \(run.timeDisplay))"
        case .stopping:
            return "Stopping"
            
        case .unknown:
            return "Unknown"
        }
    }
}

//
//  Formatters.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 26/05/2021.
//

import Foundation

enum Constants { }

extension Constants {
    enum Formatters {
        // e.g. 12:34
        static let shortTimeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter
        }()
        
        // e.g. 12:34
        static let durationFormatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            return formatter
        }()
        
        // e.g. 1 hr 2 min
        static let durationBriefFormatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .brief
            return formatter
        }()
    }
}

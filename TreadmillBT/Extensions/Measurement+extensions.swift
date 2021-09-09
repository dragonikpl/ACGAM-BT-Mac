//
//  Measurement+extensions.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 25/05/2021.
//

import Foundation

extension Measurement {
    func asString() -> String {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        
        return "\(formatter.string(for: value)!) \(unit.symbol)"
    }
}

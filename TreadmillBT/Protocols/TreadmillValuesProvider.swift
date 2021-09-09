//
//  TreadmillValuesProvider.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 25/05/2021.
//

import Foundation
import Combine

protocol TreadmillValuesProvider {
    var publisher: CurrentValueSubject<[Int], Never> { get }
}

struct DebugTreadmillValuesProvider: TreadmillValuesProvider {
    var publisher = CurrentValueSubject<[Int], Never>([253, 16, 161, 2, 25, 25, 0, 0, 0, 99, 47, 1, 157, 11, 76, 0, 108, 254])
}

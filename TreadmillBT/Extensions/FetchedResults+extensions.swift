//
// Created by Marcin Dziennik on 22/09/2021.
//

import Foundation
import SwiftUI

extension FetchedResults where Element == Run {
    var sumDistance: Length {
        Length(value: reduce(0.0) { $0 + $1.distance}, unit: .kilometers)
    }

    var sumDuration: Duration {
        Duration(value: reduce(0.0) { $0 + $1.duration }, unit: .seconds)
    }

    var sumCalorieBurn: Energy {
        Energy(value: reduce(0) { $0 + $1.calorie }, unit: .calories)
    }
}
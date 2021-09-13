//
// Created by Marcin Dziennik on 09/09/2021.
//

import Foundation
import SwiftUI

protocol UserDataProvider {
    var weight: Mass { get set }
}

struct DebugUserDataProvider: UserDataProvider {
    var weight: Mass = Mass(value: 90, unit: .kilograms)
}
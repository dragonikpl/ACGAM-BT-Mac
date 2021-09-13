//
// Created by Marcin Dziennik on 09/09/2021.
//

import Foundation
import SwiftUI

struct DefaultUserDataProvider: UserDataProvider {

    var weight: Mass {
        get {
            let savedWeight = UserDefaults.standard.double(forKey: UserDefaultsKey.userWeight.rawValue)
            return Mass(value: savedWeight, unit: .kilograms)
        }
        set {
            UserDefaults.standard.set(newValue.converted(to: .kilograms).value, forKey: UserDefaultsKey.userWeight.rawValue)
        }
    }
}
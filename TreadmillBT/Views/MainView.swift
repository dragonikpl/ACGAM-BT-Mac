//
// Created by Marcin Dziennik on 21/09/2021.
//

import Foundation
import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            RunView()
                .tabItem {
                    Text("Run")
                }
            StatsView()
                .tabItem {
                    Text("All stats")
                }
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}


extension Date {
    func startOfDay(using calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: self)
    }

    func startOfWeek(using calendar: Calendar = .current) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }

    func startOfMonth(using calendar: Calendar = .current) -> Date {
        calendar.dateComponents([.calendar, .year, .month], from: self).date!
    }

    func startOfYear(using calendar: Calendar = .current) -> Date {
        calendar.dateComponents([.calendar, .year], from: self).date!
    }
}
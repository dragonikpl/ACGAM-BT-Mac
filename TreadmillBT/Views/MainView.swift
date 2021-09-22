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

struct StatsView: View {
    @State private var statsType: StatType = .week
    @State private var startDate = Date()
    @FetchRequest(fetchRequest: Run.fetchRequest())
    var items: FetchedResults<Run>

    var body: some View {
        VStack {
            Picker("", selection: $statsType) {
                ForEach(StatType.allCases, id: \.self) {
                    Text($0.title).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            HStack {
                Button(action: previousPeriod) {
                    Image(systemName: "arrow.backward")
                }
                StatListView(statType: statsType, startDate: startDate)
                Button(action: nextPeriod) {
                    Image(systemName: "arrow.forward")
                }
            }
        }
    }

    func nextPeriod() {
        startDate = statsType.nextPeriodDate(after: startDate)
    }

    func previousPeriod() {
        startDate = statsType.previousPeriodDate(before: startDate)
    }
}
struct StatListView: View {
    private var statType: StatsView.StatType
    private var fetchRequest: FetchRequest<Run>
    private var items: FetchedResults<Run> { fetchRequest.wrappedValue }
    private var date: Date
    init(statType: StatsView.StatType, startDate: Date) {
        self.statType = statType
        self.date = startDate
        self.fetchRequest = FetchRequest(fetchRequest: Run.fetchRequest(period: statType, startingFrom: startDate))
    }

    var body: some View {
        VStack {
            Text("Stats for \(statType.periodTitle(for: date))")
            Text("Total runs: \(items.count)")
            HStack {
                Text("\(items.sumDistance.asString())")
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity)

                Text("\(Constants.Formatters.durationBriefFormatter.string(from: items.sumDuration.value)!)")
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity)

                Text("\(items.sumCalorieBurn.asString())")
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity)
            }
                    .frame(height: 50)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(5)
                    .padding(10)
            Spacer()
        }
    }

}

extension StatsView {
    enum StatType: String, CaseIterable {
        case day, week, month, year

        var title: String {
            rawValue.capitalized
        }

        func periodTitle(for date: Date) -> String {
            let (dateFrom, dateTo) = periodBoundaries(for: date)
            return "\(dateFrom) - \(dateTo)"
        }

        func predicate(startingDate: Date = Date()) -> NSCompoundPredicate {
            let endDatePredicate = NSPredicate(format: "end != nil")
            let (dateFrom, dateTo) = periodBoundaries(for: startingDate)

            let fromPredicate = NSPredicate(format: "start >= %@", dateFrom as NSDate)
            let toPredicate = NSPredicate(format: "start < %@", dateTo as NSDate)
            return NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, endDatePredicate])
        }

        func periodBoundaries(for date: Date) -> (start: Date, end: Date) {
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            var dateFrom: Date
            var dateTo: Date
            switch self {
            case .day:
                dateFrom = calendar.startOfDay(for: date) // eg. 2016-10-10 00:00:00
                dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
            case .week:
                dateFrom = date.startOfWeek()
                dateTo = calendar.date(byAdding: .day, value: 7, to: dateFrom)!
            case .month:
                dateFrom = date.startOfMonth()
                dateTo = calendar.date(byAdding: .month, value: 1, to: dateFrom)!
            case .year:
                dateFrom = date.startOfYear()
                dateTo = calendar.date(byAdding: .year, value: 1, to: dateFrom)!
            }

            return (start: dateFrom, end: dateTo)
        }

        func previousPeriodDate(before: Date) -> Date {
            periodDate(from: before, withOffset: -1)
        }

        func nextPeriodDate(after: Date) -> Date {
            periodDate(from: after, withOffset: 1)
        }

        private func periodDate(from date: Date, withOffset offset: Int) -> Date {
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local

            switch self {
            case .day:
                return calendar.date(byAdding: .day, value: offset, to: date)!
            case .week:
                return calendar.date(byAdding: .day, value: 7*offset, to: date)!
            case .month:
                return calendar.date(byAdding: .month, value: offset, to: date)!
            case .year:
                return calendar.date(byAdding: .year, value: offset, to: date)!
            }

        }
    }
}

extension Date {
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
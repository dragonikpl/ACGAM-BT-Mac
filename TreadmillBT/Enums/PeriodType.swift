//
// Created by Marcin Dziennik on 27/09/2021.
//

import Foundation

enum PeriodType: String, CaseIterable {
    case day, week, month, year

    var title: String {
        rawValue.capitalized
    }

    func periodTitle(for date: Date) -> String {
        let formatter = Constants.Formatters.dateFormatter
        let (dateFrom, dateTo) = periodBoundaries(for: date)

        switch self {
        case .day:
            return formatter.string(from: dateFrom)
        case .month, .week, .year:
            return "\(formatter.string(from: dateFrom)) - \(formatter.string(from: dateTo))"
        }
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

        return (start: dateFrom, end: min(Date(), dateTo))
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
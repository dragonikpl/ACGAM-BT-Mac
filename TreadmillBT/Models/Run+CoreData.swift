//
//  Run+CoreData.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 26/05/2021.
//

import Foundation
import CoreData

@objc(Run)
public class Run: NSManagedObject {}

extension Run: Identifiable {
    class func fetchRequest(period: StatsView.StatType = .day, startingFrom: Date = Date()) -> NSFetchRequest<Run> {
        let request = NSFetchRequest<Run>(entityName: "Run")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Run.start, ascending: false)]
        request.includesPendingChanges = false
        request.predicate = period.predicate(startingDate: startingFrom)
        return request
    }
    
    @NSManaged public var start: Date
    @NSManaged public var end: Date?
    @NSManaged public var logs: [[Int]]?
    
    class var todaysPredicate: NSCompoundPredicate {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!

        let fromPredicate = NSPredicate(format: "start >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "start < %@", dateTo as NSDate)
        let endDatePredicate = NSPredicate(format: "end != nil")
        return NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, endDatePredicate])
    }
}

extension Run {
    private var lastRun: TreadmillRun? {
        guard let lastLog = logs?.last,
              case let .running(run) = TreadmillParser.parse(values: lastLog, hoursOffset: 0) else {
            return nil
        }
        return run
    }
    
    // ----
    
    var startDisplay: String {
        Constants.Formatters.shortTimeFormatter.string(from: start)
    }
    
    var duration: Double {
        guard let end = end else {
            return 0
        }
        return end.timeIntervalSince(start)
    }
    
    var durationDisplay: String {
        "(\(Constants.Formatters.durationBriefFormatter.string(from: duration)!))"
    }
    
    var index: String {
        guard let number = objectID.uriRepresentation().absoluteString.components(separatedBy: "/").last else {
            return "#?"
        }
        
        return "#\(number.replacingOccurrences(of: "p", with: ""))"
    }
    
    var distance: Double {
        lastRun?.distance.value ?? 0.0
    }
    
    var distanceDisplay: String {
        lastRun?.distance.asString() ?? "- km"
    }
    
    var speedDisplay: String {
        lastRun?.currentSpeed.asString() ?? "- km/h"
    }
    
    var calorie: Double {
        lastRun?.calorieBurn.value ?? 0.0
    }
    
    var calorieDisplay: String {
        Energy(value: calorie, unit: .calories).asString()
    }
}

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
    class func fetchRequest(period: PeriodType = .day, startingFrom: Date = Date()) -> NSFetchRequest<Run> {
        let request = NSFetchRequest<Run>(entityName: "Run")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Run.start, ascending: false)]
        request.includesPendingChanges = false
        request.predicate = period.predicate(startingDate: startingFrom)
        return request
    }

    class func oldest() -> NSFetchRequest<Run>  {
        let request = NSFetchRequest<Run>(entityName: "Run")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Run.start, ascending: true)]
        request.fetchLimit = 1
        request.includesPendingChanges = false
        return request
    }
    
    @NSManaged public var start: Date
    @NSManaged public var end: Date?
    @NSManaged public var logs: [[Int]]?
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

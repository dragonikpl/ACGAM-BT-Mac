//
//  TodaysSummaryView.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 27/05/2021.
//

import SwiftUI

struct TodaysSummaryView: View {
    @FetchRequest(fetchRequest: Run.fetchRequest())
    var items: FetchedResults<Run>
    
    var sumDistance: Length {
        Length(value: items.reduce(0.0) { $0 + $1.distance}, unit: .kilometers)
    }
    
    var sumDuration: Duration {
        Duration(value: items.reduce(0.0) { $0 + $1.duration }, unit: .seconds)
    }
    
    var sumCalorieBurn: Energy {
        Energy(value: items.reduce(0) { $0 + $1.calorie }, unit: .calories)
    }
    
    var body: some View {
        Text("All runs:").font(.headline)
        HStack {
            Text("\(sumDistance.asString())")
                .font(.system(size: 13))
                .frame(maxWidth: .infinity)
        
            Text("\(Constants.Formatters.durationBriefFormatter.string(from: sumDuration.value)!)")
                .font(.system(size: 13))
                .frame(maxWidth: .infinity)
        
            Text("\(sumCalorieBurn.asString())")
                .font(.system(size: 13))
                .frame(maxWidth: .infinity)
        }
        .frame(height: 50)
        .background(Color.green.opacity(0.2))
        .cornerRadius(5)
    }
}

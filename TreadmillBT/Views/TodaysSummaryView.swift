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
        items.sumDistance
    }
    
    var sumDuration: Duration {
        items.sumDuration
    }
    
    var sumCalorieBurn: Energy {
        items.sumCalorieBurn
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

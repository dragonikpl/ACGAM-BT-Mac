//
// Created by Marcin Dziennik on 27/09/2021.
//

import Foundation
import SwiftUI

struct StatListView: View {
    private var statType: PeriodType
    private var fetchRequest: FetchRequest<Run>
    private var items: FetchedResults<Run> { fetchRequest.wrappedValue }
    private var date: Date
    init(statType: PeriodType, startDate: Date) {
        self.statType = statType
        self.date = startDate
        self.fetchRequest = FetchRequest(fetchRequest: Run.fetchRequest(period: statType, startingFrom: startDate))
    }

    var body: some View {
        VStack {
            Text("Stats for")
            Text(statType.periodTitle(for: date))
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
            .padding(5)
            ForEach(items) {
                SingleRunView(run: $0)
            }
            Spacer()
        }
    }

}

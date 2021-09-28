//
// Created by Marcin Dziennik on 27/09/2021.
//

import Foundation
import SwiftUI

struct StatsView: View {
    @State private var statsType: PeriodType = .week
    @State private var startDate = Date()

    @FetchRequest(fetchRequest: Run.oldest())
    private var oldestRun

    private var previousButtonDisabled: Bool {
        guard let oldestRun = oldestRun.first else { return true }
        return oldestRun.start.startOfDay() >= startDate.startOfDay()
    }

    var body: some View {
        VStack {
            Picker("", selection: $statsType) {
                ForEach(PeriodType.allCases, id: \.self) {
                    Text($0.title).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: statsType) { _ in startDate = Date() }
            HStack {
                Button(action: previousPeriod) {
                    Image(systemName: "arrow.backward")
                }.disabled(previousButtonDisabled)
                StatListView(statType: statsType, startDate: startDate)
                Button(action: nextPeriod) {
                    Image(systemName: "arrow.forward")
                }.disabled(startDate.startOfDay() >= Date().startOfDay())
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

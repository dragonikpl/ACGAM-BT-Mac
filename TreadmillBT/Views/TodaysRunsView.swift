//
//  TodaysRunsView.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 27/05/2021.
//

import SwiftUI
    
struct TodaysRunsView: View {
    @FetchRequest(fetchRequest: Run.fetchRequest())
    var items: FetchedResults<Run>
    
    var body: some View {
        ForEach(items) {
            SingleRunView(run: $0)
        }
    }
}

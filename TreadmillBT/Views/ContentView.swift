//
//  ContentView.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 20/05/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionViewModel
    
    var body: some View {
        List {
            RunningView()
                .environmentObject(session)
            TodaysSummaryView()
            TodaysRunsView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let session = SessionViewModel(
            treadmillValuesProvider: DebugTreadmillValuesProvider(),
            context: PersistenceService.preview.viewContext)
        
        return Group {
            ContentView()
                .environment(\.managedObjectContext, PersistenceService.preview.viewContext)
                .environmentObject(session)
                .previewLayout(PreviewLayout.fixed(width: 300, height: 500))
                
        }
    }
}

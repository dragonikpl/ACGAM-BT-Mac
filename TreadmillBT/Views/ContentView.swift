//
//  ContentView.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 20/05/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionViewModel
    @State private var showsSettings = false
    var body: some View {
        if showsSettings == false {
            List {
                RunningView()
                        .environmentObject(session)
                TodaysSummaryView()
                TodaysRunsView()
                HStack {
                    Spacer()
                    Button(action: {
                        self.showsSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        } else {
            VStack {
                SettingsView(isVisible: $showsSettings, userDataProvider: session.userDataProvider)
                        .environmentObject(session)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let session = SessionViewModel(
            treadmillValuesProvider: DebugTreadmillValuesProvider(),
            context: PersistenceService.preview.viewContext,
            userDataProvider: DebugUserDataProvider())
        
        return Group {
            ContentView()
                .environment(\.managedObjectContext, PersistenceService.preview.viewContext)
                .environmentObject(session)
                .previewLayout(PreviewLayout.fixed(width: 300, height: 500))
                
        }
    }
}

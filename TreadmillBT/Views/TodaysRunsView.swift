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
        ForEach(items) { item in
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                    .fill(Color.black.opacity(0.1))
                    .frame(width: 268, height: 50, alignment: .center)
                HStack {
                    Text(item.index)
                        .font(.system(size: 9))
                    Spacer()
                    VStack() {
                        Text("\(item.startDisplay)")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                        Text("\(item.durationDisplay)")
                            .font(.system(size: 10))
                    }
                    Spacer()
                    Text(item.distanceDisplay)
                        .font(.system(size: 10))
                    Text(item.speedDisplay)
                        .font(.system(size: 10))
                    Text(item.calorieDisplay)
                        .font(.system(size: 10))
                }.padding([.trailing, .leading])
            }
        }
    }
}

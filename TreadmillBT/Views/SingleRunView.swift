//
// Created by Marcin Dziennik on 27/09/2021.
//

import Foundation
import SwiftUI

struct SingleRunView: View {
    private let run: Run

    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                .fill(Color.black.opacity(0.1))
                .frame(maxHeight: 50, alignment: .center)
//                .frame(width: 268, height: 50, alignment: .center)
            HStack {
                Text(run.index)
                    .font(.system(size: 9))
                Spacer()
                VStack {
                    Text("\(run.startDisplay)")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                    Text("\(run.durationDisplay)")
                        .font(.system(size: 10))
                }
                Spacer()
                Text(run.distanceDisplay)
                    .font(.system(size: 10))
                Text(run.speedDisplay)
                    .font(.system(size: 10))
                Text(run.calorieDisplay)
                    .font(.system(size: 10))
            }.padding([.trailing, .leading])
        }
    }

    init(run: Run) {
        self.run = run
    }
}
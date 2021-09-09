//
//  RunningView.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 25/05/2021.
//

import SwiftUI

struct RunningView: View {
    @EnvironmentObject var session: SessionViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .fill(Color.black.opacity(0.21))
                .frame(width: 268, height: 100, alignment: .center)

            switch session.currentState {
            case let .running(run):
                runningView(run: run)
            default:
                Text(session.currentState.asString)
                    .font(.system(size: 37))
            }
        }
    }
    
    func runningView(run: TreadmillRun) -> some View {
        VStack {
            Text(run.timeDisplay)
                .font(.system(size: 37))
                .bold()
                .foregroundColor(.green)
            HStack {
                Text(run.distance.asString())
                    .foregroundColor(.white)
                
                Text(run.currentSpeed.asString())
                    .foregroundColor(.white)
                
                Text(run.calorieBurn.asString())
                    .foregroundColor(.white)
            }.frame(width: 250, height: 20)
        }
    }
}

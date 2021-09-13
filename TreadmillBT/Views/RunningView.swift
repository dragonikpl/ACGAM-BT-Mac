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
                runningView(run: UserTreadmillRun(treadmillRun: run, weight: session.userDataProvider.weight))
            default:
                Text(session.currentState.asString)
                    .font(.system(size: 37))
            }
        }
    }
    
    private func runningView(run: UserTreadmillRun) -> some View {
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

private struct UserTreadmillRun {
    let treadmillRun: TreadmillRun
    let weight: Mass

    init(treadmillRun: TreadmillRun, weight: Mass) {
        self.treadmillRun = treadmillRun
        self.weight = weight
    }

    var calorieBurn: Energy {
        let calorieBurn = (0.0215 * treadmillRun.currentSpeed.value - 0.1765 * treadmillRun.currentSpeed.value + 0.87210 * treadmillRun.currentSpeed.value + 1.4577) * weight.value * treadmillRun.duration.converted(to: .hours).value
        return Energy(value: calorieBurn, unit: .calories)
    }

    var currentSpeed: Speed { treadmillRun.currentSpeed }
    var distance: Length { treadmillRun.distance }
    var timeDisplay: String { treadmillRun.timeDisplay }
}
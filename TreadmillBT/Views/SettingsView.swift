//
// Created by Marcin Dziennik on 09/09/2021.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var session: SessionViewModel

    @Binding private var isVisible: Bool

    @State private var weight: Double

    init(isVisible: Binding<Bool>, userDataProvider: UserDataProvider) {
        _isVisible = isVisible
        weight = userDataProvider.weight.value
    }

    var body: some View {
        VStack {
            HStack {
                Button("Back") {
                    isVisible = false
                }
                Spacer()
                Button("Save") {
                    session.userDataProvider.weight = Mass(value: $weight.wrappedValue, unit: .kilograms)
                }
            }
            HStack {
                Text("Weight")
                TextField("Weight", value: $weight, formatter: NumberFormatter()) // @TODO: update on Xcode 13
            }
            Spacer()
        }.padding(10)
    }
}
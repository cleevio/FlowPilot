//
//  SecondView.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import SwiftUI
import FlowPilot
import CleevioUI

struct FirstView: View {
    @ObservedObject var viewModel: FirstViewModel

    var body: some View {
        ScrollView {
            Text("Hello, first coordinator World!")
            Text("Count: \(viewModel.count)")
            AsyncButton("Dismiss") {
                await viewModel.send(action: .dismiss)
            }
            AsyncButton("Continue loop") {
                await viewModel.send(action: .continueLoop)
            }
            AsyncButton("Show second view") {
                await viewModel.send(action: .secondView)
            }
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorPreview { router in
            FirstCoordinator(count: 0, router: router)
        }
    }
}

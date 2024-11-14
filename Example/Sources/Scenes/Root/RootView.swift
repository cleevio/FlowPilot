//
//  RootView.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import SwiftUI
import FlowPilot
import CleevioCore
import CleevioUI

@MainActor
struct RootView: View {
    @ObservedObject var viewModel: RootViewModel

    var valueSelection: String {
        switch viewModel.selectedValue {
        case .none:
            "Not yet decided"
        case .some(true):
            "Selected"
        case .some(false):
            "Not selected"
        }
    }

    var body: some View {
        List {
            Text("Greatest root view ever")
            AsyncButton(action: {
                await viewModel.send(action: .valueSelectionTap)
            }, label: {
                LabeledContent("Selected value:", value: valueSelection)
            })
            AsyncButton("Show first view") {
                await viewModel.send(action: .showFirst)
            }
            AsyncButton("Show second view") {
                await viewModel.send(action: .showSecond)
            }
            AsyncButton("Show modal view") {
                await viewModel.send(action: .showThirdModal)
            }
            AsyncButton("Dismiss") {
                await viewModel.send(action: .dismiss)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorPreview { router in
            RootCoordinator(router: router)
        }
    }
}

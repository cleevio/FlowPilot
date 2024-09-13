//
//  RootView.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import SwiftUI
import CleevioRouters
import CleevioCore

struct RootView: View {
    @ObservedObject var viewModel: RootViewModel

    var body: some View {
        List {
            Text("Greatest root view ever")
            Button("Show first view") {
                viewModel.route.send(.showFirst)
            }
            Button("Show second view") {
                viewModel.route.send(.showSecond)
            }
            Button("Show modal view") {
                viewModel.route.send(.showThirdModal)
            }
            Button("Dismiss") {
                viewModel.route.send(.dismiss)
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

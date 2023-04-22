//
//  SecondView.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import SwiftUI
import CleevioRouters

struct FirstView: View {
    @ObservedObject var viewModel: FirstViewModel

    var body: some View {
        ScrollView {
            Text("Hello, first coordinator World!")
            Text("Count: \(viewModel.count)")
            Button("Dismiss") {
                viewModel.route.send(.dismiss)
            }
            Button("Continue loop") {
                viewModel.route.send(.continueLoop)
            }
            Button("Show second view") {
                viewModel.route.send(.secondView)
            }
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorPreview { router in
            FirstCoordinator(count: 0, router: router, animated: true)
        }
    }
}

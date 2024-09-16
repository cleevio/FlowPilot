//
//  ThirdModalView.swift
//  CleevioCoordinators
//
//  Created by Tomáš Šmerda on 22.08.2024.
//

import SwiftUI
import FlowPilot

struct ThirdModalView: View {
    @ObservedObject var viewModel: ThirdModalViewModel

    var body: some View {
        ScrollView {
            Text("Hello, modal coordinator World!")
            Button("Dismiss") {
                viewModel.route.send(.dismiss)
            }
        }
    }
}

struct ThirdModalView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorPreview { router in
            ThirdModalCoordinator(router: router)
        }
    }
}

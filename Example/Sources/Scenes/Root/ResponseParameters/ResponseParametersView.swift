//
//  ResponseParametersView.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 14.11.2024.
//

import SwiftUI
import FlowPilot
import CleevioUI

@MainActor
struct ResponseParametersView: View {
    @ObservedObject var viewModel: ResponseParametersViewModel

    var body: some View {
        ScrollView {
            Text("Hello, ResponseParameters coordinator World!")
            Toggle("Select value", isOn: $viewModel.value)
            AsyncButton("Save") {
                await viewModel.send(action: .save)
            }
        }
    }
}

struct ResponseParametersView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorPreview { router in
            ResponseParametersCoordinator(parameters: true, router: router)
        }
    }
}

//
//  SecondView.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import SwiftUI
import FlowPilot
import CleevioUI

struct SecondView: View {
    @ObservedObject var viewModel: SecondViewModel

    var body: some View {
        ScrollView {
            Text("Hello, second coordinator World!")
            AsyncButton("Dismiss") {
                await viewModel.send(action: .dismiss)
            }
        }
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorPreview { router in
            SecondCoordinator(router: router)
        }
    }
}

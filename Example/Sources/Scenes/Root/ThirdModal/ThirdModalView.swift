//
//  ThirdModalView.swift
//  CleevioCoordinators
//
//  Created by Tomáš Šmerda on 22.08.2024.
//

import SwiftUI
import FlowPilot
import CleevioUI

struct ThirdModalView: View {
    @ObservedObject var viewModel: ThirdModalViewModel

    var body: some View {
        ScrollView {
            Text("Hello, modal coordinator World!")
            AsyncButton("Dismiss") {
                await viewModel.send(action: .dismiss)
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

//
//  ThirdModalCoordinator.swift
//  CleevioCoordinators
//
//  Created by Tomáš Šmerda on 22.08.2024.
//

import Foundation
import CleevioCore
import FlowPilot

@MainActor
final class ThirdModalCoordinator: BaseCoordinator {
    override func start(animated: Bool = true) {
        let viewModel = ThirdModalViewModel()
        viewModel.routingDelegate = self
        let viewController = BaseHostingController(rootView: ThirdModalView(viewModel: viewModel))
        
        present(viewController, animated: animated)
    }
}

extension ThirdModalCoordinator: ThirdModalViewModelRoutingDelegate {
    func dismiss() async {
        self.dismiss(animated: true)
    }
}

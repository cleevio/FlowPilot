//
//  SecondCoordinator.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import CleevioCore

@MainActor
final class SecondCoordinator: BaseCoordinator {
    override func start(animated: Bool = true) {
        let viewModel = SecondViewModel()
        viewModel.routingDelegate = self

        let viewController = BaseHostingController(rootView: SecondView(viewModel: viewModel))
        
        present(viewController, animated: animated)
    }
}

extension SecondCoordinator: SecondViewModelRoutingDelegate {
    func dismiss() async {
        self.dismiss(animated: true)
    }
}

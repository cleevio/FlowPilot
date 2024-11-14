//
//  ResponseParametersCoordinator.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 14.11.2024.
//

import Foundation
import CleevioCore

@MainActor
final class ResponseParametersCoordinator: BaseResponseParametersCoordinator<Bool, Bool> {
    override func start(animated: Bool = true) {
        let viewModel = ResponseParametersViewModel(value: parameters)
        viewModel.routingDelegate = self

        let viewController = BaseHostingController(rootView: ResponseParametersView(viewModel: viewModel))

        present(viewController, animated: animated)
    }
}

extension ResponseParametersCoordinator: ResponseParametersViewModelRoutingDelegate {
}

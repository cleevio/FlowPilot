//
//  RootCoordinator.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import SwiftUI
import CleevioCore
import FlowPilot

@MainActor
final class RootCoordinator<RouterType: NavigationRouterWrappedRouter>: BaseCoordinator {
    private let navigationRouter: RouterType

    init(router: RouterType) {
        self.navigationRouter = router
        super.init(router: router)
    }

    override func start(animated: Bool = true) {
        let viewModel = RootViewModel()
        viewModel.routingDelegate = self
        let viewController = BaseHostingController(rootView: RootView(viewModel: viewModel))
        
        present(viewController, animated: animated)
    }

    func showFirst() {
        let coordinator = FirstCoordinator(count: 0, router: router)
        
        coordinate(to: coordinator)
        coordinator.delegate = self
    }

    func showSecond() {
        let coordinator = SecondCoordinator(router: router)
        coordinate(to: coordinator)
    }
    
    func showThirdModal() {
        let coordinator = ThirdModalCoordinator(router: router)
        coordinate(to: coordinator)
    }
}

extension RootCoordinator: FirstCoordinatorDelegate, RootViewModelRoutingDelegate {
    func valueSelection(initial: Bool) async throws -> Bool {
        defer {
            childCoordinator(of: ResponseParametersCoordinator.self)?.dismiss()
        }
        return try await coordinate(to: ResponseParametersCoordinator(parameters: initial, router: router)).response()
    }
    
    func dismiss() async {
        self.dismiss(animated: true)
    }
    
    func showSecondView() {
        var viewControllers: [UIViewController] = [navigationRouter.navigationRouterWrapper.navigationRouter.navigationController.viewControllers.first!]
        showSecond()

        viewControllers.append(navigationRouter.navigationRouterWrapper.navigationRouter.navigationController.viewControllers.last!)

        navigationRouter.navigationRouterWrapper.navigationRouter.navigationController.setViewControllers(viewControllers, animated: true)
    }
}

//
//  RootCoordinator.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import SwiftUI
import CleevioCore
import CleevioRouters

@MainActor
final class RootCoordinator<RouterType: NavigationRouterWrappedRouter>: BaseCoordinator {
    private let navigationRouter: RouterType

    init(router: RouterType) {
        self.navigationRouter = router
        super.init(router: router)
    }

    override func start(animated: Bool) {
        let viewModel = RootViewModel()
        let viewController = BaseHostingController(rootView: RootView(viewModel: viewModel))
        
        present(viewController, animated: animated)
        
        viewModel.route
            .sink(receiveValue: { [weak self] route in
                switch route {
                case .showFirst:
                    self?.showFirstCoordinator()
                case .showSecond:
                    self?.showSecondCoordinator()
                case .dismiss:
                    self?.dismiss()
                }
            })
            .store(in: cancelBag)
    }

    func showFirstCoordinator() {
        let coordinator = FirstCoordinator(count: 0, router: router)
        
        coordinate(to: coordinator)
        coordinator.delegate = self
    }

    func showSecondCoordinator() {
        let coordinator = SecondCoordinator(router: router)
        coordinate(to: coordinator)
    }
}

extension RootCoordinator: FirstCoordinatorDelegate {
    func showSecondTap() {
        var viewControllers: [UIViewController] = [navigationRouter.navigationRouterWrapper.navigationRouter.navigationController.viewControllers.first!]
        showSecondCoordinator()

        viewControllers.append(navigationRouter.navigationRouterWrapper.navigationRouter.navigationController.viewControllers.last!)

        navigationRouter.navigationRouterWrapper.navigationRouter.navigationController.setViewControllers(viewControllers, animated: true)
    }
}

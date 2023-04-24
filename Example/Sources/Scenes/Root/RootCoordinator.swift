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

final class RootCoordinator<RouterType: NavigationRouterWrappedRouter>: BaseCoordinator<RouterType> {
    
    override func start() {
        let viewModel = RootViewModel()
        let viewController = BaseHostingController(rootView: RootView(viewModel: viewModel))
        
        present(viewController: viewController)
        
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
        var viewControllers: [UIViewController] = [router.navigationRouterWrapper.navigationRouter.navigationController.viewControllers.first!]
        showSecondCoordinator()
        
        viewControllers.append(router.navigationRouterWrapper.navigationRouter.navigationController.viewControllers.last!)
        
        router.navigationRouterWrapper.navigationRouter.navigationController.setViewControllers(viewControllers, animated: true)
    }
}

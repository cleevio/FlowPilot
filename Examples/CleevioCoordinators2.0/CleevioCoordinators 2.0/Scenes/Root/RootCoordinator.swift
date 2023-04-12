//
//  RootCoordinator.swift
//  CleevioCoordinators 2.0
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import SwiftUI
import CleevioCore
import CleevioRouters

final class RootCoordinator<RouterType: NavigationRouterWrappedRouter>: BaseCoordinator<RouterType> {
    private let cancelBag = CancelBag()
    
    override func start() {
        super.start()

        let viewModel = RootViewModel()
        let viewController = BaseHostingController(rootView: RootView(viewModel: viewModel))
        
        self.present(viewController: viewController)
        
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
        let coordinator = FirstCoordinator(count: 0, router: router, animated: animated, delegate: self)
        
        coordinator.start()
    }

    func showSecondCoordinator() {
        let coordinator = SecondCoordinator(router: router, animated: animated, delegate: self)
        
        coordinator.start()
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

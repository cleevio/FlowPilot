//
//  SecondCoordinator.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import CleevioCore
import CleevioRouters

protocol FirstCoordinatorDelegate: AnyObject {
    func showSecondTap()
}

final class FirstCoordinator<RouterType: Router>: BaseCoordinator<RouterType> {
    private let counter: Int

    public weak var delegate: FirstCoordinatorDelegate?

    init(count: Int, router: RouterType, animated: Bool) {
        self.counter = count + 1
        super.init(router: router, animated: animated)
    }
    
    override func start() {
        let viewModel = FirstViewModel(count: counter)
        let viewController = BaseHostingController(rootView: FirstView(viewModel: viewModel))
        
        present(viewController: viewController)
        
        viewModel.route
            .sink(receiveValue: { [weak self] route in
                guard let self else { return }
                switch route {
                case .dismiss:
                    self.dismiss()
                case .continueLoop:
                    self.showFirstCoordinator()
                case .secondView:
                    self.delegate?.showSecondTap()
                }
            })
            .store(in: cancelBag)
    }

    func showFirstCoordinator() {
        let coordinator = FirstCoordinator(count: counter, router: router, animated: animated)
        coordinator.delegate = self
        coordinate(to: coordinator)
    }
}

extension FirstCoordinator: FirstCoordinatorDelegate {
    func showSecondTap() {
        guard let viewController = viewControllers.first??.navigationController else { return }
        let coordinator = SecondCoordinator(router: ModalRouter(parentViewController: viewController), animated: animated)
        
        coordinate(to: coordinator)
    }
}

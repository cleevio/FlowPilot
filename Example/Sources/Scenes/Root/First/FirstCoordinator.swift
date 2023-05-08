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
    @MainActor func showSecondTap()
}

@MainActor
final class FirstCoordinator: BaseCoordinator {
    private let counter: Int

    public weak var delegate: FirstCoordinatorDelegate?

    init(count: Int, router: some Router) {
        self.counter = count + 1
        super.init(router: router)
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
        let coordinator = FirstCoordinator(count: counter, router: router)
        coordinator.delegate = self
        coordinate(to: coordinator)
    }
}

extension FirstCoordinator: FirstCoordinatorDelegate {
    func showSecondTap() {
        guard let viewController = viewControllers.first??.navigationController else { return }
        let coordinator = SecondCoordinator(router: ModalRouter(parentViewController: viewController))
        
        coordinate(to: coordinator)
    }
}

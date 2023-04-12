//
//  SecondCoordinator.swift
//  CleevioCoordinators 2.0
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import CleevioCore
import CleevioRouters

protocol FirstCoordinatorDelegate: RouterEventDelegate {
    func showSecondTap()
}

final class FirstCoordinator<RouterType: Router>: BaseCoordinator<RouterType> {
    private let cancelBag = CancelBag()
    private let counter: Int

    private weak var delegate: FirstCoordinatorDelegate?

    init(count: Int, router: RouterType, animated: Bool, delegate: FirstCoordinatorDelegate? = nil) {
        self.delegate = delegate
        self.counter = count + 1
        super.init(router: router, animated: animated, delegate: delegate)
    }
    
    override func start() {
        super.start()
        let viewModel = FirstViewModel(count: counter)
        let viewController = BaseHostingController(rootView: FirstView(viewModel: viewModel))
        
        self.present(viewController: viewController)
        
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

    func setDelegate(_ delegate: some FirstCoordinatorDelegate) {
        super.setDelegate(delegate)
        self.delegate = delegate
    }

    func showFirstCoordinator() {
        let coordinator = FirstCoordinator(count: counter, router: router, animated: animated, delegate: self)
        coordinator.start()
    }

    override func onDeinit(of coordinator: Coordinator) {
        
    }

    override func onDismiss(of coordinator: Coordinator, router: some Router) {
        router.dismiss(animated: animated)
    }

    override func onDismissedByRouter(of coordinator: Coordinator, router: some Router) {
        
    }
}

extension FirstCoordinator: FirstCoordinatorDelegate {
    func showSecondTap() {
        guard let viewController = viewControllers.first??.navigationController else { return }
        let coordinator = SecondCoordinator(router: ModalRouter(parentViewController: viewController), animated: animated, delegate: self)
        
        coordinator.start()
    }
}

//
//  SecondCoordinator.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import CleevioCore
import FlowPilot

protocol FirstCoordinatorDelegate: AnyObject {
    func showSecondView() async throws
}

@MainActor
final class FirstCoordinator: BaseCoordinator {
    private let counter: Int

    public weak var delegate: FirstCoordinatorDelegate?

    init(count: Int, router: some Router) {
        self.counter = count + 1
        super.init(router: router)
    }
    
    override func start(animated: Bool = true) {
        let viewModel = FirstViewModel(count: counter)
        viewModel.routingDelegate = self
        let viewController = BaseHostingController(rootView: FirstView(viewModel: viewModel))
        
        present(viewController, animated: animated)
    }

    func showFirstCoordinator() {
        let coordinator = FirstCoordinator(count: counter, router: router)
        coordinator.delegate = self
        coordinate(to: coordinator)
    }
}

extension FirstCoordinator: FirstCoordinatorDelegate, FirstViewModelRoutingDelegate {
    func dismiss() {
        self.dismiss(animated: true)
    }
    
    func continueLoop() async throws {
        showFirstCoordinator()
    }
    
    func showSecondView() {
        guard let viewController = viewControllers.first??.navigationController else { return }
        let coordinator = SecondCoordinator(router: ModalRouter(parentViewController: viewController))
        
        coordinate(to: coordinator)
    }
}

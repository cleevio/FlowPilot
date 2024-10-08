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
    
    override func start(animated: Bool) {
        let viewModel = SecondViewModel()
        let viewController = BaseHostingController(rootView: SecondView(viewModel: viewModel))
        
        present(viewController, animated: animated)
        
        viewModel.route
            .sink(receiveValue: { [weak self] route in
                guard let self else { return }
                switch route {
                case .dismiss:
                    self.dismiss()
                }
            })
            .store(in: cancelBag)
    }
}

//
//  ThirdModalCoordinator.swift
//  CleevioCoordinators
//
//  Created by Tomáš Šmerda on 22.08.2024.
//

import Foundation
import CleevioCore
import CleevioRouters

@MainActor
final class ThirdModalCoordinator: ModalNavigationRouter {
    
    override func start(animated: Bool) {
        let viewModel = ThirdModalViewModel()
        let viewController = BaseHostingController(rootView: ThirdModalView(viewModel: viewModel))
        
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

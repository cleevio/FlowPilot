//
//  SecondCoordinator.swift
//  CleevioCoordinators 2.0
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import CleevioCore

final class SecondCoordinator<RouterType: Router>: BaseCoordinator<RouterType> {
    private let cancelBag = CancelBag()
    
    override func start() {
        let viewModel = SecondViewModel()
        let viewController = BaseHostingController(rootView: SecondView(viewModel: viewModel))
        
        self.present(viewController: viewController)
        
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

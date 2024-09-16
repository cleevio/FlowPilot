//
//  TestCoordinator.swift
//  
//
//  Created by Lukáš Valenta on 21.04.2023.
//

import Foundation
import FlowPilot

@MainActor
protocol SecondCoordinatorDelegate: AnyObject {
    func logoutTapped()
}

@MainActor
final class SecondCoordinator: RouterCoordinator {
    public weak var delegate: SecondCoordinatorDelegate?
    
    override func start(animated: Bool) {
    }
}


#if os(iOS)
@MainActor
final class TestCoordinator<RouterType: Router>: RouterCoordinator, SecondCoordinatorDelegate {
    func logoutTapped() {
        
    }
    
    func showCoordinator() {
        let navigationRouter = NavigationRouter(navigationController: .init())
        let a = SecondCoordinator(router: navigationRouter)
        self.coordinate(to: a)
        a.delegate = self
    }
}
#endif

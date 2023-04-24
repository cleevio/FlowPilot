//
//  TestCoordinator.swift
//  
//
//  Created by Lukáš Valenta on 21.04.2023.
//

import Foundation
import CleevioRouters

protocol SecondCoordinatorDelegate: AnyObject {
    func logoutTapped()
}

final class SecondCoordinator: RouterCoordinator {
    public weak var delegate: SecondCoordinatorDelegate?
    
    override func start() {
    }
}


#if os(iOS)
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

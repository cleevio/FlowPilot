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

final class SecondCoordinator<RouterType: Router>: RouterCoordinator<RouterType> {
    public weak var delegate: SecondCoordinatorDelegate?
    
    override func start() {
    }
}


final class TestCoordinator<RouterType: Router>: RouterCoordinator<RouterType>, SecondCoordinatorDelegate {
    func logoutTapped() {
        
    }
    
    func showCoordinator() {
        let navigationRouter = NavigationRouter(navigationController: .init())
        let a = SecondCoordinator(router: navigationRouter, animated: true)
        self.coordinate(to: a)
        a.delegate = self
    }
}

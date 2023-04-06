//
//  BaseCoordinator.swift
//  CleevioCoordinators 2.0
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import CleevioRouters
import CleevioCore

typealias Router = CleevioRouters.Router

class BaseCoordinator<RouterType: Router>: RouterCoordinator<RouterType> {
    deinit {
        print("BaseCoordinator deinit")
    }
}
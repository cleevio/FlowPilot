//
//  BaseCoordinator.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import CleevioRouters
import CleevioCore

typealias Router = CleevioRouters.Router

@MainActor
class BaseCoordinator: RouterCoordinator {
    let cancelBag = CancelBag()

    deinit {
        print("BaseCoordinator deinit")
    }
}

//
//  BaseCoordinator.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import FlowPilot
import CleevioCore

typealias Router = FlowPilot.Router

@MainActor
class BaseCoordinator: RouterCoordinator {
    let cancelBag = CancelBag()

    deinit {
        print("BaseCoordinator deinit")
    }
}

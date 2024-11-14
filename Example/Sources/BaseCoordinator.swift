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
    deinit {
        print("BaseCoordinator deinit")
    }
}

@MainActor
class BaseResponseParametersCoordinator<Response, Parameters>: FlowPilot.ResponseParametersCoordinator<Response, Parameters> {
    deinit {
        print("BaseResponseParametersCoordinator deinit")
    }
}

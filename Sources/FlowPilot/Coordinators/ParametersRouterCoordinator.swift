//
//  ParametersRouterCoordinator.swift
//  CleevioRouters
//
//  Created by Lukáš Valenta on 14.08.2024.
//

@available(macOS 10.15, *)
open class ParametersRouterCoordinator<Parameters>: RouterCoordinator {
    public var parameters: Parameters

    @inlinable
    public init(parameters: Parameters, router: some Router) {
        self.parameters = parameters
        super.init(router: router)
    }
}

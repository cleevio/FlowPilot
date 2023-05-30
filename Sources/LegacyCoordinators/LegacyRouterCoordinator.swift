//
//  BaseCoordinator+.swift
//  
//
//  Created by Lukáš Valenta on 30.05.2023.
//

import CleevioRouters
import Combine

open class LegacyRouterCoordinator<ResultType>: LegacyBaseCoordinator<RouterResult<ResultType>> {
    public typealias CoordinatingResultType = CoordinatingResult<RouterResult<ResultType>>

    public func coordinate(to coordinator: some Coordinator) -> CoordinatingResultType {
        coordinator.start()
        
        return Empty().eraseToAnyPublisher()
    }
}

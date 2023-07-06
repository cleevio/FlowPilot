//
//  RouterCoordinator.swift
//  
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import CleevioCore
import Combine

@available(macOS 10.15, *)
@MainActor
open class RouterCoordinator: Coordinator {
    /**
     The router used by this coordinator.
     */
    final public var router: AnyRouter

    /**
     Initializes a new router coordinator.
     
     - Parameters:
        - router: The router to use.
        - animated: Whether or not transitions are animated.
        - delegate: An optional `RouterEventDelegate` to set as the delegate.
     */
    @inlinable
    public init(router: some Router) {
        self.router = router.eraseToAnyRouter()
        super.init()
    }

    /**
     Dismisses the coordinator by calling its delegate's `onDismiss` method.
     */
    @inlinable
    open func dismiss(animated: Bool = true) {
        router.dismiss(animated: animated)
    }

    /**
     Presents a view controller using the router
     
     - Parameters:
        - viewController: The view controller to present.
     */
    @inlinable
    open func present(_ viewController: some PlatformViewController, animated: Bool) {
        setAssociatedViewController(viewController)
        router.present(viewController, animated: animated)
    }
}

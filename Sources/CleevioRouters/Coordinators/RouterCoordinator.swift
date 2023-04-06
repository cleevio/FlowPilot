//
//  RouterCoordinator.swift
//  
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import CleevioCore

/**
A delegate protocol for router events.
*/
@available(macOS 10.15, *)
public protocol RouterEventDelegate: CoordinatorEventDelegate {
    /**
     Called when the router should dismiss a coordinator.
     
     - Parameters:
        - coordinator: The coordinator to be dismissed.
        - router: The router dismissing the coordinator.
     */
    func onDismiss(of coordinator: Coordinator, router: some Router)

    /**
     Called when a coordinator is dismissed by the router.
     
     - Parameters:
        - coordinator: The coordinator that is dismissed.
        - router: The router dismissing the coordinator.
     */
    func onDismissedByRouter(of coordinator: Coordinator, router: some Router)

}

@available(macOS 10.15, *)
open class RouterCoordinator<RouterType: Router>: Coordinator, RouterEventDelegate {
    /**
     The router used by this coordinator.
     */
    final public var router: RouterType

    /**
     Whether or not transitions are animated.
     */
    final public var animated: Bool

    private weak var delegate: RouterEventDelegate?
    private let cancelBag = CancelBag()

    /**
     Sets the delegate for router events.
     
     - Parameters:
        - delegate: The delegate for router events.
     */
    open func setDelegate(_ delegate: some RouterEventDelegate) {
        self.delegate = delegate
    }

    /**
     Initializes a new router coordinator.
     
     - Parameters:
        - router: The router to use.
        - animated: Whether or not transitions are animated.
        - delegate: An optional `RouterEventDelegate` to set as the delegate.
     */
    public init(router: RouterType, animated: Bool, delegate: RouterEventDelegate? = nil) {
        self.router = router
        self.animated = animated
        self.delegate = delegate
        super.init(delegate: delegate)
    }

    /**
     Dismisses the coordinator by calling its delegate's `onDismiss` method.
     */
    open func dismiss() {
        delegate?.onDismiss(of: self, router: router) ?? onDismiss(of: self, router: router)
    }

    /**
     Dismisses the coordinator using the router, calling its delegate's `onDismiss` method.
     */
    open func dismissedByRouter() {
        delegate?.onDismissedByRouter(of: self, router: router)
    }

    /**
     Called when a coordinator is dismissed by the router, and removes the coordinator from its parent.
     
     - Parameters:
        - coordinator: The coordinator being dismissed.
        - router: The router dismissing the coordinator.
     */
    open func onDismissedByRouter(of coordinator: Coordinator, router: some Router) {
        removeChildCoordinator(coordinator)
    }

    /**
     Presents a view controller using the router, and sets up a subscription to the view controller's `dismissPublisher`.
     
     - Parameters:
        - viewController: The view controller to present.
     */
    open func present<T: DismissHandler & PlatformViewController>(viewController: T) {
        viewController.dismissPublisher
            .sink(receiveValue: { [weak self] in
                guard let self else { return }
                self.delegate?.onDismissedByRouter(of: self, router: self.router)
            })
            .store(in: cancelBag)
        
        self.present(viewController: viewController as PlatformViewController)
    }

    /**
     Presents a view controller using the router
     
     - Parameters:
        - viewController: The view controller to present.
     */
    open func present<T: PlatformViewController>(viewController: T) {
        setAssociatedViewController(viewController)
        
        router.present(viewController, animated: animated)
    }

    /**
     Called when a coordinator is dismissed, and dismisses the coordinator using the router.
     
     - Parameters:
        - coordinator: The coordinator being dismissed.
        - router: The router dismissing the coordinator.
     */
    open func onDismiss(of coordinator: Coordinator, router: some Router) {
        router.dismiss(animated: animated)
    }
}

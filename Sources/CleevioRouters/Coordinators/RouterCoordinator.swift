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
public protocol RouterEventDelegate: AnyObject {
    /**
     Called when the router should present a coordinator.
     
     - Parameters:
        - coordinator: The coordinator that is presented.
        - router: The router presenting the coordinator.
        - viewController: The ViewController to be presented.
     */
    func onPresent(of viewController: some PlatformViewController, on router: some Router, coordinator: some Coordinator)

    /**
     Called when the router should dismiss a coordinator.
     
     - Parameters:
        - coordinator: The coordinator to be dismissed.
        - router: The router dismissing the coordinator.
     */
    func onDismiss(of coordinator: some Coordinator, router: some Router)

    /**
     Called when a coordinator is dismissed by the router.
     
     - Parameters:
        - coordinator: The coordinator that is dismissed.
        - router: The router dismissing the coordinator.
     */
    func onDismissedByRouter(of coordinator: some Coordinator, router: some Router)

    func isPresentAnimated(of viewController: some PlatformViewController, on router: some Router, coordinator: Coordinator) -> Bool

    func isDismissAnimated(of coordinator: some Coordinator, router: some Router) -> Bool
}

@available(macOS 10.15, *)
public extension RouterEventDelegate {
    /**
     Called when the router should present a coordinator.
     
     - Parameters:
        - coordinator: The coordinator that is presented.
        - router: The router presenting the coordinator.
        - viewController: The ViewController to be presented.
     */
    func onPresent(of viewController: some PlatformViewController, on router: some Router, coordinator: some Coordinator) {
        router.present(viewController, animated: isPresentAnimated(of: viewController, on: router, coordinator: coordinator))
    }

    @inlinable
    func isPresentAnimated(of viewController: some PlatformViewController, on router: some Router, coordinator: some Coordinator) -> Bool {
        true
    }

    @inlinable
    func isDismissAnimated(of coordinator: some Coordinator, router: some Router) -> Bool {
        true
    }
}

@available(macOS 10.15, *)
open class RouterCoordinator: Coordinator, RouterEventDelegate {
    /**
     The router used by this coordinator.
     */
    final public var router: AnyRouter

    public weak var routerEventDelegate: RouterEventDelegate?
    
    private let cancelBag = CancelBag()

    /**
     Initializes a new router coordinator.
     
     - Parameters:
        - router: The router to use.
        - animated: Whether or not transitions are animated.
        - delegate: An optional `RouterEventDelegate` to set as the delegate.
     */
    public init(router: some Router) {
        self.router = router.eraseToAnyRouter()
        super.init()
    }

    /**
     Dismisses the coordinator by calling its delegate's `onDismiss` method.
     */
    open func dismiss() {
        routerEventDelegate?.onDismiss(of: self, router: router) ?? onDismiss(of: self, router: router)
    }

    /**
     Dismisses the coordinator using the router, calling its delegate's `onDismiss` method.
     */
    open func dismissedByRouter() {
        routerEventDelegate?.onDismissedByRouter(of: self, router: router)
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
                self.routerEventDelegate?.onDismissedByRouter(of: self, router: self.router)
            })
            .store(in: cancelBag)
        
        present(viewController: viewController as PlatformViewController)
    }

    /**
     Presents a view controller using the router
     
     - Parameters:
        - viewController: The view controller to present.
     */
    open func present(viewController: some  PlatformViewController) {
        setAssociatedViewController(viewController)
        
        routerEventDelegate?.onPresent(of: viewController, on: router, coordinator: self) ?? onPresent(of: viewController, on: router, coordinator: self)
    }

    /**
     Coordinates with child coordinator, setting this coordinator as the parent of the child coordinator.

     - Parameter coordinator: The child coordinator to coordinate with.

     When a coordinator is coordinated to, it becomes a child coordinator of this coordinator, and is stored weakly in the `childCoordinators` array.

     If the child coordinator is a `RouterEventDelegate`, it will be set as the delegate of this coordinator's router event delegate.

     Subclasses should override this method to coordinate with their child coordinators.
     */
    override open func coordinate(to coordinator: some Coordinator) {
        super.coordinate(to: coordinator)
        if let routerCoordinator = coordinator as? RouterCoordinator {
            routerCoordinator.routerEventDelegate = self
        }
    }

    // MARK: RouterEventDelegate

    /**
     Called when a coordinator is dismissed, and dismisses the coordinator using the router.
     
     - Parameters:
        - coordinator: The coordinator being dismissed.
        - router: The router dismissing the coordinator.
     */
    open func onDismiss(of coordinator: some Coordinator, router: some Router) {
        router.dismiss(animated: isDismissAnimated(of: self, router: router))
    }

    /**
     Called when a coordinator is dismissed by the router, and removes the coordinator from its parent.
     
     - Parameters:
        - coordinator: The coordinator being dismissed.
        - router: The router dismissing the coordinator.
     */
    open func onDismissedByRouter(of coordinator: some Coordinator, router: some Router) {
        removeChildCoordinator(coordinator)
    }

    /**
     Called when the router should present a coordinator.
     
     - Parameters:
        - coordinator: The coordinator that is presented.
        - router: The router presenting the coordinator.
        - viewController: The ViewController to be presented.
     */
    open func onPresent(of viewController: some PlatformViewController, on router: some Router, coordinator: some Coordinator) {
        router.present(viewController, animated: isPresentAnimated(of: viewController, on: router, coordinator: self))
    }
}

//
//  Coordinator.swift
//
//
//  Created by Lukáš Valenta on 31.03.2023.
//

import Foundation
import CleevioCore

#if os(iOS)
import UIKit
/// Typealias for UIViewController on iOS.
public typealias PlatformViewController = UIViewController
#elseif os(macOS)
import AppKit
/// Typealias for NSViewController on macOS.
public typealias PlatformViewController = NSViewController
#endif

/// The `CoordinatorEventDelegate` protocol defines a method that is called when a coordinator is deallocated.
public protocol CoordinatorEventDelegate: AnyObject {
    /// Notifies the delegate that the specified coordinator has been deallocated.
    ///
    /// - Parameter coordinator: The coordinator that has been deallocated.
    func onDeinit(of coordinator: Coordinator)

    /// Notifies the delegate that a parent coordinator has been set.
    ///
    /// - Parameter coordinator: The parent coordinator that has been set.
    func onCoordinationStarted(of coordinator: Coordinator)
}

/// The `Coordinator` class is a base class for coordinator objects. It provides methods for managing child coordinators.
open class Coordinator: CoordinatorEventDelegate {

    /// A dictionary that stores the child coordinators.
    public fileprivate(set) final var childCoordinators: [HashableType<Coordinator>: WeakBox<Coordinator>] = [:]

    /// The unique identifier for the coordinator.
    private var id = UUID()

    /// The view controllers that this coordinator manages. The lifetime of this `Coordinator` object is tied to the lifetime of the view controllers.
    public private(set) final var viewControllers: WeakArray<PlatformViewController> = .init([])

    /// The delegate that receives events related to the coordinator.
    public weak var coordinatorEventDelegate: CoordinatorEventDelegate?

    /// Initializes a new instance of the `Coordinator` class.
    public init() { }

    deinit {
        coordinatorEventDelegate?.onDeinit(of: self)
    }

    /// Sets the associated `PlatformViewController` whose lifecycle determines the lifecycle of the coordinator.
    ///
    /// - Parameter viewController: The associated `PlatformViewController`.
    public final func setAssociatedViewController(_ viewController: PlatformViewController) {
        setAssociatedObject(base: viewController, key: &id, value: self)
        viewControllers.append(viewController)
    }

    /// Returns a child coordinator of the specified type.
    ///
    /// - Parameter type: The type of the child coordinator to return.
    /// - Returns: The child coordinator of the specified type, or `nil` if it doesn't exist.
    public final func childCoordinator<T: Coordinator>(of type: T.Type = T.self) -> T? {
        childCoordinators[type]?.unbox as? T
    }

    /// Removes the child coordinator of the specified type.
    ///
    /// - Parameter type: The type of the child coordinator to remove.
    public final func removeChildCoordinator<T: Coordinator>(of type: T.Type = T.self) {
        childCoordinators[type] = nil
    }

    /// Removes the specified child coordinator.
    ///
    /// - Parameter coordinator: The child coordinator to remove.
    @inlinable
    public final func removeChildCoordinator(_ coordinator: some Coordinator) {
        removeChildCoordinator(of: type(of: coordinator))
    }

    /// Starts the coordinator. Subclasses must provide an implementation of this method.
    open func start() {
        fatalError("Start should always be implemented")
    }

    /**
     Coordinates with child coordinator, setting this coordinator as the parent of the child coordinator.

     - Parameter coordinator: The child coordinator to coordinate with.

     When a coordinator is coordinated to, it becomes a child coordinator of this coordinator, and is stored weakly in the `childCoordinators` array.
     */
    open func coordinate(to coordinator: some Coordinator) {
        onCoordinationStarted(of: coordinator)
        coordinator.start()
        coordinator.coordinatorEventDelegate = self
    }

    // MARK: CoordinatorEventDelegate

    /// Notifies the delegate that the specified coordinator has been deallocated.
    ///
    /// - Parameter coordinator: The coordinator that has been deallocated.
    open func onDeinit(of coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }

    /// Notifies the delegate that a parent coordinator has been set.
    ///
    /// - Parameter coordinator: The parent coordinator that has been set.
    open func onCoordinationStarted(of coordinator: Coordinator) {
        childCoordinators[type(of: coordinator)] = WeakBox(coordinator)
    }
}

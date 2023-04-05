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
    func setParentCoordinator(of coordinator: Coordinator)
}

/// The `Coordinator` class is a base class for coordinator objects. It provides methods for managing child coordinators.
open class Coordinator: CoordinatorEventDelegate {
    /// Dictionary that stores the child coordinators.
    public final var childCoordinators: [HashableType<Coordinator>: WeakBox<Coordinator>] = [:]

    private var id = UUID()

    /// The view controller that this coordinator manages. Lifetime of this Coordinator is tied on lifetime of the ViewController.
    public private(set) final var viewControllers: WeakArray<PlatformViewController> = .init([])

    private weak var delegate: CoordinatorEventDelegate?

    /// Initializes a new instance of the `Coordinator` class with an optional delegate.
    ///
    /// - Parameter delegate: An optional `CoordinatorEventDelegate` to set as the delegate.
    public init(delegate: CoordinatorEventDelegate? = nil) {
        self.delegate = delegate
    }

    deinit {
        delegate?.onDeinit(of: self)
    }

    /// Sets a delegate of type CoordinatorEventDelegate that is called when the coordinator is deallocated.
    ///
    /// - Parameter delegate: The delegate to set.
    open func setDelegate(_ delegate: some CoordinatorEventDelegate) {
        self.delegate = delegate
    }

    /// Sets an associated ViewController whose lifecycle determines the lifecycle of the coordinator
    ///
    /// - Parameter viewController: The associated PlatformViewController
    public final func setAssociatedViewController(_ viewController: PlatformViewController) {
        setAssociatedObject(base: viewController, key: &id, value: self)
        viewControllers.append(viewController)
    }

    /// Returns a child coordinator of the specified type.
    ///
    /// - Parameter type: The type of the child coordinator to return.
    /// - Returns: The child coordinator of the specified type, or `nil` if it doesn't exist.
    @inlinable
    public final func childCoordinator<T: Coordinator>(of type: T.Type = T.self) -> T? {
        return childCoordinators[type]?.unbox as? T
    }

    /// Removes the child coordinator of the specified type.
    ///
    /// - Parameter type: The type of the child coordinator to remove.
    @inlinable
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
        fatalError("Implementation of start is required")
    }
}

extension CoordinatorEventDelegate where Self: Coordinator {
    /// Called on a child coordinator deinit
    public func onDeinit(of coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }

    /// Sets the parent coordinator of a child coordinator.
    ///
    /// - Parameter coordinator: The child coordinator to set the parent coordinator for.
    @inlinable public func setParentCoordinator(of coordinator: Coordinator) {
        self.childCoordinators[type(of: coordinator)] = WeakBox(coordinator)
    }
}

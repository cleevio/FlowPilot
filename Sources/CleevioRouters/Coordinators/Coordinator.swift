//
//  Coordinator.swift
//
//
//  Created by Lukáš Valenta on 31.03.2023.
//

import Foundation
import CleevioCore
import OrderedCollections

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
@available(macOS 10.15, *)
public protocol CoordinatorEventDelegate: AnyObject, Sendable {
    /// Notifies the delegate that the specified coordinator has been deallocated.
    ///
    /// Use this method to inform the delegate that a specific coordinator has been deallocated. The method can be called by the coordinator itself during its deallocation process.
    ///
    /// - Parameters:
    ///   - type: The type of the coordinator that has been deallocated.
    ///   - identifier: The specific identifier that specifies the coordinator. Use `nil` if the coordinator is not identified.
    @MainActor
    func onDeinit<T: Coordinator>(of type: T.Type, identifier: String?)

    /// Notifies the delegate that a parent coordinator has been set.
    ///
    /// - Parameter coordinator: The parent coordinator that has been set.
    @MainActor
    func onCoordinationStarted(of coordinator: some Coordinator)
}

@available(macOS 10.15, *)
public typealias ChildCoordinatorCollection = LazyMapSequence<LazyFilterSequence<LazyMapSequence<LazySequence<OrderedDictionary<IdentifiedHashableType<Coordinator>, WeakBox<Coordinator>>.Values>.Elements, Coordinator?>>, Coordinator>

/// The `Coordinator` class is a base class for coordinator objects. It provides methods for managing child coordinators.
@available(macOS 10.15, *)
@MainActor
open class Coordinator: CoordinatorEventDelegate {
    struct RootViewControllerNotFound: LocalizedError {
        var viewControllerCount: Int

        var errorDescription: String? {
            "No valid rootViewController found."
        }
        
        var failureReason: String? {
            if viewControllerCount == 0 {
                "The rootViewController may have been accessed before the start(animated:) function was called, or no view controller was presented."
            } else {
                "All \(viewControllerCount) view controllers have been deallocated."
            }
        }
        
        var recoverySuggestion: String? {
            "Ensure that the rootViewController is set correctly and that view controllers are not deallocated prematurely / the lifecycle of coordinator does not exceed the lifecycle of its view controllers."
        }
    }
    
    /// A dictionary that stores the child coordinators.
    public private(set) final var _childCoordinators: OrderedDictionary<IdentifiedHashableType<Coordinator>, WeakBox<Coordinator>> = [:]

    /// The child coordinators.
    public var childCoordinators: ChildCoordinatorCollection {
        _childCoordinators.values.lazy.compactMap(\.unbox)
    }

    /// The unique identifier for the coordinator.
    public private(set) var id = UUID()

    /// The view controllers that this coordinator manages. The lifetime of this `Coordinator` object is tied to the lifetime of the view controllers.
    public private(set) final var viewControllers: WeakArray<PlatformViewController> = .init([])

    /// The root view controller managed by this coordinator.
    open var rootViewController: PlatformViewController? {
        get throws {
            guard let rootViewController = viewControllers.first(where: { $0 != nil }) else {
                throw RootViewControllerNotFound(viewControllerCount: viewControllers.count)
            }
            
            return rootViewController
        }
    }

    /// The delegate that receives events related to the coordinator.
    public weak var eventDelegate: CoordinatorEventDelegate?

    /// The identifier of the coordinator. If defined, this identifier becomes necessary to get the type parent's childCoordinators
    nonisolated
    open var identifier: String? { nil }
    
    /// Initializes a new instance of the `Coordinator` class.
    public init() { }

    deinit {
        let typeOfSelf = Self.self
        let identifier = self.identifier

        Task { @MainActor [eventDelegate] in
            eventDelegate?.onDeinit(of: typeOfSelf, identifier: identifier)
        }
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
    /// Use this method to retrieve a child coordinator of a specific type.
    ///
    /// - Parameters:
    ///   - type: The type of the child coordinator to return.
    ///   - identifier: The specific identifier that specifies the child coordinator. Use `nil` if the child coordinator is not identified.
    /// - Returns: The child coordinator of the specified type, or `nil` if it doesn't exist.
    ///
    /// - Note: If the child coordinator has an identifier and it is not provided as a parameter, the method will return `nil`. Make sure to provide the appropriate identifier when necessary to ensure the expected behavior.
    public final func childCoordinator<T: Coordinator>(of type: T.Type = T.self, identifier: String? = nil) -> T? {
        _childCoordinators[type, identifier]?.unbox as? T
    }

    /// Removes the child coordinator of the specified type.
    ///
    /// Use this method to remove a child coordinator of a specific type.
    ///
    /// - Parameters:
    ///   - type: The type of the child coordinator to remove.
    ///   - identifier: The specific identifier that specifies the child coordinator. Use `nil` if the child coordinator is not identified.
    ///
    /// - Note: If the child coordinator has an identifier and it is not provided as a parameter, the method will do nothing. Make sure to provide the appropriate identifier when necessary to ensure the expected behavior.
    public final func removeChildCoordinator<T: Coordinator>(of type: T.Type = T.self, identifier: String? = nil) {
        _childCoordinators[type, identifier] = nil
    }

    /// Removes the specified child coordinator.
    ///
    /// - Parameter coordinator: The child coordinator to remove.
    @inlinable
    public final func removeChildCoordinator(_ coordinator: some Coordinator) {
        removeChildCoordinator(of: type(of: coordinator), identifier: coordinator.identifier)
    }

    /// Starts the coordinator.
    ///
    /// Subclasses must provide an implementation of this method.
    ///
    /// - Parameter animated: Defines whether there should be animation while presenting the coordinator.
    @inlinable
    open func start(animated: Bool = true) {
        fatalError("Start should always be implemented")
    }

    /**
     Coordinates with child coordinator, setting this coordinator as the parent of the child coordinator.

     - Parameter coordinator: The child coordinator to coordinate with.

     When a coordinator is coordinated to, it becomes a child coordinator of this coordinator and is stored weakly in the `childCoordinators` array.
     /// - Parameter animated: Defines whether there should be animation while presenting the coordinator.
     */
    @inlinable
    open func coordinate(to coordinator: some Coordinator, animated: Bool = true) {
        onCoordinationStarted(of: coordinator)
        coordinator.start(animated: animated)
        coordinator.eventDelegate = self
    }

    // MARK: CoordinatorEventDelegate

    @inlinable
    @MainActor
    open func onDeinit<T: Coordinator>(of type: T.Type, identifier: String?) {
        removeChildCoordinator(of: type, identifier: identifier)
    }

    open func onCoordinationStarted(of coordinator: some Coordinator) {
        _childCoordinators[type(of: coordinator), coordinator.identifier] = WeakBox(coordinator)
    }
}

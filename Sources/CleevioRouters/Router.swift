//
//  Router.swift
//
//  Created by Thành Đỗ Long on 17.03.2021.
//

import CleevioCore
import Foundation
import Combine

/// A protocol that defines the common behavior of a router that can present and dismiss view controllers.
@available(macOS 10.15, *)
public protocol Router: AnyObject, DismissHandler {
    /// Presents a view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to present.
    ///   - animated: A Boolean value that indicates whether the presentation should be animated.
    func present(_ viewController: PlatformViewController, animated: Bool)

    /// Dismisses a view controller.
    ///
    /// - Parameters:
    ///   - animated: A Boolean value that indicates whether the dismissal should be animated.
    ///   - completion: The block to execute after the dismissal finishes. This block has no return value and takes no parameters.
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

@available(macOS 10.15, *)
public extension Router {
    /// Dismisses a view controller.
    ///
    /// This is a convenience method that calls `dismiss(animated:completion:)` with a `nil` completion block.
    ///
    /// - Parameter animated: A Boolean value that indicates whether the dismissal should be animated.
    @inlinable
    func dismiss(animated: Bool) {
        self.dismiss(animated: animated, completion: nil)
    }
}

/// A protocol that extends the `Router` protocol with a property for accessing the `NavigationRouterWrapper` instance.
public protocol NavigationRouterWrappedRouter: Router {
    var navigationRouterWrapper: NavigationRouterWrapper { get }
}

extension CleevioRouters.ModalNavigationRouter: NavigationRouterWrappedRouter { }
extension CleevioRouters.WindowNavigationRouter: NavigationRouterWrappedRouter { }

extension CleevioRouters.NavigationRouter: NavigationRouterWrappedRouter {
    /// Gets the `NavigationRouterWrapper` instance associated with this navigation router.
    public var navigationRouterWrapper: CleevioRouters.NavigationRouterWrapper {
        .init(navigationRouter: self)
    }
}


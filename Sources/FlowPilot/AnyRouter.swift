//
//  AnyRouter.swift
//  
//
//  Created by Lukáš Valenta on 24.04.2023.
//

import Foundation

/**
 A type-erased router that can present and dismiss view controllers using the underlying platform-specific router.
 
 - Note: This class conforms to the `Router` protocol, which defines the basic functionality for presenting and dismissing view controllers. The `AnyRouter` class can be used to hide the specific type of router being used, while still providing the same interface for presenting and dismissing view controllers.
 */
@MainActor
final public class AnyRouter: Router {
    /// The closure to invoke when presenting a view controller.
    @usableFromInline
    let presentAction: (PlatformViewController, Bool) -> Void
    
    /// The closure to invoke when dismissing a view controller.
    @usableFromInline
    let dismissAction: (Bool, (() -> Void)?) -> Void

    /// The closure to invoke when dismissing the whole router
    @usableFromInline
    let dismissRouterAction: (Bool, (() -> Void)?) -> Void

    /**
     Initializes a new instance of `AnyRouter` with the given presentation and dismissal actions.
     
     - Parameters:
        - presentAction: The closure to invoke when presenting a view controller.
        - dismissAction: The closure to invoke when dismissing a view controller.
     
     - Note: Both `presentAction` and `dismissAction` closures are stored as properties to be used later when presenting or dismissing a view controller. The closures should take into account the platform-specific APIs when performing their respective actions.
     */
    @inlinable
    init(presentAction: @escaping @MainActor (PlatformViewController, Bool) -> Void,
         dismissAction: @escaping @MainActor (Bool, (() -> Void)?) -> Void,
         dismissRouterAction: @escaping @MainActor (Bool, (() -> Void)?) -> Void) {
        self.presentAction = presentAction
        self.dismissAction = dismissAction
        self.dismissRouterAction = dismissRouterAction
    }
    
    /**
     Presents the given view controller using the platform-specific router.
     
     - Parameters:
        - viewController: The view controller to present.
        - animated: A boolean value indicating whether the presentation should be animated.
     
     - Note: This method delegates to the `presentAction` closure provided during initialization, passing in the given view controller and the `animated` value. The closure should use the appropriate platform-specific API to present the view controller.
     */
    @inlinable
    public func present(_ viewController: PlatformViewController, animated: Bool) {
        presentAction(viewController, animated)
    }

    /**
     Dismisses the currently presented view controller using the platform-specific router.
     
     - Parameters:
        - animated: A boolean value indicating whether the dismissal should be animated.
        - completion: An optional closure to invoke after the dismissal animation is completed.
     
     - Note: This method delegates to the `dismissAction` closure provided during initialization, passing in the `animated` value and the `completion` closure if one is provided. The closure should use the appropriate platform-specific API to dismiss the view controller.
     */
    @inlinable
    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        dismissAction(animated, completion)
    }

    /**
     Returns `self` as an instance of `AnyRouter`.
     
     - Returns: An instance of `AnyRouter`.
     
     - Note: This method is used to erase the specific type of router being used and return an instance of `AnyRouter` instead. This can be useful for scenarios where you need to hide the specific implementation details of the router.
     */
    @inlinable
    public func eraseToAnyRouter() -> AnyRouter {
        self
    }

    @inlinable
    public func dismissRouter(animated: Bool, completion: (() -> Void)?) {
        dismissRouterAction(animated, completion)
    }
}


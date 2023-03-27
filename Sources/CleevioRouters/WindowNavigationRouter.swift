//
//  WindowNavigationRouter.swift
//  
//
//  Created by Lukáš Valenta on 10.01.2023.
//

import UIKit
#if !COCOAPODS
import CleevioCore
#endif

open class WindowNavigationRouter: WindowRouter {
    // MARK: - Instance Properties

    public let navigationRouterWrapper: NavigationRouterWrapper

    // MARK: - Object Lifecycle

    public init(
        window: UIWindow,
        navigationRouter: NavigationRouter,
        presentationStyle: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle? = nil,
        navigationAnimation: NavigationRouter.NavigationAnimation = .default
    ) {
        self.navigationRouterWrapper = NavigationRouterWrapper(navigationRouter: navigationRouter)

        super.init(window: window)
    }

    // MARK: - Router

    override open func present(_ viewController: UIViewController, animated: Bool) {
        navigationRouterWrapper.present(viewController, animated: animated, mainRouterPresentingFunction: super.present)
    }

    override open func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationRouterWrapper.dismiss(animated: animated, completion: completion, mainRouterDismissingAction: super.dismiss)
    }

    open func perform(_ action: NavigationRouterWrapper.Action, animated: Bool, completion: (() -> Void)? = nil) {
        navigationRouterWrapper.perform(action, animated: animated, completion: completion, mainRouterDismissAction: super.dismiss)
    }
}

extension WindowNavigationRouter {
    convenience public init(
        window: UIWindow,
        navigationController: UINavigationController = .init(),
        presentationStyle: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle? = nil,
        navigationAnimation: NavigationRouter.NavigationAnimation = .default
    ) {
       let navigationRouter = NavigationRouter(
            navigationController: navigationController,
            animation: navigationAnimation
        )
        
        self.init(
            window: window,
            navigationRouter: navigationRouter,
            presentationStyle: presentationStyle,
            transitionStyle: transitionStyle,
            navigationAnimation: navigationAnimation
        )
    }
}

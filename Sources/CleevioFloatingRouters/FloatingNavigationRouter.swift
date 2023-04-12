//
//  FloatingPanelNavigationRouter.swift
//  
//
//  Created by Lukáš Valenta on 28.12.2022.
//

#if os(iOS)
import Foundation
import UIKit
import CleevioRouters
import FloatingPanel

open class FloatingPanelNavigationRouter: FloatingPanelRouter {
    let navigationRouterWrapper: NavigationRouterWrapper
    
    public init(
        parentViewController: UIViewController,
        layout: FloatingPanelLayout,
        floatingPanelController: FloatingPanelController = .init(),
        navigationRouter: NavigationRouter
    ) {
        self.navigationRouterWrapper = NavigationRouterWrapper(navigationRouter: navigationRouter)
        super.init(
            parentViewController: parentViewController,
            layout: layout,
            floatingPanelController: floatingPanelController
        )
    }
    
    override public func present(_ viewController: UIViewController, animated: Bool) {
        navigationRouterWrapper.present(viewController, animated: animated, mainRouterPresentingFunction: super.present)
    }

    override public func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationRouterWrapper.dismiss(animated: animated, completion: completion, mainRouterDismissingAction: super.dismiss)
    }

    public func perform(_ action: NavigationRouterWrapper.Action, animated: Bool, completion: (() -> Void)? = nil) {
        navigationRouterWrapper.perform(action, animated: animated, mainRouterDismissAction: super.dismiss)
    }
}

extension FloatingPanelNavigationRouter {
    convenience public init(
        parentViewController: UIViewController,
        layout: FloatingPanelLayout,
        floatingPanelController: FloatingPanelController = .init(),
        navigationController: UINavigationController = UINavigationController(),
        navigationAnimation: NavigationRouter.NavigationAnimation = .default
    ) {
        
        let navigationRouter = NavigationRouter(
            navigationController: navigationController,
            animation: navigationAnimation
        )

        self.init(
            parentViewController: parentViewController,
            layout: layout,
            floatingPanelController: floatingPanelController,
            navigationRouter: navigationRouter
        )
    }
}
#endif

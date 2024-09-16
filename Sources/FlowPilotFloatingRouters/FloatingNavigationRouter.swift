//
//  FloatingPanelNavigationRouter.swift
//  
//
//  Created by Lukáš Valenta on 28.12.2022.
//

#if os(iOS)
import Foundation
import UIKit
import FlowPilot
import FloatingPanel

@MainActor
open class FloatingPanelNavigationRouter: FloatingPanelRouter {
    let navigationRouterWrapper: NavigationRouterWrapper
    
    public init(
        parentViewController: UIViewController,
        layout: FloatingPanelLayout,
        floatingPanelController: FloatingPanelController? = nil,
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
        floatingPanelController: FloatingPanelController? = nil,
        navigationController: UINavigationController? = nil,
        navigationAnimation: NavigationRouter.NavigationAnimation = .default
    ) {
        
        let navigationRouter = NavigationRouter(
            navigationController: navigationController ?? .init(),
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

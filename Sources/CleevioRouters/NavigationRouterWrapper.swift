//
//  NavigationRouterWrapper.swift
//  
//
//  Created by Lukáš Valenta on 30.12.2022.
//

import Foundation
import UIKit

open class NavigationRouterWrapper {
    public let navigationRouter: NavigationRouter
    
    public init(navigationRouter: NavigationRouter) {
        self.navigationRouter = navigationRouter
    }
    
    open func present(_ viewController: UIViewController, animated: Bool, mainRouterPresentingFunction: (UIViewController, Bool) -> ()) {
        let mainRouterNeedsToBePresented = !navigationRouter.hasPresentedRootViewController

        navigationRouter.present(viewController, animated: mainRouterNeedsToBePresented ? false : animated)

        if mainRouterNeedsToBePresented {
            mainRouterPresentingFunction(navigationRouter.navigationController, animated)
        }
    }

    open func dismiss(animated: Bool, completion: (() -> Void)?, mainRouterDismissingAction: ((Bool, (() -> Void)?) -> Void)) {
        let mainRouterNeedsToBeDismissed = !navigationRouter.hasAnyPushedControllers

        perform(mainRouterNeedsToBeDismissed ? .dismiss : .pop(.toParent), animated: animated, completion: completion, mainRouterDismissAction: mainRouterDismissingAction)
    }

    open func perform(_ action: Action, animated: Bool, completion: (() -> Void)? = nil, mainRouterDismissAction: ((Bool, (() -> Void)?) -> Void)) {
        switch action {
        case let .pop(popAction):
            navigationRouter.perform(popAction, animated: animated, completion: completion)
        case .dismiss:
            let dismissCompletion = { [navigationRouter] in
                completion?()
                navigationRouter.navigationController.viewControllers = []
            }
            mainRouterDismissAction(animated, dismissCompletion)
        }
    }
}

public extension NavigationRouterWrapper {
    enum Action {
        /// Pop in the stack.
        case pop(NavigationRouter.PopAction)
        /// Dismisses the most recently presented screen.
        case dismiss
    }

}

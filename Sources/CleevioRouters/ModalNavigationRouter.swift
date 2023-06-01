//
//  ModalRouter.swift
//
//  Created by Thành Đỗ Long on 24.03.2021.
//

#if os(iOS)
import UIKit
import CleevioCore

@MainActor
open class ModalNavigationRouter: ModalRouter {

    // MARK: - Instance Properties
    public let navigationRouterWrapper: NavigationRouterWrapper
    
    // MARK: - Object Lifecycle

    public init(
        parentViewController: UIViewController,
        presentationStyle: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle? = nil,
        modalConfiguration: ModalConfiguration? = nil,
        navigationRouter: NavigationRouter
    ) {
        self.navigationRouterWrapper = NavigationRouterWrapper(navigationRouter: navigationRouter)

        super.init(
            parentViewController: parentViewController,
            presentationStyle: presentationStyle,
            transitionStyle: transitionStyle,
            configuration: modalConfiguration
        )
    }

    // MARK: - Router
    @inlinable
    open override func present(_ viewController: UIViewController, animated: Bool) {
        navigationRouterWrapper.present(viewController, animated: animated, mainRouterPresentingFunction: super.present)
    }

    @inlinable
    open override func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationRouterWrapper.dismiss(animated: animated, completion: completion, mainRouterDismissingAction: super.dismiss)
    }

    @inlinable
    open func perform(_ action: NavigationRouterWrapper.Action, animated: Bool, completion: (() -> Void)? = nil) {
        navigationRouterWrapper.perform(action, animated: animated, completion: completion, mainRouterDismissAction: super.dismiss)
    }
    
    @objc open override func dismissRouterObjC() {
        perform(.dismiss, animated: true)
    }

    open override func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        super.presentationControllerDidDismiss(presentationController)
        navigationRouterWrapper.navigationRouter.navigationController.viewControllers = []
    }

    open override func setDismissImage(on viewController: UIViewController) {
        if viewController === navigationRouterWrapper.navigationRouter.navigationController, let firstViewController = navigationRouterWrapper.navigationRouter.navigationController.viewControllers.first {
            super.setDismissImage(on: firstViewController)
        } else {
            super.setDismissImage(on: viewController)
        }
    }

    open override func dismissRouter(animated: Bool, completion: (() -> Void)?) {
        navigationRouterWrapper.navigationRouter.dismissRouter(animated: animated, completion: nil)
        super.dismissRouter(animated: animated, completion: completion)
    }
}

extension ModalNavigationRouter {
    @MainActor
    convenience public init(
        parentViewController: UIViewController,
        navigationController: UINavigationController? = nil,
        presentationStyle: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle? = nil,
        configuration: ModalConfiguration? = nil,
        navigationAnimation: NavigationRouter.NavigationAnimation = .default
    ) {
        let navigationRouter = NavigationRouter(
            navigationController: navigationController ?? .init(),
            animation: navigationAnimation
        )
        
        self.init(
            parentViewController: parentViewController,
            presentationStyle: presentationStyle,
            transitionStyle: transitionStyle,
            modalConfiguration: configuration,
            navigationRouter: navigationRouter
        )
    }
}
#endif

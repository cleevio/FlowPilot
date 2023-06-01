//
//  WindowRouter.swift
//  
//
//  Created by Lukáš Valenta on 10.01.2023.
//

#if os(iOS)
import UIKit
import CleevioCore

@MainActor
open class WindowRouter: Router {
    public var dismissPublisher: ActionSubject<Void> = .init()
    
    public let window: UIWindow!

    public init(window: UIWindow) {
        self.window = window
    }

    open func present(_ viewController: UIViewController, animated: Bool) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()

        guard animated else { return }
        UIView.transition(
            with: window,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }

    open func dismiss(animated: Bool, completion: (() -> Void)?) {
        dismissRouter(animated: animated, completion: completion)
    }
    
    open func dismissRouter(animated: Bool, completion: (() -> Void)?) {
        let window = self.window
        func handleDismiss() {
            window?.alpha = 0.0
            window?.rootViewController = nil
        }

        guard animated else {
            handleDismiss()
            completion?()
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            handleDismiss()
        } completion: { _ in
            completion?()
        }
    }
}
#endif

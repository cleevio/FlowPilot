//
//  WindowRouter.swift
//  
//
//  Created by Lukáš Valenta on 10.01.2023.
//

#if os(iOS)
import UIKit
import CleevioCore

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
        guard animated else {
            window.alpha = 0.0
            completion?()
            return
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.window.alpha = 0.0
        } completion: { _ in
            completion?()
        }
    }
}
#endif

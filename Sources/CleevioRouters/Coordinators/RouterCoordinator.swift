//
//  File.swift
//  
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import CleevioCore

public protocol RouterEventDelegate: CoordinatorEventDelegate {
    func onDismiss(of coordinator: Coordinator)
    func onDismissedByRouter(of coordinator: Coordinator)
}

@available(macOS 10.15, *)
open class RouterCoordinator<RouterType: Router>: Coordinator, RouterEventDelegate {
    final let router: RouterType
    final let animated: Bool

    private weak var delegate: RouterEventDelegate?

    open func setDelegate(_ delegate: some RouterEventDelegate) {
        self.delegate = delegate
    }

    public init(router: RouterType, animated: Bool) {
        self.router = router
        self.animated = animated
        super.init()
    }

    open override func onDeinit(of coordinator: Coordinator) {
        super.onDeinit(of: coordinator)
        delegate?.onDeinit(of: coordinator)
    }
    
    open func onDismiss(of coordinator: CleevioCore.Coordinator) {
        router.dismiss(animated: animated) { [weak delegate] in
            delegate?.onDismiss(of: coordinator)
        }
    }
    
    open func onDismissedByRouter(of coordinator: CleevioCore.Coordinator) {
        removeChildCoordinator(coordinator)
        delegate?.onDismissedByRouter(of: coordinator)
    }
}

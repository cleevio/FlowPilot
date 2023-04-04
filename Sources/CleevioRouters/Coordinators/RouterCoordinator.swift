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
    final public var router: RouterType
    final public var animated: Bool
    
    private weak var delegate: RouterEventDelegate?
    private let cancelBag = CancelBag()

    open func setDelegate(_ delegate: some RouterEventDelegate) {
        self.delegate = delegate
    }
    
    public init(router: RouterType, animated: Bool) {
        self.router = router
        self.animated = animated
        super.init()
    }
    
    open func dismissByRouter() {
        delegate?.onDismiss(of: self)
    }

    open func dismiss() {
        delegate?.onDismiss(of: self)
    }
    
    open func onDismiss(of coordinator: CleevioCore.Coordinator) {
        router.dismiss(animated: animated)
    }
    
    open func onDismissedByRouter(of coordinator: CleevioCore.Coordinator) {
        removeChildCoordinator(coordinator)
    }
    
    open func present<T: DismissHandler & PlatformViewController>(viewController: T) {
        self.viewController = viewController

        viewController.dismissPublisher
            .sink(receiveValue: { [weak self] in
                guard let self else { return }
                self.delegate?.onDismissedByRouter(of: self)
            })
            .store(in: cancelBag)

        router.present(viewController, animated: animated)
    }
}

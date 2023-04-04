//
//  File.swift
//  
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import CleevioCore

public protocol RouterEventDelegate: CoordinatorEventDelegate {
    func onDismiss(of coordinator: Coordinator, router: some Router)
    func onDismissedByRouter(of coordinator: Coordinator, router: some Router)
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
        delegate?.onDismiss(of: self, router: router)
    }

    open func dismiss() {
        delegate?.onDismiss(of: self, router: router) ?? onDismiss(of: self, router: router)
    }
    
    open func onDismiss(of coordinator: CleevioCore.Coordinator, router: some Router) {
        router.dismiss(animated: animated)
    }
    
    open func onDismissedByRouter(of coordinator: CleevioCore.Coordinator, router: some Router) {
        removeChildCoordinator(coordinator)
    }
    
    open func present<T: DismissHandler & PlatformViewController>(viewController: T) {
        self.viewController = viewController

        viewController.dismissPublisher
            .sink(receiveValue: { [weak self] in
                guard let self else { return }
                self.delegate?.onDismissedByRouter(of: self, router: self.router)
            })
            .store(in: cancelBag)

        router.present(viewController, animated: animated)
    }
}

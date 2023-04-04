//
//  Router.swift
//
//  Created by Thành Đỗ Long on 17.03.2021.
//

import CleevioCore
import Foundation
import Combine

@available(macOS 10.15, *)
public protocol Router: AnyObject, DismissHandler {
    func present(_ viewController: PlatformViewController, animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

@available(macOS 10.15, *)
public extension Router {
    @inlinable
    func dismiss(animated: Bool) {
        self.dismiss(animated: animated, completion: nil)
    }
}

public protocol NavigationRouterWrappedRouter: Router {
    var navigationRouterWrapper: NavigationRouterWrapper { get }
}

extension CleevioRouters.ModalNavigationRouter: NavigationRouterWrappedRouter { }
extension CleevioRouters.WindowNavigationRouter: NavigationRouterWrappedRouter { }
extension CleevioRouters.NavigationRouter: NavigationRouterWrappedRouter {
    public var navigationRouterWrapper: CleevioRouters.NavigationRouterWrapper {
        .init(navigationRouter: self)
    }
}

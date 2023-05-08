//
//  FloatingPanelRouter.swift
//  
//
//  Created by Lukáš Valenta on 28.12.2022.
//

#if os(iOS)
import CleevioRouters
import FloatingPanel
import UIKit
import CleevioCore

@MainActor
open class FloatingPanelRouter: CleevioRouters.Router {
    public let parentViewController: UIViewController
    public let floatingPanelController: FloatingPanelController
        
    @inlinable
    public init(
        parentViewController: UIViewController,
        layout: FloatingPanelLayout,
        floatingPanelController: FloatingPanelController? = nil
    ) {
        self.parentViewController = parentViewController
        let floatingPanelController = floatingPanelController ?? .init()
        floatingPanelController.layout = layout
        self.floatingPanelController = floatingPanelController
    }

    public let dismissPublisher: ActionSubject<Void> = .init()

    public func present(_ viewController: UIViewController, animated: Bool) {
        if floatingPanelController.parent == nil {
            floatingPanelController.addPanel(toParent: parentViewController)
        }
        
        floatingPanelController.set(contentViewController: viewController)
    }
 
    @inlinable
    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        floatingPanelController.set(contentViewController: nil)
        completion?()
    }
}
#endif

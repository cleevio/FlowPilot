//
//  FloatingPanelRouter.swift
//  
//
//  Created by Lukáš Valenta on 28.12.2022.
//

import CleevioRouters
import FloatingPanel
import UIKit
import CleevioCore

open class FloatingPanelRouter: CleevioRouters.Router {
    public let parentViewController: UIViewController
    public let floatingPanelController: FloatingPanelController
        
    public init(
        parentViewController: UIViewController,
        layout: FloatingPanelLayout,
        floatingPanelController: FloatingPanelController = .init()
    ) {
        self.parentViewController = parentViewController
        self.floatingPanelController = floatingPanelController
        floatingPanelController.layout = layout
    }

    public let dismissPublisher: ActionSubject<Void> = .init()

    public func present(_ viewController: UIViewController, animated: Bool) {
        if floatingPanelController.parent == nil {
            floatingPanelController.addPanel(toParent: parentViewController)
        }
        
        floatingPanelController.set(contentViewController: viewController)
    }
    
    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        floatingPanelController.set(contentViewController: nil)
        completion?()
    }
}

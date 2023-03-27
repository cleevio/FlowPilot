//
//  FloatingPanelDelegate.swift
//  
//
//  Created by Lukáš Valenta on 28.12.2022.
//

import Foundation
import UIKit
import FloatingPanel

open class FloatingPanelDelegate {
    public var parentViewController: UIViewController
    public var floatingPanelController: FloatingPanel.FloatingPanelController
    public var onDrag: (() -> Void)?
    public var onFloatingPanelChange: ((FloatingPanelState) -> Void)?
    
    public init(parentViewController: UIViewController, floatingPanelController: FloatingPanel.FloatingPanelController) {
        self.parentViewController = parentViewController
        self.floatingPanelController = floatingPanelController
        initialSetup()
    }
    
    open func initialSetup() {
        floatingPanelController.delegate = self
        floatingPanelController.addPanel(toParent: parentViewController)
    }
    
    open func handleFloatingPanelState(_ state: FloatingPanelState) {
        onFloatingPanelChange?(state)
    }
}

extension FloatingPanelDelegate: FloatingPanelControllerDelegate {
    public func floatingPanelDidChangeState(_ fpc: FloatingPanel.FloatingPanelController) {
        handleFloatingPanelState(fpc.state)
    }
    
    public func floatingPanelWillEndDragging(
        _ fpc: FloatingPanelController,
        withVelocity velocity: CGPoint,
        targetState: UnsafeMutablePointer<FloatingPanelState>
    ) {
        handleFloatingPanelState(targetState.pointee)
    }
    
    public func floatingPanelWillBeginDragging(_ fpc: FloatingPanel.FloatingPanelController) {
        onDrag?()
    }
}

//
//  FloatingPanelDelegate.swift
//  
//
//  Created by Lukáš Valenta on 28.12.2022.
//

#if os(iOS)
import Foundation
import UIKit
import FloatingPanel

@MainActor
open class FloatingPanelDelegate {
    public var parentViewController: UIViewController
    @MainActor public var floatingPanelController: FloatingPanel.FloatingPanelController
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

extension FloatingPanelDelegate: @preconcurrency FloatingPanelControllerDelegate {
    @MainActor public func floatingPanelDidChangeState(_ fpc: FloatingPanel.FloatingPanelController) {
        handleFloatingPanelState(fpc.state)
    }
    
    @MainActor public func floatingPanelWillEndDragging(
        _ fpc: FloatingPanelController,
        withVelocity velocity: CGPoint,
        targetState: UnsafeMutablePointer<FloatingPanelState>
    ) {
        handleFloatingPanelState(targetState.pointee)
    }
    
    @MainActor public func floatingPanelWillBeginDragging(_ fpc: FloatingPanel.FloatingPanelController) {
        onDrag?()
    }
}
#endif

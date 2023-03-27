//
//  FloatingPanelStickerHeaderDelegate.swift
//  
//
//  Created by Lukáš Valenta on 28.12.2022.
//

import SwiftUI
import UIKit
import FloatingPanel

open class FloatingPanelStickerHeaderDelegate: FloatingPanelDelegate {
    public var stickyHeaderController: UIViewController
    public var hidingStickyHeaderAnimationDuration: CGFloat = 0.3

    public init(
        parentViewController: UIViewController,
        stickyHeaderController: UIViewController,
        floatingPanelController: FloatingPanel.FloatingPanelController
    ) {
        self.stickyHeaderController = stickyHeaderController
        super.init(parentViewController: parentViewController, floatingPanelController: floatingPanelController)
    }
    

    override open func initialSetup() {
        super.initialSetup()
        parentViewController.setStickyHeader(stickyHeaderController, followingView: floatingPanelController.surfaceView)
    }

    override open func handleFloatingPanelState(_ state: FloatingPanelState) {
        let stickyContentHidden = state == FloatingPanelState.full
        let opacity: CGFloat = stickyContentHidden ? 0 : 1
        
        if stickyHeaderController.view.alpha != opacity {
            UIView.animate(withDuration: hidingStickyHeaderAnimationDuration) { [weak self] in
                self?.stickyHeaderController.view.alpha = opacity
            }
        }

        super.handleFloatingPanelState(state)
    }
}

public extension FloatingPanelStickerHeaderDelegate {
    convenience init<StickyHeader: View>(parentViewController: UIViewController, stickyHeader: StickyHeader, floatingPanelController: FloatingPanel.FloatingPanelController) {
        self.init(
            parentViewController: parentViewController,
            stickyHeaderController: UIHostingController(rootView: stickyHeader),
            floatingPanelController: floatingPanelController
        )
    }
}

public extension UIViewController {
    func setStickyHeader<StickyHeader: View>(_ stickyHeader: StickyHeader, followingView: UIView) {
        setStickyHeader(UIHostingController(rootView: stickyHeader), followingView: followingView)
    }

    func setStickyHeader(_ stickyHeaderController: UIViewController, followingView: UIView) {
        stickyHeaderController.willMove(toParent: self)

        addChild(stickyHeaderController)

        view.addSubview(stickyHeaderController.view)

        stickyHeaderController.view.backgroundColor = .clear
        stickyHeaderController.view.translatesAutoresizingMaskIntoConstraints = false

        let intrinsicSize = stickyHeaderController.view.intrinsicContentSize

        NSLayoutConstraint.activate([
            stickyHeaderController.view.heightAnchor.constraint(equalToConstant: intrinsicSize.height),
            stickyHeaderController.view.centerXAnchor.constraint(equalTo: followingView.centerXAnchor),
            stickyHeaderController.view.bottomAnchor.constraint(equalTo: followingView.topAnchor)
        ])

        stickyHeaderController.didMove(toParent: self)
    }
}

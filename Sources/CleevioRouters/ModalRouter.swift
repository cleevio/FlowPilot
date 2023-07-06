//
//  ModalRouter.swift
//
//  Created by Thành Đỗ Long on 24.03.2021.
//

#if os(iOS)
import UIKit
import CleevioCore

@available(iOS 15.0, *)
@MainActor
public struct UISheetPresentationControllerOptions {
    public var detents: [UISheetPresentationController.Detent] = [.large()]
    public var selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil
    public var prefersGrabberVisible: Bool
    
    public init(
        detents: [UISheetPresentationController.Detent]? = nil,
        selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        prefersGrabberVisible: Bool
    ) {
        self.detents = detents ?? [.large()]
        self.selectedDetentIdentifier = selectedDetentIdentifier
        self.prefersGrabberVisible = prefersGrabberVisible
    }
}

@MainActor
open class ModalConfiguration {
    final public let onDismiss: (() -> ())?
    final public let dismissImage: DismissImage?

    public init(onDismiss: (() -> ())? = nil,
                dismissImage: ModalConfiguration.DismissImage? = nil) {
        self.onDismiss = onDismiss
        self.dismissImage = dismissImage
    }

    public struct DismissImage {

        public let image: UIImage?
        public let position: Position
        
        public init(image: UIImage? = nil, position: Position) {
            self.image = image
            self.position = position
        }
        
        public enum Position {
            case navigationBarLeading
            case navigationBarTrailing
        }
    }
}

@available(iOS 15.0, *)
@MainActor
final public class ModalSheetConfiguration: ModalConfiguration {
    public let sheetPresentationOptions: UISheetPresentationControllerOptions?

    public init(onDismiss: (() -> ())? = nil,
        dismissImage: ModalConfiguration.DismissImage? = nil,
        sheetPresentationOptions: UISheetPresentationControllerOptions? = nil ) {
        self.sheetPresentationOptions = sheetPresentationOptions
        super.init(onDismiss: onDismiss, dismissImage: dismissImage)
    }
}

@MainActor
open class ModalRouter: NSObject, UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate, DismissHandler, Router {

    // MARK: - Instance Properties

    public unowned let parentViewController: UIViewController
    public let dismissPublisher: ActionSubject<Void> = .init()

    public let presentationStyle: UIModalPresentationStyle
    public let transitionStyle: UIModalTransitionStyle?
    public let configuration: ModalConfiguration?

    // MARK: - Object Lifecycle

    public init(parentViewController: UIViewController,
        presentationStyle: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle? = nil,
        configuration: ModalConfiguration? = nil) {
        self.parentViewController = parentViewController
        self.presentationStyle = presentationStyle
        self.transitionStyle = transitionStyle
        self.configuration = configuration
        
        super.init()
    }
    
    @available(iOS 15.0, *)
    func setupSheetControllerIfNecessary(sheetController: UIViewController) {
        guard let sheetConfiguration = configuration as? ModalSheetConfiguration,
              let sheetPresentationOptions = sheetConfiguration.sheetPresentationOptions,
              let sheetController = sheetController.sheetPresentationController
        else { return }
        
        sheetController.detents = sheetPresentationOptions.detents
        sheetController.selectedDetentIdentifier = sheetPresentationOptions.selectedDetentIdentifier
        sheetController.prefersGrabberVisible = sheetPresentationOptions.prefersGrabberVisible
    }

// MARK: - Router
   
    open func present(_ viewController: UIViewController, animated: Bool) {
        viewController.modalPresentationStyle = presentationStyle
        viewController.presentationController?.delegate = self

        if let transitionStyle = transitionStyle {
            viewController.modalTransitionStyle = transitionStyle
        }
        
        if #available(iOS 15.0, *) {
            setupSheetControllerIfNecessary(sheetController: viewController) // Navigation for NavigationRouter
        }

        parentViewController.definesPresentationContext = true
        parentViewController.present(viewController,
                                     animated: animated,
                                     completion: nil)
        
        setDismissImage(on: viewController)
    }

    open func setDismissImage(on viewController: UIViewController) {
        if let dismissImage = configuration?.dismissImage {
            switch dismissImage.position {
            case .navigationBarLeading:
                viewController.navigationItem.leftBarButtonItem = .init(image: dismissImage.image, style: .plain, target: self, action: #selector(self.dismissRouterObjC))
            case .navigationBarTrailing:
                viewController.navigationItem.rightBarButtonItem = .init(image: dismissImage.image, style: .plain, target: self, action: #selector(self.dismissRouterObjC))
            }
        }
    }

    open func dismiss(animated: Bool, completion: (() -> Void)?) {
        parentViewController.dismiss(animated: animated, completion: { [weak self] in
            self?.configuration?.onDismiss?()
            completion?()
        })
    }

    @objc open func dismissRouterObjC() {
        dismiss(animated: true, completion: nil)
    }

    @inlinable
    open func dismissRouter(animated: Bool, completion: (() -> Void)?) {
        dismiss(animated: animated, completion: completion)
    }

    open func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        dismissPublisher.send()
        dismissPublisher.send(completion: .finished)
    }
}
#endif

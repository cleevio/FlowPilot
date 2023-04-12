//
//  CoordinatorPreview.swift
//  
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import SwiftUI
import CleevioCore

#if os(iOS)
/**
 A view that wraps a `UIViewController` and starts a coordinator. It uses a `PreviewRouterDelegate` to handle coordinator events.
 
 Usage: Use the `CoordinatorPreview` view to wrap a view controller and start a coordinator for that view controller. The `CoordinatorPreview` view handles the setup and management of the coordinator, and also handles the presentation and dismissal of the view controller. It uses a `PreviewRouterDelegate` to handle coordinator events like dismissal and deinit.
 
 Example:
 ```
 CoordinatorPreview(coordinator: { router in
     MyCoordinator(router: router)
 })
 ```
 - Parameters:
     - coordinator: A closure that takes a `NavigationRouter` and returns a `RouterCoordinator<NavigationRouter>`. The closure is used to create and start the coordinator.

 - Returns: A view that wraps a `UIViewController`.
 */

public struct CoordinatorPreview: View {
    let baseViewController: UIViewController
    let delegate: PreviewRouterDelegate<ModalRouter>

    public init(coordinator: (NavigationRouter) -> RouterCoordinator<NavigationRouter>) {
        let baseViewController = UINavigationController()
        let router = NavigationRouter(navigationController: baseViewController)
        self.baseViewController = baseViewController
        let coordinator = coordinator(router)
        self.delegate = .init(router: .init(parentViewController: baseViewController))
        coordinator.setDelegate(delegate)
        coordinator.start()
    }

   public var body: some View {
       UIViewControllerWrapper(viewController: baseViewController)
    }

    struct UIViewControllerWrapper: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}

public enum CoordinatorPreviewResultType {
    case dismissedByRouter
    case dismiss
    case coordinatorDeinit

    var description: String {
        "\(self)"
    }
}

/**
 A coordinator that displays a view with a message based on the `CoordinatorPreviewResultType`. It inherits from `RouterCoordinator` and uses a `CoordinatorPreviewResultType` to determine what message to display.
 
 Usage: Use a `CoordinatorPreviewCoordinator` to display a message when a coordinator is dismissed or deinited. The message is displayed in a view controller that is presented modally.
 

 - Parameters:
     - type: A `CoordinatorPreviewResultType` representing the result type for the coordinator.
     - router: A `RouterType` that conforms to the `Router` protocol.
     - animated: A boolean indicating whether to animate the presentation of the view controller.
 */
@available(macOS 11.0, *)
open class CoordinatorPreviewCoordinator<RouterType: Router>: RouterCoordinator<RouterType> {
    private let type: CoordinatorPreviewResultType
    
    public init(type: CoordinatorPreviewResultType, router: RouterType, animated: Bool) {
        self.type = type
        super.init(router: router, animated: animated)
    }
    
    open override func start() {
        let view = Text(type.description).preferredColorScheme(.dark)
        let viewController = BaseUIHostingController(rootView: view)
        
        present(viewController: viewController)
    }
}

/**
 A delegate for handling coordinator events in a `CoordinatorPreview`. It inherits from `RouterEventDelegate` and uses a `CoordinatorPreviewCoordinator` to display a message when a coordinator is dismissed or deinited.
 
 Usage: Use a `PreviewRouterDelegate` to handle coordinator events like dismissal and deinit in a `CoordinatorPreview`. The delegate creates and starts a `CoordinatorPreviewCoordinator` with the appropriate `CoordinatorPreviewResultType` when an event occurs.
 

 - Parameters:
     - router: A `RouterType` that conforms to the `Router` protocol.
 */
open class PreviewRouterDelegate<RouterType: Router>: RouterEventDelegate {
    let router: RouterType

    public init(router: RouterType) {
        self.router = router
    }

    public func onDeinit(of coordinator: Coordinator) {
        CoordinatorPreviewCoordinator(type: .coordinatorDeinit, router: self.router, animated: true).start()
    }

    public func onDismiss(of coordinator: Coordinator, router: some Router) {
        CoordinatorPreviewCoordinator(type: .dismiss, router: self.router, animated: true).start()
    }

    public func onDismissedByRouter(of coordinator: Coordinator, router: some Router) {
        CoordinatorPreviewCoordinator(type: .dismissedByRouter, router: self.router, animated: true).start()
    }

    public func onCoordinationStarted(of coordinator: Coordinator) {
        
    }
}
#endif

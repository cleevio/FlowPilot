//
//  SwiftUIView.swift
//  
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import SwiftUI
import CleevioCore

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
}

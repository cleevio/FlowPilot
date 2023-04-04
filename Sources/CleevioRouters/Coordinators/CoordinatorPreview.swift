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

    public init(onRouterSetup: (NavigationRouter) -> Coordinator) {
        let baseViewController = UINavigationController()
        let router = NavigationRouter(navigationController: baseViewController)
        self.baseViewController = baseViewController
        onRouterSetup(router).start()
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

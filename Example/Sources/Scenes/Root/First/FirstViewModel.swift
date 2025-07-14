//
//  SecondViewModel.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import Combine

protocol FirstViewModelRoutingDelegate: AnyObject, Sendable {
    @MainActor func dismiss()
    func continueLoop() async throws
    func showSecondView() async throws
}

@MainActor
final class FirstViewModel: ObservableObject {
    var count: Int

    weak var routingDelegate: FirstViewModelRoutingDelegate?

    init(count: Int) {
        self.count = count
    }

    enum Action {
        case dismiss
        case continueLoop
        case secondView
    }

    func send(action: Action) async {
        switch action {
        case .dismiss:
            routingDelegate?.dismiss()
        case .continueLoop:
            try? await routingDelegate?.continueLoop()
        case .secondView:
            try? await routingDelegate?.showSecondView()
        }
    }
}

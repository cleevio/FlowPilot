//
//  RootViewModel.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import Combine

protocol RootViewModelRoutingDelegate: AnyObject {
    func showFirst() async throws
    func showSecondView() async throws
    func showThirdModal() async throws
    func dismiss() async
    func valueSelection(initial: Bool) async throws -> Bool
}

@MainActor
final class RootViewModel: ObservableObject {
    enum Action {
        case showFirst
        case showSecond
        case showThirdModal
        case dismiss
        case valueSelectionTap
    }

    weak var routingDelegate: RootViewModelRoutingDelegate?

    @Published var selectedValue: Bool?

    func send(action: Action) async {
        switch action {
        case .showFirst:
            try? await routingDelegate?.showFirst()
        case .showSecond:
            try? await routingDelegate?.showSecondView()
        case .showThirdModal:
            try? await routingDelegate?.showThirdModal()
        case .dismiss:
            await routingDelegate?.dismiss()
        case .valueSelectionTap:
            selectedValue = try? await routingDelegate?.valueSelection(initial: selectedValue ?? false)
        }
    }
}

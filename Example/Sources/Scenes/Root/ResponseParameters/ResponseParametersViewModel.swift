//
//  ResponseParametersViewModel.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 14.11.2024.
//

import Foundation
import Combine

protocol ResponseParametersViewModelRoutingDelegate: AnyObject, Sendable {
    @MainActor func response(with: Bool)
}

@MainActor
final class ResponseParametersViewModel: ObservableObject {
    weak var routingDelegate: ResponseParametersViewModelRoutingDelegate?

    @Published var value: Bool

    init(value: Bool) {
        self.value = value
    }

    enum Action {
        case save
    }

    func send(action: Action) async {
        switch action {
        case .save:
            routingDelegate?.response(with: value)
        }
    }
}

//
//  ResponseParametersViewModel.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 14.11.2024.
//

import Foundation
import Combine

protocol ResponseParametersViewModelRoutingDelegate: AnyObject {
    func response(with: Bool)
}

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
            await routingDelegate?.response(with: value)
        }
    }
}

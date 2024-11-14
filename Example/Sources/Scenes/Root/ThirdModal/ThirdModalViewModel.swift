//
//  ThirdModalViewModel.swift
//  CleevioCoordinators
//
//  Created by Tomáš Šmerda on 22.08.2024.
//

import Foundation
import Combine

protocol ThirdModalViewModelRoutingDelegate: AnyObject {
    func dismiss() async
}

final class ThirdModalViewModel: ObservableObject {
    weak var routingDelegate: ThirdModalViewModelRoutingDelegate?

    enum Action {
        case dismiss
    }

    func send(action: Action) async {
        switch action {
        case .dismiss:
            await routingDelegate?.dismiss()
        }
    }
}

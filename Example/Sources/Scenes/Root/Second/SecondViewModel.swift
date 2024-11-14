//
//  SecondViewModel.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import Combine

protocol SecondViewModelRoutingDelegate: AnyObject {
    func dismiss() async
}

final class SecondViewModel: ObservableObject {
    weak var routingDelegate: SecondViewModelRoutingDelegate?

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

//
//  SecondVIewModel.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import Combine

final class FirstViewModel: ObservableObject {
    var route: PassthroughSubject<Route, Never> = .init()
    var count: Int

    init(count: Int) {
        self.count = count
    }
    
    enum Route {
        case dismiss
        case continueLoop
        case secondView
    }
}

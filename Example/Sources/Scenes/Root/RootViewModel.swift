//
//  RootViewModel.swift
//  CleevioCoordinators
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import Combine

final class RootViewModel: ObservableObject {
    var route: PassthroughSubject<Route, Never> = .init()
    
    enum Route {
        case showFirst
        case showSecond
        case dismiss
    }
}

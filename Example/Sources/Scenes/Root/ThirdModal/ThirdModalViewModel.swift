//
//  ThirdModalViewModel.swift
//  CleevioCoordinators
//
//  Created by Tomáš Šmerda on 22.08.2024.
//

import Foundation
import Combine

final class ThirdModalViewModel: ObservableObject {
    var route: PassthroughSubject<Route, Never> = .init()
    
    enum Route {
        case dismiss
    }
}

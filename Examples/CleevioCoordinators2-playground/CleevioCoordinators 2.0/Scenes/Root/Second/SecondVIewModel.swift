//
//  SecondVIewModel.swift
//  CleevioCoordinators 2.0
//
//  Created by Lukáš Valenta on 04.04.2023.
//

import Foundation
import Combine

final class SecondViewModel: ObservableObject {
    var route: PassthroughSubject<Route, Never> = .init()
    
    enum Route {
        case dismiss
    }
}

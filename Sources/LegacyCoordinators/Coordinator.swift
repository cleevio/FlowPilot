//
//  Coordinator.swift
//  CleevioUIExample
//
//  Created by Thành Đỗ Long on 14.01.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import CleevioRouters
import Combine

@available(iOS 13.0, macOS 10.15, *)
public typealias CoordinatingResult<T> = AnyPublisher<T, Never>
@available(iOS 13.0, macOS 10.15, *)
public typealias CoordinatingSubject<T> = PassthroughSubject<T, Never>

@available(iOS 13.0, macOS 10.15, *)
@available(*, deprecated, message: "It is expected to use new coordinators from now on")
public protocol LegacyCoordinator {
    associatedtype CoordinationResult

    var identifier: UUID { get }

    @MainActor
    func start() -> CoordinatingResult<CoordinationResult>
}

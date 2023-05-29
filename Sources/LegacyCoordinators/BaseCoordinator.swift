//
//  BaseCoordinator.swift
//  CleevioUIExample
//
//  Created by Thành Đỗ Long on 14.01.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//


import Foundation
import Combine
import CleevioRouters
import CleevioCore

/// Base abstract coordinator generic over the return type of the `start` method.
@available(iOS 13.0, macOS 10.15, *)
@available(*, deprecated, message: "It is expected to use new coordinators from now on")
open class LegacyBaseCoordinator<ResultType>: NSObject, LegacyCoordinator {

    /// Typealias which will allows to access a ResultType of the Coordainator by `CoordinatorName.CoordinationResult`.
    public typealias CoordinationResult = ResultType

    /// Utility `DisposeBag` used by the subclasses.
    public let cancelBag = CancelBag()
    public var cancellable: AnyCancellable?

    /// Unique identifier.
    public let identifier = UUID()
    
    open var hasActiveChildCoordinators: Bool {
        !childCoordinators.isEmpty
    }

    /// Dictionary of the child coordinators. Every child coordinator should be added
    /// to that dictionary in order to keep it in memory.
    /// Key is an `identifier` of the child coordinator and value is the coordinator itself.
    /// Value type is `Any` because Swift doesn't allow to store generic types in the array.
    private var childCoordinators = [UUID: Any]()

    /// Stores coordinator to the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Child coordinator to store.
    private func store<T: LegacyCoordinator>(coordinator: T) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    /// Release coordinator from the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Coordinator to release.
    private func free<T: LegacyCoordinator>(coordinator: T) {
        childCoordinators[coordinator.identifier] = nil
    }

    /// 1. Stores coordinator in a dictionary of child coordinators.
    /// 2. Calls method `start()` on that coordinator.
    /// 3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
    ///
    /// - Parameter coordinator: Coordinator to start.
    /// - Returns: Result of `start()` method.
    open func coordinate<T: LegacyCoordinator, U>(to coordinator: T) -> CoordinatingResult<U> where U == T.CoordinationResult {
        store(coordinator: coordinator)
        return coordinator.start()
            .handleEvents(receiveOutput: { [weak self] _ in self?.free(coordinator: coordinator) })
            .eraseToAnyPublisher()
    }
    
    open func dismissObservable(with popHandler: PopHandler, dismissHandler: DismissHandler) -> AnyPublisher<Void, Never> {
        Future { [weak self] promise in
            guard let self else { return }
            Task { @MainActor in
                self._dismissObservable(with: popHandler, dismissHandler: dismissHandler)
                    .first()
                    .sink(receiveCompletion: { _ in
                        
                    }, receiveValue: { promise(.success(())) })
                    .store(in: self.cancelBag)
            }
        }
        .eraseToAnyPublisher()
    }

    @MainActor
    private func _dismissObservable(with popHandler: PopHandler, dismissHandler: DismissHandler) -> some Publisher<Void, Never> {
        let popped = popHandler.dismissPublisher
        let dismissed = dismissHandler.dismissPublisher
        return Publishers.Merge(popped, dismissed)
    }

    /// Starts job of the coordinator.
    ///
    /// - Returns: Result of coordinator job.
    open func start() -> CoordinatingResult<ResultType> {
        fatalError("Start method should be implemented.")
    }
}

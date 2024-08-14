//
//  CoordinatorTests.swift
//  
//
//  Created by Lukáš Valenta on 06.04.2023.
//

import XCTest
import CleevioRouters

@MainActor
final class CoordinatorTests: XCTestCase {
    func testChildCoordinator() {
        let coordinator = Coordinator()
        let childCoordinator = Coordinator()

        XCTAssertEqual(coordinator.childCoordinators.count, 0)

        // Add child coordinator
        coordinator.coordinate(to: childCoordinator)

        // Verify child coordinator was added
        XCTAssertEqual(coordinator.childCoordinators.count, 1)
        XCTAssertTrue(childCoordinator.eventDelegate === coordinator)

        // Retrieve child coordinator
        let retrievedChildCoordinator = coordinator.childCoordinator(of: Coordinator.self)

        // Verify retrieved child coordinator is the same as the original child coordinator
        XCTAssertTrue(retrievedChildCoordinator === childCoordinator)
        XCTAssertTrue(coordinator.childCoordinator(of: Coordinator.self, identifier: nil) === childCoordinator)

        // Remove child coordinator
        coordinator.removeChildCoordinator(of: Coordinator.self)

        // Verify child coordinator was removed
        XCTAssertEqual(coordinator.childCoordinators.count, 0)
    }

    func testChildCoordinatorIdentified() {
        let coordinator = Coordinator()
        let childCoordinator = IdentifiedCoordinator(identifier: .first)

        XCTAssertEqual(coordinator.childCoordinators.count, 0)

        // Add child coordinator
        coordinator.coordinate(to: childCoordinator)

        // Verify child coordinator was added
        XCTAssertEqual(coordinator.childCoordinators.count, 1)
        XCTAssertTrue(childCoordinator.eventDelegate === coordinator)

        // Retrieve child coordinator
        let retrievedChildCoordinator = coordinator.childCoordinator(of: IdentifiedCoordinator.self, identifier: childCoordinator.identifier)

        // Check it is not found without identifier
        XCTAssertNil(coordinator.childCoordinator(of: IdentifiedCoordinator.self))

        // Check it is not found with wrong identifier
        let wrongIdentifier = IdentifiedCoordinator.Identifier.second.rawValue
        XCTAssertNil(coordinator.childCoordinator(of: IdentifiedCoordinator.self, identifier: wrongIdentifier))

        // Verify retrieved child coordinator is the same as the original child coordinator
        XCTAssertTrue(retrievedChildCoordinator === childCoordinator)

        // Check it is not removed without identifier
        coordinator.removeChildCoordinator(of: IdentifiedCoordinator.self)
        XCTAssertEqual(coordinator.childCoordinators.count, 1)

        // Check it is not removed with wrong identifier
        coordinator.removeChildCoordinator(of: IdentifiedCoordinator.self, identifier: wrongIdentifier)
        XCTAssertEqual(coordinator.childCoordinators.count, 1)

        // Remove child coordinator
        coordinator.removeChildCoordinator(of: IdentifiedCoordinator.self, identifier: childCoordinator.identifier)

        // Verify child coordinator was removed
        XCTAssertEqual(coordinator.childCoordinators.count, 0)
    }

    func testAssociatedViewController() async throws {
        let delegate = MockCoordinatorEventDelegate()
        
        try autoreleasepool {
            let viewController = PlatformViewController()
            let coordinator = Coordinator()
            coordinator.eventDelegate = delegate

            XCTAssertThrowsError(try coordinator.rootViewController)
            XCTAssertEqual(coordinator.viewControllers.count, 0)
            
            // Associate view controller with coordinator
            coordinator.setAssociatedViewController(viewController)
            
            // Verify view controller was associated with coordinator
            XCTAssertEqual(coordinator.viewControllers.count, 1)
            XCTAssertEqual(try coordinator.rootViewController, viewController)
            
            XCTAssertFalse(delegate.onDeinitCalled)
        }
        
        try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 10 )
        await MainActor.run {
            XCTAssertTrue(delegate.onDeinitCalled)
        }
    }

    func testAssociatedMultipleViewControllers() async throws {
        let delegate = MockCoordinatorEventDelegate()
        
        try autoreleasepool {
            let viewController = PlatformViewController()

            try autoreleasepool {
                let coordinator = Coordinator()
                coordinator.eventDelegate = delegate
                XCTAssertThrowsError(try coordinator.rootViewController)

                // Associate view controller with coordinator
                coordinator.setAssociatedViewController(viewController)
                // Verify view controller was associated with coordinator
                XCTAssertEqual(coordinator.viewControllers.count, 1)
                XCTAssertEqual(try coordinator.rootViewController, viewController)
                
                try autoreleasepool {
                    let viewController2 = PlatformViewController()
                    // Associate view controller with coordinator
                    coordinator.setAssociatedViewController(viewController2)
                    // Verify view controller was associated with coordinator
                    XCTAssertEqual(coordinator.viewControllers.count, 2)
                    XCTAssertEqual(try coordinator.rootViewController, viewController)
                }
                
                XCTAssertEqual(nil, coordinator.viewControllers[1], "ViewController1 should not be strongly held")
                XCTAssertFalse(delegate.onDeinitCalled, "Coordinator should not be deinited when only first coordinator is deinited")
            }
            
            XCTAssertFalse(delegate.onDeinitCalled, "Coordinator should not be deinited when only first coordinator is deinited")
        }
        
        try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 10 )
        await MainActor.run {
            XCTAssertTrue(delegate.onDeinitCalled)
        }
    }
    
    func testDelegateDeinit() async throws {
        let delegate = MockCoordinatorEventDelegate()
        
        // Test coordinator deinit
        autoreleasepool {
            let coordinator = Coordinator()
            coordinator.eventDelegate = delegate

            // Test childcoordinator deinit
            autoreleasepool {
                let childCoordinator = Coordinator()
                childCoordinator.eventDelegate = delegate

                // Test onDeinit delegate method is called
                XCTAssertFalse(delegate.onDeinitCalled)
            }
            
            coordinator.removeChildCoordinator(of: Coordinator.self)
            // Following is not possible until we get synchronous deinits
//            XCTAssertTrue(delegate.onDeinitCalled)
            
//            // Set onDeinitCalled to false to check coordinator deinit when it's released
//            delegate.onDeinitCalled = false
//            XCTAssertFalse(delegate.onDeinitCalled)
        }
        
        try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 10 )
        await MainActor.run {
            XCTAssertTrue(delegate.onDeinitCalled)
        }
    }

    func testChildCoordinatorOrder() async throws {
        let coordinator = Coordinator()
        let childCoordinator1 = IdentifiedCoordinator(identifier: .first)
        let childCoordinator2 = IdentifiedCoordinator(identifier: .second)

        // Add child coordinator
        coordinator.coordinate(to: childCoordinator1)
        coordinator.coordinate(to: childCoordinator2)

        // Test order
        XCTAssertEqual(coordinator.childCoordinators.count, 2)
        XCTAssertTrue(coordinator.childCoordinators[0] === childCoordinator1)
        XCTAssertTrue(coordinator.childCoordinators[1] === childCoordinator2)
    }

    func testNoRootViewControllerThrowsError() async throws {
        let coordinator = Coordinator()
        XCTAssertThrowsError(try coordinator.rootViewController)
    }

    func testRootViewControllerReturnsViewController() async throws {
        let coordinator = Coordinator()
        let viewController = PlatformViewController()
        coordinator.setAssociatedViewController(viewController)
        XCTAssertNoThrow(try coordinator.rootViewController)
    }

    func testRootViewControllerReturnsFirstViewController() async throws {
        let coordinator = Coordinator()
        let viewController = PlatformViewController()
        let viewController2 = PlatformViewController()
        coordinator.setAssociatedViewController(viewController)
        coordinator.setAssociatedViewController(viewController2)
        XCTAssertTrue(try coordinator.rootViewController === viewController)
    }

    func testRootViewControllerReturnsFirstNonNilViewController() async throws {
        let coordinator = Coordinator()
        let viewController = PlatformViewController()
        coordinator.setAssociatedViewController(PlatformViewController())
        coordinator.setAssociatedViewController(viewController)
        XCTAssertTrue(try coordinator.rootViewController === viewController)
    }
}

@MainActor
class MockCoordinatorEventDelegate: CoordinatorEventDelegate {    
    var onDeinitCalled = false
    var onCoordinationStartedCalled = false

    func onDeinit<T>(of type: T.Type, identifier: String?) where T : CleevioRouters.Coordinator {
        onDeinitCalled = true
    }

    func onCoordinationStarted(of coordinator: some CleevioRouters.Coordinator) {
        onCoordinationStartedCalled = true
    }
}

class Coordinator: CleevioRouters.Coordinator {
    override func start(animated: Bool) {
        
    }
}

class IdentifiedCoordinator: Coordinator {
    nonisolated let _identifier: Identifier

    init(identifier: Identifier) {
        self._identifier = identifier
        super.init()
    }
    
    enum Identifier: String {
        case first
        case second
    }
    
    override nonisolated var identifier: String? { _identifier.rawValue }
}

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
        XCTAssertTrue(childCoordinator.coordinatorEventDelegate === coordinator)

        // Retrieve child coordinator
        let retrievedChildCoordinator = coordinator.childCoordinator(of: Coordinator.self)

        // Verify retrieved child coordinator is the same as the original child coordinator
        XCTAssertTrue(retrievedChildCoordinator === childCoordinator)

        // Remove child coordinator
        coordinator.removeChildCoordinator(of: Coordinator.self)

        // Verify child coordinator was removed
        XCTAssertEqual(coordinator.childCoordinators.count, 0)
    }

    func testAssociatedViewController() async throws {
        let delegate = MockCoordinatorEventDelegate()
        
        autoreleasepool {
            let viewController = PlatformViewController()
            let coordinator = Coordinator()
            coordinator.coordinatorEventDelegate = delegate

            XCTAssertEqual(coordinator.rootViewController, nil)
            XCTAssertEqual(coordinator.viewControllers.count, 0)
            
            // Associate view controller with coordinator
            coordinator.setAssociatedViewController(viewController)
            
            // Verify view controller was associated with coordinator
            XCTAssertEqual(coordinator.viewControllers.count, 1)
            XCTAssertEqual(coordinator.rootViewController, viewController)
            
            XCTAssertFalse(delegate.onDeinitCalled)
        }
        
        try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 10 )
        await MainActor.run {
            XCTAssertTrue(delegate.onDeinitCalled)
        }
    }

    func testAssociatedMultipleViewControllers() async throws {
        let delegate = MockCoordinatorEventDelegate()
        
        autoreleasepool {
            let viewController = PlatformViewController()

            autoreleasepool {
                let coordinator = Coordinator()
                coordinator.coordinatorEventDelegate = delegate
                XCTAssertEqual(coordinator.rootViewController, nil)

                // Associate view controller with coordinator
                coordinator.setAssociatedViewController(viewController)
                // Verify view controller was associated with coordinator
                XCTAssertEqual(coordinator.viewControllers.count, 1)
                XCTAssertEqual(coordinator.rootViewController, viewController)
                
                autoreleasepool {
                    let viewController2 = PlatformViewController()
                    // Associate view controller with coordinator
                    coordinator.setAssociatedViewController(viewController2)
                    // Verify view controller was associated with coordinator
                    XCTAssertEqual(coordinator.viewControllers.count, 2)
                    XCTAssertEqual(coordinator.rootViewController, viewController)
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
            coordinator.coordinatorEventDelegate = delegate

            // Test childcoordinator deinit
            autoreleasepool {
                let childCoordinator = Coordinator()
                childCoordinator.coordinatorEventDelegate = delegate

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
}

@MainActor
class MockCoordinatorEventDelegate: CoordinatorEventDelegate {    
    var onDeinitCalled = false
    var onCoordinationStartedCalled = false

    func onDeinit<T>(of type: T.Type) where T : CleevioRouters.Coordinator {
        onDeinitCalled = true
    }

    func onCoordinationStarted(of coordinator: some CleevioRouters.Coordinator) {
        onCoordinationStartedCalled = true
    }
}

@MainActor
class Coordinator: CleevioRouters.Coordinator {
    override func start() {
        
    }
}

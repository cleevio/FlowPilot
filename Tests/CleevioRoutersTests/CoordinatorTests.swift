//
//  CoordinatorTests.swift
//  
//
//  Created by Lukáš Valenta on 06.04.2023.
//

import XCTest
import CleevioRouters

final class CoordinatorTests: XCTestCase {
    func testChildCoordinator() {
        let coordinator = Coordinator()
        let childCoordinator = Coordinator()

        XCTAssertEqual(coordinator.childCoordinators.count, 0)

        // Add child coordinator
        coordinator.setParentCoordinator(of: childCoordinator)

        // Verify child coordinator was added
        XCTAssertEqual(coordinator.childCoordinators.count, 1)

        // Retrieve child coordinator
        let retrievedChildCoordinator = coordinator.childCoordinator(of: Coordinator.self)

        // Verify retrieved child coordinator is the same as the original child coordinator
        XCTAssertTrue(retrievedChildCoordinator === childCoordinator)

        // Remove child coordinator
        coordinator.removeChildCoordinator(of: Coordinator.self)

        // Verify child coordinator was removed
        XCTAssertEqual(coordinator.childCoordinators.count, 0)
    }

    func testAssociatedViewController() {
        let viewController = UIViewController()
        let coordinator = Coordinator()

        XCTAssertEqual(coordinator.viewControllers.count, 0)

        // Associate view controller with coordinator
        coordinator.setAssociatedViewController(viewController)

        // Verify view controller was associated with coordinator
        XCTAssertEqual(coordinator.viewControllers.count, 1)
    }
    
    func testDelegateDeinit() {
        class MockCoordinatorEventDelegate: CoordinatorEventDelegate {
            var onDeinitCalled = false
            var setParentCoordinatorCalled = false
            
            func onDeinit(of coordinator: Coordinator) {
                onDeinitCalled = true
            }
        }
        let delegate = MockCoordinatorEventDelegate()
        
        // Test coordinator deinit
        autoreleasepool {
            let coordinator = Coordinator(delegate: delegate)
            
            // Test childcoordinator deinit
            autoreleasepool {
                let childCoordinator = Coordinator(delegate: delegate)
                coordinator.setParentCoordinator(of: childCoordinator)
                
                // Test onDeinit delegate method is called
                XCTAssertFalse(delegate.onDeinitCalled)
            }
            
            coordinator.removeChildCoordinator(of: Coordinator.self)
            XCTAssertTrue(delegate.onDeinitCalled)
            
            // Set onDeinitCalled to false to check coordinator deinit when it's released
            delegate.onDeinitCalled = false
            XCTAssertFalse(delegate.onDeinitCalled)
        }
        
        XCTAssertTrue(delegate.onDeinitCalled)
    }
}


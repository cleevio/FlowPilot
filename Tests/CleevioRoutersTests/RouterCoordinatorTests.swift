//
//  RouterCoordinatorTests.swift
//  
//
//  Created by Lukáš Valenta on 06.04.2023.
//

import XCTest
import CleevioRouters
import CleevioCore

final class RouterCoordinatorTests: XCTestCase {
    func testDismiss() {
        let router = MockRouter()
        let delegate = MockRouterEventDelegate()
        let coordinator = RouterCoordinator<MockRouter>(router: router, animated: true, delegate: delegate)
        
        // Test onDismiss delegate method is called
        XCTAssertFalse(delegate.onDismissCalled)
        coordinator.dismiss()
        XCTAssertTrue(delegate.onDismissCalled)
        
        // Test onDismissedByRouter delegate method is called
        XCTAssertFalse(delegate.onDismissedByRouterCalled)
        coordinator.dismissedByRouter()
        XCTAssertTrue(delegate.onDismissedByRouterCalled)
    }

    func testDeinit() {
        let router = MockRouter()
        let delegate = MockRouterEventDelegate()
        
        // Test coordinator deinit
        autoreleasepool {
            let coordinator = RouterCoordinator<MockRouter>(router: router, animated: true, delegate: delegate)
            
            // Test childcoordinator deinit
            autoreleasepool {
                let childCoordinator = RouterCoordinator<MockRouter>(router: router, animated: true, delegate: delegate)
                coordinator.onSetParentCoordinator(of: childCoordinator)
                
                // Test onDeinit delegate method is called
                XCTAssertFalse(delegate.onDeinitCalled)
            }
            
            coordinator.removeChildCoordinator(of: RouterCoordinator<MockRouter>.self)
            XCTAssertTrue(delegate.onDeinitCalled)
            
            // Set onDeinitCalled to false to check coordinator deinit when it's released
            delegate.onDeinitCalled = false
            XCTAssertFalse(delegate.onDeinitCalled)
        }
        
        XCTAssertTrue(delegate.onDeinitCalled)
    }

    func testDismissOfChildCoordinator() {
        let router = MockRouter()
        let delegate = MockRouterEventDelegate()
        let coordinator = RouterCoordinator<MockRouter>(router: router, animated: true, delegate: delegate)
        let childCoordinator = RouterCoordinator<MockRouter>(router: router, animated: true, delegate: coordinator)

        // Test onDismiss delegate method is called
        XCTAssertFalse(router.dismissCalled)
        childCoordinator.dismiss()
        XCTAssertTrue(router.dismissCalled)
        XCTAssertFalse(delegate.onDismissedByRouterCalled)
    }
}

class MockRouter: Router {
    var dismissCalled = false
    var onPresent: ((PlatformViewController, Bool) -> Void)?
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        dismissCalled = true
    }

    func present(_ viewController: PlatformViewController, animated: Bool) {
        onPresent?(viewController, animated)
    }
}

class MockRouterEventDelegate: MockCoordinatorEventDelegate, RouterEventDelegate {
    var onDismissedByRouterCalled = false
    var onDismissCalled = false

    func onDismiss(of coordinator: Coordinator, router: some Router) {
        onDismissCalled = true
    }
    
    func onDismissedByRouter(of coordinator: Coordinator, router: some Router) {
        onDismissedByRouterCalled = true
    }
}

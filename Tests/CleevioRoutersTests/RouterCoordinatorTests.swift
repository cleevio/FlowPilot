//
//  RouterCoordinatorTests.swift
//  
//
//  Created by Lukáš Valenta on 06.04.2023.
//

import XCTest
import CleevioRouters
import CleevioCore

@MainActor
final class RouterCoordinatorTests: XCTestCase {
    func testDismiss() {
        let router = MockRouter()
        let delegate = MockRouterEventDelegate()
        let coordinator = RouterCoordinator(router: router)
        coordinator.routerEventDelegate = delegate
        coordinator.coordinatorEventDelegate = delegate
        
        // Test onDismiss delegate method is called
        XCTAssertFalse(delegate.onDismissCalled)
        coordinator.dismiss()
        XCTAssertTrue(delegate.onDismissCalled)
    }

    func testDeinit() {
        let router = MockRouter()
        let delegate = MockRouterEventDelegate()
        
        // Test coordinator deinit
        autoreleasepool {
            let coordinator = RouterCoordinator(router: router)
            coordinator.routerEventDelegate = delegate
            coordinator.coordinatorEventDelegate = delegate
            
            // Test childcoordinator deinit
            autoreleasepool {
                let childCoordinator = RouterCoordinator(router: router)
                coordinator.coordinate(to: childCoordinator)
                childCoordinator.routerEventDelegate = delegate
                childCoordinator.coordinatorEventDelegate = delegate
                
                // Test onDeinit delegate method is called
                XCTAssertFalse(delegate.onDeinitCalled)
            }
            
            coordinator.removeChildCoordinator(of: RouterCoordinator.self)
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
        let coordinator = RouterCoordinator(router: router)
        coordinator.routerEventDelegate = delegate
        coordinator.coordinatorEventDelegate = delegate
        let childCoordinator = RouterCoordinator(router: router)
        childCoordinator.routerEventDelegate = coordinator
        childCoordinator.coordinatorEventDelegate = coordinator

        // Test onDismiss delegate method is called
        XCTAssertFalse(router.dismissCalled)
        childCoordinator.dismiss()
        XCTAssertTrue(router.dismissCalled)
        XCTAssertNil(coordinator.childCoordinator(of: RouterCoordinator.self))
    }

    func testCoordinate() {
        let router = MockRouter()
        let delegate = MockRouterEventDelegate()
        
        autoreleasepool {
            let coordinator = RouterCoordinator(router: router)
            coordinator.routerEventDelegate = delegate
            coordinator.coordinatorEventDelegate = delegate
            
            let childCoordinator = RouterCoordinator(router: router)
            coordinator.coordinate(to: childCoordinator)
            
            XCTAssertFalse(delegate.onDeinitCalled)
            XCTAssertTrue(childCoordinator.coordinatorEventDelegate === coordinator)
            XCTAssertTrue(childCoordinator.routerEventDelegate === coordinator)
        }
        
        XCTAssertTrue(delegate.onDeinitCalled)
    }

    func testRouterPresent() {
        func presentHelper(viewController: PlatformViewController, expectedResult: Bool) {
            let expectation = expectation(description: "Expecting animation result")

            let router = MockRouter()
            router.onPresent = { viewControllerToBePresent, animated in
                XCTAssertEqual(animated, expectedResult)
                XCTAssertTrue(viewControllerToBePresent === viewController)
                expectation.fulfill()
            }

            let delegate = MockRouterEventDelegate()
            delegate.animatePresent = expectedResult
            let coordinator = RouterCoordinator(router: router)
            coordinator.routerEventDelegate = delegate

            coordinator.present(viewController)
            
            wait(for: [expectation], timeout: 0.1)
        }

        [true, false].forEach {
            presentHelper(viewController: .init(), expectedResult: $0)
        }
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
    var onDismissCalled = false
    var animatePresent = true
    var animateDismiss = true

    func onDismiss(of coordinator: some CleevioRouters.Coordinator, router: some CleevioRouters.Router) {
        onDismissCalled = true
    }

    func isPresentAnimated(of viewController: some PlatformViewController, on router: some Router, coordinator: some CleevioRouters.Coordinator) -> Bool {
        animatePresent
    }
    
    func isDismissAnimated(of coordinator: some Coordinator, router: some Router) -> Bool {
        animateDismiss
    }
}

open class RouterCoordinator: CleevioRouters.RouterCoordinator {
    override open func start() {
        
    }
}

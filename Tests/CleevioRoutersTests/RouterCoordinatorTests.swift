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
        coordinator.eventDelegate = delegate
        
        // Test onDismiss delegate method is called
        XCTAssertFalse(router.dismissCalled)
        coordinator.dismiss()
        XCTAssertTrue(router.dismissCalled)
    }

    func testDeinit() async throws {
        let router = MockRouter()
        let delegate = MockRouterEventDelegate()
        
        // Test coordinator deinit
        autoreleasepool {
            let coordinator = RouterCoordinator(router: router)
            coordinator.eventDelegate = delegate
            
            // Test childcoordinator deinit
            autoreleasepool {
                let childCoordinator = RouterCoordinator(router: router)
                coordinator.coordinate(to: childCoordinator)
                childCoordinator.eventDelegate = delegate
                
                // Test onDeinit delegate method is called
                XCTAssertFalse(delegate.onDeinitCalled)
            }
            
            coordinator.removeChildCoordinator(of: RouterCoordinator.self)
            // Following is not possible until we get synchronous deinits
//            XCTAssertTrue(delegate.onDeinitCalled)
//            
//            // Set onDeinitCalled to false to check coordinator deinit when it's released
//            delegate.onDeinitCalled = false
//            XCTAssertFalse(delegate.onDeinitCalled)
        }
        
        try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 10 )
        await MainActor.run {
            XCTAssertTrue(delegate.onDeinitCalled)
        }
    }

    func testDismissOfChildCoordinator() {
        let router = MockRouter()
        let delegate = MockRouterEventDelegate()
        let coordinator = RouterCoordinator(router: router)
        coordinator.eventDelegate = delegate
        let childCoordinator = RouterCoordinator(router: router)
        childCoordinator.eventDelegate = coordinator

        // Test onDismiss delegate method is called
        XCTAssertFalse(router.dismissCalled)
        childCoordinator.dismiss()
        XCTAssertTrue(router.dismissCalled)
        XCTAssertNil(coordinator.childCoordinator(of: RouterCoordinator.self))
    }

    func testCoordinate() async throws {
        let router = MockRouter()
        let delegate = MockRouterEventDelegate()
        
        autoreleasepool {
            let coordinator = RouterCoordinator(router: router)
            coordinator.eventDelegate = delegate
            
            let childCoordinator = RouterCoordinator(router: router)
            coordinator.coordinate(to: childCoordinator)
            
            XCTAssertFalse(delegate.onDeinitCalled)
            XCTAssertTrue(childCoordinator.eventDelegate === coordinator)
        }
        
        try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 10 )
        await MainActor.run {
            XCTAssertTrue(delegate.onDeinitCalled)
        }
    }

    func testRouterPresent() {
        func presentHelper(viewController: PlatformViewController,
                           expectedResult: Bool,
                           file: StaticString = #filePath,
                           line: UInt = #line) {
            let expectation = expectation(description: "Expecting animation result")

            let router = MockRouter()
            router.onPresent = { viewControllerToBePresent, animated in
                XCTAssertEqual(animated, expectedResult, file: file, line: line)
                XCTAssertTrue(viewControllerToBePresent === viewController, file: file, line: line)
                expectation.fulfill()
            }

            let coordinator = RouterCoordinator(router: router)

            coordinator.present(viewController, animated: expectedResult)
            
            wait(for: [expectation], timeout: 0.1)
        }

        [true, false].forEach {
            presentHelper(viewController: .init(), expectedResult: $0)
        }
    }
}

class MockRouter: Router {
    var dismissCalled = false
    var dismissRouterCalled = false
    var onPresent: ((PlatformViewController, Bool) -> Void)?

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        dismissCalled = true
    }

    func present(_ viewController: PlatformViewController, animated: Bool) {
        onPresent?(viewController, animated)
    }

    func dismissRouter(animated: Bool, completion: (() -> Void)?) {
        dismissRouterCalled = true
    }
}

class MockRouterEventDelegate: MockCoordinatorEventDelegate { }

open class RouterCoordinator: CleevioRouters.RouterCoordinator {
    override open func start(animated: Bool = true) {
        
    }
}

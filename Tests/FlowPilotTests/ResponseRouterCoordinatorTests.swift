//
//  ResponseRouterCoordinatorTests.swift
//  CleevioRouters
//
//  Created by Lukáš Valenta on 14.08.2024.
//

import XCTest
import FlowPilot
import CleevioCore

@MainActor
final class ResponseRouterCoordinatorTests: XCTestCase {
    func testCoordinateReturnsResponse() async throws {
        let router = MockRouter()
        let delegate = MockRouterEventDelegate()
        let coordinator = ResponseRouterCoordinator<Bool>(router: router)
        coordinator.eventDelegate = delegate

        let routerCoordinator = RouterCoordinator(router: router)

        Task.detached {
            try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 10 )
            await coordinator.response(with: true)
        }

        let response = try await routerCoordinator.coordinate(to: coordinator).response()
        XCTAssertTrue(response)
    }
}

final class ResponseRouterCoordinator<Response>: FlowPilot.ResponseRouterCoordinator<Response> {
    override func start(animated: Bool = true) {
        
    }
}

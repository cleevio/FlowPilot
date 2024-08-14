//
//  Untitled.swift
//  CleevioRouters
//
//  Created by Lukáš Valenta on 14.08.2024.
//

import Foundation
import Combine

@available(macOS 10.15, *)
open class ResponseHandler<Response> {
    private let responseStream = PassthroughSubject<Response, Error>()
    private var cancellable: AnyCancellable?

    @inlinable public init(responseType: Response.Type = Response.self){
        
    }

    deinit {
        self.handleResult(.failure(CancellationError()))
    }
    
    public func response() async throws -> Response {
        try await withUnsafeThrowingContinuation { continuation in
            cancellable =
                responseStream
                .first()
                .sink { completion in
                    guard case .failure(let error) = completion else { return }
                    continuation.resume(throwing: error)
                } receiveValue: { response in
                    continuation.resume(returning: response)
                }
        }
    }

    public func handleResult(_ result: Result<Response, Error>) {
        switch result {
        case let .success(response):
            responseStream.send(response)
        case let .failure(error):
            responseStream.send(completion: .failure(error))
        }
    }
}

@MainActor
protocol ResponseRoutingDelegate<Response>: AnyObject {
    associatedtype Response
    func response(with response: Response)
}

@available(macOS 10.15, *)
@MainActor
open class ResponseRouterCoordinator<Response>: RouterCoordinator, ResponseRoutingDelegate {
    public var onResponse: ((Result<Response, Error>) -> Void)?

    deinit {
        onResponse?(.failure(CancellationError()))
    }

    final public func response(with response: Response) {
        onResponse?(.success(response))
    }
}

//
//  Untitled.swift
//  CleevioRouters
//
//  Created by Lukáš Valenta on 14.08.2024.
//

import Foundation
import Combine

/// A handler class that manages asynchronous responses using Combine’s `PassthroughSubject`.
///
/// This class provides an interface to handle asynchronous response delivery and error management
/// for a specified response type.
/// - Requires: macOS 10.15 or later.
///
/// ## Generics
/// - `Response`: The type of response managed by this handler.
///
/// ## Deinitializer
/// - `deinit`
///     Sends a failure due to cancellation when the handler is deinitialized.
@available(macOS 10.15, *)
open class ResponseHandler<Response: Sendable>: @unchecked Sendable {
    private let responseStream = PassthroughSubject<Response, Error>()
    private var cancellable: AnyCancellable?

    /// - `init(responseType:)`
    ///     Initializes the response handler with a specified response type.
    ///     - Parameter responseType: The type of the response to handle, defaulting to `Response.self`.
    @inlinable public init(responseType: Response.Type = Response.self){
        
    }

    deinit {
        Task { @MainActor [responseStream] in
            Self.handleResult(.failure(CancellationError()), on: responseStream)
        }
    }

    ///     Asynchronously retrieves a response value or throws an error if encountered.
    ///     - Throws: An error if the response stream completes with a failure.
    ///     - Returns: The response value upon successful completion.
    public func response() async throws -> Response {
        try await withUnsafeThrowingContinuation { [responseStream] continuation in
            self.cancellable = responseStream
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
        Self.handleResult(result, on: responseStream)
    }

    ///     Processes a result, either sending a success value or a failure completion to the stream.
    ///     - Parameter result: A result value of type `Result<Response, Error>`.
    private static func handleResult(_ result: Result<Response, Error>, on responseStream: PassthroughSubject<Response, Error>) {
        switch result {
        case let .success(response):
            responseStream.send(response)
        case let .failure(error):
            responseStream.send(completion: .failure(error))
        }
    }
}

/// A delegate protocol for handling and routing responses in a type-safe way, designed to be used with `@MainActor`.
///
/// This protocol defines a required method to process responses of a specific type.
@MainActor
public protocol ResponseRoutingDelegate<Response>: AnyObject {
    /// The type of response that the delegate handles.
    associatedtype Response
    ///     Processes the given response and routes it accordingly.
    ///     - Parameter response: The response to handle.
    func response(with response: Response)
}

/// A coordinator class that handles routing for asynchronous responses and conforms to `ResponseRoutingDelegate`.
///
/// This class facilitates response management and supports routing responses through a callback closure.
/// - Requires: macOS 10.15 or later.
///
/// ## Inheritance
/// Inherits from `RouterCoordinator`.
///
/// ## Generics
/// - `Response`: The type of response that this router handles.
///
/// ## Example Usage
/// This example demonstrates how `ResponseRouterCoordinator` can be used within an application to manage
/// a response flow without needing additional parameters.
///
/// First, in one of your coordinators, include a function to coordinate a response:
/// ```swift
/// func fetchConfirmation() async throws -> Bool {
///     defer {
///         childCoordinator(of: ResponseRouterCoordinator.self)?.dismiss()
///     }
///     return try await coordinate(to: ResponseRouterCoordinator<Bool>(router: router)).response()
/// }
/// ```
///
/// Then, implement the coordinator itself:
/// ```swift
/// @MainActor
/// final class ConfirmationCoordinator: ResponseRouterCoordinator<Bool> {
///     override func start(animated: Bool = true) {
///         let viewModel = ConfirmationViewModel()
///         viewModel.routingDelegate = self
///
///         let viewController = BaseHostingController(rootView: ConfirmationView(viewModel: viewModel))
///
///         present(viewController, animated: animated)
///     }
/// }
///
/// extension ConfirmationCoordinator: ConfirmationViewModelRoutingDelegate { }
/// ```
///
/// In this example:
/// - `fetchConfirmation` initiates a `ResponseRouterCoordinator` to manage a response of type `Bool`.
/// - `ConfirmationCoordinator` is responsible for presenting a view and delegating response handling
///   using a `ConfirmationViewModel` that expects its delegate to implement the `finish(with:)` method.
///
@available(macOS 10.15, *)
@MainActor
open class ResponseRouterCoordinator<Response>: RouterCoordinator, ResponseRoutingDelegate {
    /// An optional closure that takes a `Result<Response, Error>` to handle the result of a response.
    public var onResponse: (@Sendable @MainActor (Result<Response, Error>) -> Void)?

    deinit {
        Task { @MainActor [onResponse] in
            onResponse?(.failure(CancellationError()))
        }
    }

    ///     Sends a successful response to the `onResponse` closure.
    ///     - Parameter response: The response to route.
    final public func response(with response: Response) {
        onResponse?(.success(response))
    }
}

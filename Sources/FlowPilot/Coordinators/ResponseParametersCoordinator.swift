//
//  ResponseParametersCoordinator.swift
//  CleevioRouters
//
//  Created by Lukáš Valenta on 14.08.2024.
//

/// A coordinator class that combines routing of responses with custom parameters, inheriting from `ResponseRouterCoordinator`.
///
/// This class is designed to handle both a response and an associated set of parameters,
/// making it suitable for more complex routing scenarios that require parameterization.
/// - Requires: macOS 10.15 or later.
///
/// ## Inheritance
/// Inherits from `ResponseRouterCoordinator<Response>`.
///
/// ## Generics
/// - `Response`: The type of response managed by this coordinator.
/// - `Parameters`: The type of parameters associated with the routing process.
///
/// ## Example Usage
/// This example demonstrates how `ResponseParametersCoordinator` can be used within an application to manage
/// a response flow that includes parameters.
///
/// First, in one of your coordinator, you include a function:
/// ```swift
/// func valueSelection(initial: Bool) async throws -> Bool {
///     defer {
///         childCoordinator(of: ResponseParametersCoordinator.self)?.dismiss()
///     }
///     return try await coordinate(to: ResponseParametersCoordinator(parameters: initial, router: router)).response()
/// }
///```
///
/// Then, you implement the coordinator itself:
/// ```swift
/// @MainActor
/// final class ResponseParametersCoordinator: ResponseParametersCoordinator<Bool, Bool> {
///     override func start(animated: Bool = true) {
///         let viewModel = ResponseParametersViewModel(value: parameters)
///         viewModel.routingDelegate = self
///
///         let viewController = BaseHostingController(rootView: ResponseParametersView(viewModel: viewModel))
///
///         present(viewController, animated: animated)
///     }
/// }
///
/// extension ResponseParametersCoordinator: ResponseParametersViewModelRoutingDelegate { }
/// ```
///
/// In this example:
/// - `valueSelection` initiates a `ResponseParametersCoordinator` with a Boolean parameter.
/// - `ResponseParametersCoordinator` is responsible for presenting a view and delegating response handling
///   using a `ResponseParametersViewModel` that expects its delegate to implement `finish(with:)` method.
///
@available(macOS 10.15, *)
open class ResponseParametersCoordinator<Response, Parameters>: ResponseRouterCoordinator<Response> {
    /// A generic property that stores the parameters used for routing.
    public var parameters: Parameters

    ///     Initializes the coordinator with specified parameters and a router instance.
    ///     - Parameters:
    ///         - parameters: The parameters used for routing.
    ///         - router: A conforming instance of `Router` used to handle navigation.
    @inlinable
    public init(parameters: Parameters, router: some Router) {
        self.parameters = parameters
        super.init(router: router)
    }
}

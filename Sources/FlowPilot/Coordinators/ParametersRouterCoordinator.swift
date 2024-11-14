//
//  ParametersRouterCoordinator.swift
//  CleevioRouters
//
//  Created by Lukáš Valenta on 14.08.2024.
//

/// A router coordinator class designed to manage routing with specified parameters.
///
/// This class facilitates navigation coordination and includes a generic type `Parameters` to handle custom parameters for routing tasks.
/// - Requires: macOS 10.15 or later.
///
/// - Note: This class inherits from `RouterCoordinator`.
///
/// ## Generics
/// - `Parameters`: The type of the parameters associated with the routing coordinator.
/// ## Example Usage
/// This example demonstrates how `ParametersRouterCoordinator` can be used within an application to manage
/// a navigation flow that requires parameters but does not involve a response.
///
/// First, in one of your coordinators, include a function to initiate the parameters-based coordinator:
/// ```swift
/// func showDetails(with itemID: Int) {
///     let detailsCoordinator = ParametersRouterCoordinator(parameters: itemID, router: router)
///     coordinate(to: detailsCoordinator)
/// }
/// ```
///
/// Then, implement the coordinator itself:
/// ```swift
/// @MainActor
/// final class DetailsCoordinator: ParametersRouterCoordinator<Int> {
///     override func start(animated: Bool = true) {
///         let viewModel = DetailsViewModel(itemID: parameters)
///
///         let viewController = BaseHostingController(rootView: DetailsView(viewModel: viewModel))
///
///         present(viewController, animated: animated)
///     }
/// }
/// ```
///
/// In this example:
/// - `showDetails(with:)` initiates a `ParametersRouterCoordinator` with an integer parameter, `itemID`.
/// - `DetailsCoordinator` is responsible for presenting a details view using the provided `itemID` parameter,
///   which is injected into the `DetailsViewModel`.
///
@available(macOS 10.15, *)
open class ParametersRouterCoordinator<Parameters>: RouterCoordinator {
    /// A generic property holding the routing parameters, defined by the `Parameters` type.
    public var parameters: Parameters

    ///     Initializes the coordinator with a specified set of parameters and a router instance.
    ///     - Parameters:
    ///         - parameters: The parameters used for routing.
    ///         - router: A conforming instance of `Router` used to handle navigation.
    @inlinable
    public init(parameters: Parameters, router: some Router) {
        self.parameters = parameters
        super.init(router: router)
    }
}

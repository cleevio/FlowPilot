//
//  WindowLevelRouter.swift
//  
//
//  Created by Lukáš Valenta on 09.04.2023.
//

#if os(iOS)
import UIKit
import CleevioCore

/// A router that creates a new window with a specified window level and displays it on the screen.
@MainActor
open class WindowLevelRouter: WindowRouter {
    
    /// Initializes and returns a new `WindowLevelRouter` object with the specified window scene and level.
    ///
    /// - Parameters:
    ///   - windowScene: The window scene to associate the window with.
    ///   - level: The window level to assign to the window. Default is `.init(2)`.
    public init(windowScene: UIWindowScene, level: UIWindow.Level = .init(2)) {
        let newWindow = UIWindow(windowScene: windowScene)
        newWindow.windowLevel = level
        newWindow.isHidden = false
        
        super.init(window: newWindow)
    }
    
    /// Initializes and returns a new `WindowLevelRouter` object using an existing window and adding the specified level addition.
    ///
    /// - Parameters:
    ///   - window: The existing window to use.
    ///   - levelAddition: The level addition to add to the window's current level. Default is `1`.
    public convenience init?(fromWindow window: UIWindow?, levelAddition: CGFloat = 1) {
        guard let window, let windowScene = window.windowScene else { return nil }
        self.init(windowScene: windowScene, level: window.windowLevel + levelAddition)
    }
}

/// A router that creates a new window with a specified window level and displays a navigation router on it.
open class WindowLevelNavigationRouter: WindowNavigationRouter {
    
    /// Initializes and returns a new `WindowLevelNavigationRouter` object with the specified window scene, level, and navigation router.
    ///
    /// - Parameters:
    ///   - windowScene: The window scene to associate the window with.
    ///   - level: The window level to assign to the window. Default is `.init(2)`.
    ///   - navigationRouter: The navigation router to display on the window.
    public init(
        windowScene: UIWindowScene,
        level: UIWindow.Level = .init(2),
        navigationRouter: NavigationRouter
    ) {
        let newWindow = UIWindow(windowScene: windowScene)
        newWindow.windowLevel = level
        newWindow.isHidden = false
        
        super.init(
            window: newWindow,
            navigationRouter: navigationRouter
        )
    }

    /// Initializes and returns a new `WindowLevelNavigationRouter` object with the specified window scene, level, navigation controller, and navigation animation.
    ///
    /// - Parameters:
    ///   - windowScene: The window scene to associate the window with.
    ///   - level: The window level to assign to the window. Default is `.init(2)`.
    ///   - navigationController: The navigation controller to use for the navigation router. Default is a new `UINavigationController`.
    ///   - navigationAnimation: The navigation animation to use for the navigation router. Default is `.default`.
    public convenience init(
        windowScene: UIWindowScene,
        level: UIWindow.Level = .init(2),
        navigationController: UINavigationController? = nil,
        navigationAnimation: NavigationRouter.NavigationAnimation = .default
    ) {
        let navigationRouter = NavigationRouter(
            navigationController: navigationController ?? .init(),
            animation: navigationAnimation
        )
        
        self.init(windowScene: windowScene, level: level, navigationRouter: navigationRouter)
    }
    
    /// Initializes and returns a new `WindowLevelNavigationRouter` object using an existing window and adding the specified level addition and navigation router.
    ///
    /// - Parameters:
    ///   - window: The existing window to use.
    ///   - levelAddition: The level addition to add to the window's current level. Default is `1`.
    ///   - navigationRouter: The navigation router to display on the window.
    convenience public init?(
        fromWindow window: UIWindow?,
        levelAddition: CGFloat = 1,
        navigationRouter: NavigationRouter
    ) {
        guard let window, let windowScene = window.windowScene else { return nil }
        self.init(
            windowScene: windowScene,
            level: window.windowLevel + levelAddition,
            navigationRouter: navigationRouter
        )
    }

    /// Initializes and returns a new `WindowLevelNavigationRouter` object with the specified window scene, level, navigation controller, and navigation animation.
    ///
    /// - Parameters:
    ///   - window: The existing window to use.
    ///   - levelAddition: The level addition to add to the window's current level. Default is `1`.
    ///   - navigationController: The navigation controller to use for the navigation router. Default is a new `UINavigationController`.
    ///   - navigationAnimation: The navigation animation to use for the navigation router. Default is `.default`.
    convenience public init?(
        fromWindow window: UIWindow?,
        levelAddition: CGFloat = 1,
        navigationController: UINavigationController? = nil,
        navigationAnimation: NavigationRouter.NavigationAnimation = .default
    ) {
       let navigationRouter = NavigationRouter(
            navigationController: navigationController ?? .init(),
            animation: navigationAnimation
        )
        
        self.init(fromWindow: window, levelAddition: levelAddition, navigationRouter: navigationRouter)
    }
}
#endif

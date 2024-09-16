//
//  shouldAnimateTransition.swift
//  CleevioRouters
//
//  Created by Tomáš Šmerda on 11.09.2024.
//

#if canImport(UIKit)
import UIKit
@inlinable
public func shouldAnimateTransition(preference: Bool, respectsUserReduceMotion: Bool) -> Bool {
    preference && (respectsUserReduceMotion ? !UIAccessibility.isReduceMotionEnabled : true)
}
#endif

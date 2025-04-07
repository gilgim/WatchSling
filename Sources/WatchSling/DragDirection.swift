//
//  DragDirection.swift
//  WatchSling
//
//  Created by gaea on 4/7/25.
//

import Foundation
import CoreGraphics

public enum DragDirection {
    case left      // (x: (0...100),   y: (-100...40))
    case right     // (x: (-100...0),  y: (-100...40))
    case down      // (x: (-35...35),  y: (0...100))
    case downLeft  // (x: (35...100),   y: (40...100))
    case downRight // (x: (-100...-35), y: (40...100))
    case none
    
    public var range: (x: ClosedRange<CGFloat>, y: ClosedRange<CGFloat>)? {
        switch self {
        case .left:
            return (x: 20...100, y: -100...20)
        case .right:
            return (x: -100...(-20), y: -100...20)
        case .down:
            return (x: -35...35, y: 20...100)
        case .downLeft:
            return (x: 35...100, y: 20...100)
        case .downRight:
            return (x: -100...(-35), y: 20...100)
        case .none:
            return nil
        }
    }
}
public func positionDirection(x: CGFloat, y: CGFloat) -> DragDirection {
    let tolerance: CGFloat = 20.0
    let directions: [DragDirection] = [.left, .right, .down, .downLeft, .downRight]
    for direction in directions {
        if let range = direction.range {
            let extendedX = (range.x.lowerBound - tolerance)...(range.x.upperBound + tolerance)
            let extendedY = (range.y.lowerBound - tolerance)...(range.y.upperBound + tolerance)
            if extendedX.contains(x) && extendedY.contains(y) {
                return direction
            }
        }
    }
    return .none
}

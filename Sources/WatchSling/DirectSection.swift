//
//  DirectSection.swift
//  WatchSling
//
//  Created by gaea on 4/7/25.
//

import SwiftUI

public struct DirectSection: View {
    @Binding var direction: DragDirection?
    let directions: [DragDirection: String]
    public var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
            if let dir = direction, let _ = dir.range, directions[dir] != nil {
                let points = trianglePoints(for: dir, center: center)
                ZStack {
                    Path { path in
                        path.move(to: points[0])
                        path.addLine(to: points[1])
                        path.addLine(to: points[2])
                        path.closeSubpath()
                    }
                    .foregroundStyle(.white.opacity(0.12))
                }
            }
        }
    }
    private func trianglePoints(for direction: DragDirection, center: CGPoint) -> [CGPoint] {
        guard let range = direction.range else { return [] }
        switch direction {
        case .left:
            let p0 = center
            let p1 = CGPoint(x: center.x + range.x.upperBound, y: center.y + range.y.lowerBound)
            let p2 = CGPoint(x: center.x + range.x.upperBound, y: center.y + range.y.upperBound)
            return [p0, p1, p2]
        case .right:
            let p0 = center
            let p1 = CGPoint(x: center.x + range.x.lowerBound, y: center.y + range.y.lowerBound)
            let p2 = CGPoint(x: center.x + range.x.lowerBound, y: center.y + range.y.upperBound)
            return [p0, p1, p2]
        case .down:
            let scale: CGFloat = 1.5
            let p0 = center
            let p1 = CGPoint(x: center.x + range.x.lowerBound * scale, y: center.y + range.y.upperBound * scale)
            let p2 = CGPoint(x: center.x + range.x.upperBound * scale, y: center.y + range.y.upperBound * scale)
            return [p0, p1, p2]
        case .downLeft:
            let scale: CGFloat = 1.5
            let p0 = center
            let p1 = CGPoint(x: center.x + range.x.lowerBound * scale, y: center.y + range.y.upperBound * scale)
            let p2 = CGPoint(x: center.x + range.x.upperBound * scale, y: center.y + range.y.lowerBound * scale)
            return [p0, p1, p2]
        case .downRight:
            let scale: CGFloat = 1.5
            let p0 = center
            let p1 = CGPoint(x: center.x + range.x.upperBound * scale, y: center.y + range.y.upperBound * scale)
            let p2 = CGPoint(x: center.x + range.x.lowerBound * scale, y: center.y + range.y.lowerBound * scale)
            return [p0, p1, p2]
        default:
            return []
        }
    }
}

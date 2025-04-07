import SwiftUI

public struct DirectSectionIcon: View {
    @Binding var direction: DragDirection?
    let directions: [DragDirection: String]
    
    public var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2,
                                 y: geometry.size.height / 2)
            ForEach(Array(directions.keys), id: \.self) { dir in
                if let _ = dir.range {
                    let points = trianglePoints(for: dir, center: center)
                    let centroid = CGPoint(
                        x: (points[0].x + points[1].x + points[2].x) / 3,
                        y: (points[0].y + points[1].y + points[2].y) / 3
                    )
                    IconView(icon: directions[dir] ?? "", active: direction == dir)
                        .position(centroid)
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
            let p0 = center
            let p1 = CGPoint(x: center.x + range.x.lowerBound, y: center.y + range.y.upperBound)
            let p2 = CGPoint(x: center.x + range.x.upperBound, y: center.y + range.y.upperBound)
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

struct IconView: View {
    let icon: String
    let active: Bool
    @State private var isAnimating = false
    @State private var animate = false
    
    /// icon 문자열이 SF Symbol로 사용 가능한지 판단하는 계산 프로퍼티
    private var isSFSymbol: Bool {
        // UIImage(systemName:)가 nil이 아니면 SF Symbol로 판단합니다.
        return UIImage(systemName: icon) != nil
    }
    
    var body: some View {
        Group {
            if isSFSymbol {
                // SF Symbol인 경우 resizable 이미지로 표시
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
            } else {
                // 그렇지 않으면 텍스트로 표시
                Text(icon)
                    .frame(width: 40)
                    .lineLimit(3)
            }
        }
        .font(.caption)
        .foregroundColor(.white)
        .scaleEffect(animate ? 1.2 : 1.0)
        .opacity(active ? 0.5 : 1.0)
    }
}

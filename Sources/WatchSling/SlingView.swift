//
//  SlingView.swift
//  WatchSling
//
//  Created by gaea on 4/7/25.
//

import SwiftUI
import WatchKit

public struct SlingView: View {
    @State private var offset: CGSize = .zero
    @State private var dragDirection: DragDirection? = nil

    // 각 방향에 대해 표시할 문자열을 빈 딕셔너리로 시작
    private var directions: [DragDirection: String] = [:]
    // 각 방향에 대해 실행할 동작을 저장하는 딕셔너리
    private var actions: [DragDirection: () -> Void] = [:]
    
    // 추가로 설정 가능한 옵션들
    private var hapticsEnabled: Bool = true
    private var customFont: Font? = nil
    private var ballSize: CGSize = .init(width: 40, height: 40)
    
    public init() {}
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = value.translation
                let newDir = positionDirection(x: offset.width, y: offset.height)
                if newDir != self.dragDirection {
                    self.dragDirection = newDir
                    if hapticsEnabled {
                        self.triggerHaptic(for: newDir)
                    }
                }
            }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    if let dir = dragDirection {
                        actions[dir]?()
                    }
                    dragDirection = nil
                }
            }
    }
    
    public var body: some View {
        ZStack {
            // 드래그 중인 경우, 활성 방향에 따라 아이콘(또는 텍스트) 표시
            if let direction = dragDirection {
                VStack {
                    if let iconName = directions[direction], UIImage(systemName: iconName) != nil {
                        Image(systemName: iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                    } else {
                        Text(directions[direction] ?? "")
                            .font(customFont ?? .system(size: 24, weight: .semibold))
                    }
                    Spacer()
                }
            }
            // 기존의 DirectSection 및 DirectSectionIcon (별도 구현된 뷰)
            DirectSection(direction: $dragDirection, directions: directions)
            DirectSectionIcon(direction: $dragDirection, directions: directions)
            // 드래그 가능한 원형 픽볼
            Circle()
                .frame(width: ballSize.width, height: ballSize.height)
                .offset(offset)
                .gesture(dragGesture)
        }
    }
    
    /// 특정 방향에 따라 햅틱 피드백을 재생합니다.
    private func triggerHaptic(for direction: DragDirection) {
        let hapticType: WKHapticType?
        switch direction {
        case .left:
            hapticType = .click
        case .right:
            hapticType = .directionUp
        case .down:
            hapticType = .success
        case .downLeft:
            hapticType = .directionDown
        case .downRight:
            hapticType = .notification
        case .none:
            hapticType = nil
        }
        if let type = hapticType {
            WKInterfaceDevice.current().play(type)
        }
    }
    
    // MARK: - 체인형 API 함수들
    /// 지정한 방향에 대해 제목과 동작을 추가한 새로운 SlingView를 반환합니다.
    public func addAction(direction: DragDirection, title: String, action: (() -> Void)? = nil) -> SlingView {
        var copy = self
        copy.directions[direction] = title
        if let action = action {
            copy.actions[direction] = action
        }
        return copy
    }
    
    /// 햅틱 피드백 사용 여부를 설정합니다.
    public func isHaptic(_ value: Bool) -> SlingView {
        var copy = self
        copy.hapticsEnabled = value
        return copy
    }
    
    /// 커스텀 폰트를 설정합니다.
    public func font(_ font: Font) -> SlingView {
        var copy = self
        copy.customFont = font
        return copy
    }
    
    /// 드래그 가능한 원형 픽볼의 크기를 설정합니다.
    public func ballSize(_ size: CGSize) -> SlingView {
        var copy = self
        copy.ballSize = size
        return copy
    }
}

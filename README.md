# WatchSling

WatchSling is a customizable Apple Watch UI library that provides a drag-based interface with directional focus, custom actions, and haptic feedback. It’s built using SwiftUI and WatchKit, and it supports watchOS 10 and above.

<img width="200" alt="default" src="https://github.com/user-attachments/assets/830247f9-ac44-4bf9-9a7d-d801b55b2d22" />
<img width="200" alt="active" src="https://github.com/user-attachments/assets/b255890f-d110-4f19-8fa5-49f36891e4cc" />

## Features

- **Directional Drag Interface:** Recognize left, right, down, down-left, and down-right drag gestures.
- **Custom Actions:** Use a chainable API to register custom actions for each direction.
- **Haptic Feedback:** Receive immediate haptic feedback tailored to the detected drag direction.
- **SwiftUI-Based:** Leverages SwiftUI and WatchKit for modern, declarative UI development.
- **Easy Integration:** Distributed as a Swift Package (and compatible with CocoaPods).

## Installation

### Swift Package Manager

1. In Xcode, select **File > Swift Packages > Add Package Dependency…**
2. Enter the repository URL:  
   `https://github.com/username/WatchSling.git`
3. Choose the desired version range (e.g., from 1.0.0)
4. Complete the wizard to add WatchSling to your project.

```swift
import SwiftUI
import WatchSling

struct ContentView: View {
    @State private var navigateToDetail = false

    var body: some View {
       SlingView()
                .addAction(direction: .left, title: "😎") {
                    print("Left action triggered!")
                }
                .addAction(direction: .right, title: "Easy") {
                    print("Right action triggered!")
                }
                .addAction(direction: .down, title: "❤️") {
                    print("Down action triggered!")
                }
                .addAction(direction: .downLeft, title: "UX") {
                    print("DownLeft action triggered!")
                }
                .addAction(direction: .downRight, title: "star") {
                    print("DownRight action triggered!")
                }
                .isHaptic(true)
                .font(.headline)
                .ballSize(.init(width: 50, height: 50))
    }
}
```
API

SlingView
	
	•	addAction(direction:title:action:)
Registers a custom action and title for a specific drag direction.

public func addAction(direction: DragDirection, title: String, action: (() -> Void)? = nil) -> SlingView


	•	isHaptic(_:)
Enables or disables haptic feedback.

public func isHaptic(_ value: Bool) -> SlingView


	•	font(_:)
Sets a custom font for the directional text.

public func font(_ font: Font) -> SlingView


	•	ballSize(_:)
Sets the size of the draggable ball.

public func ballSize(_ size: CGSize) -> SlingView



DragDirection

Defines the possible drag directions:
	•	.left
	•	.right
	•	.down
	•	.downLeft
	•	.downRight
	•	.none

Each direction is associated with a range that determines its activation.

Haptic Feedback

WatchSling provides haptic feedback for each direction:
	•	left: .click
	•	right: .directionUp
	•	down: .success
	•	downLeft: .directionDown
	•	downRight: .notification

License

This project is licensed under the MIT License. See the LICENSE file for details.

Feel free to adjust the content, image URLs, and repository URL as needed. This README is ready to be copied and used for your WatchSling library.

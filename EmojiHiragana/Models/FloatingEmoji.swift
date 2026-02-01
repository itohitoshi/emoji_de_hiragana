import SwiftUI

class FloatingEmoji: Identifiable, ObservableObject {
    let id = UUID()
    let item: EmojiItem

    @Published var position: CGPoint
    var velocity: CGVector
    let size: CGFloat

    init(item: EmojiItem, position: CGPoint, velocity: CGVector, size: CGFloat) {
        self.item = item
        self.position = position
        self.velocity = velocity
        self.size = size
    }

    var radius: CGFloat {
        size / 2
    }
}

import SwiftUI
import Combine

class EmojiViewModel: ObservableObject {
    @Published var floatingEmojis: [FloatingEmoji] = []
    @Published var selectedEmoji: EmojiItem?

    private var displayLink: CADisplayLink?
    private var screenSize: CGSize = .zero
    private let emojiCount = 10

    init() {
        setupDisplayLink()
    }

    deinit {
        displayLink?.invalidate()
    }

    func setScreenSize(_ size: CGSize) {
        let needsInitialize = screenSize == .zero
        screenSize = size
        if needsInitialize {
            initializeEmojis()
        }
    }

    private func initializeEmojis() {
        let selectedItems = Array(EmojiData.allEmojis.shuffled().prefix(emojiCount))
        floatingEmojis = selectedItems.map { item in
            createFloatingEmoji(item: item)
        }
    }

    private func createFloatingEmoji(item: EmojiItem) -> FloatingEmoji {
        let size = CGFloat.random(in: 60...90)
        let padding = size / 2 + 20

        let position = CGPoint(
            x: CGFloat.random(in: padding...(screenSize.width - padding)),
            y: CGFloat.random(in: padding...(screenSize.height - padding))
        )

        // ランダムな方向と速度
        let speed = CGFloat.random(in: 30...60)
        let angle = CGFloat.random(in: 0...(2 * .pi))
        let velocity = CGVector(
            dx: cos(angle) * speed,
            dy: sin(angle) * speed
        )

        return FloatingEmoji(item: item, position: position, velocity: velocity, size: size)
    }

    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func update(_ displayLink: CADisplayLink) {
        guard screenSize != .zero else { return }

        let deltaTime = displayLink.targetTimestamp - displayLink.timestamp
        updatePositions(deltaTime: deltaTime)
        checkWallCollisions()
    }

    private func updatePositions(deltaTime: Double) {
        for emoji in floatingEmojis {
            emoji.position.x += emoji.velocity.dx * deltaTime
            emoji.position.y += emoji.velocity.dy * deltaTime
        }
        objectWillChange.send()
    }

    private func checkWallCollisions() {
        for emoji in floatingEmojis {
            let radius = emoji.radius

            // 左右の壁
            if emoji.position.x - radius < 0 {
                emoji.position.x = radius
                emoji.velocity.dx = abs(emoji.velocity.dx)
            } else if emoji.position.x + radius > screenSize.width {
                emoji.position.x = screenSize.width - radius
                emoji.velocity.dx = -abs(emoji.velocity.dx)
            }

            // 上下の壁
            if emoji.position.y - radius < 0 {
                emoji.position.y = radius
                emoji.velocity.dy = abs(emoji.velocity.dy)
            } else if emoji.position.y + radius > screenSize.height {
                emoji.position.y = screenSize.height - radius
                emoji.velocity.dy = -abs(emoji.velocity.dy)
            }
        }
    }

    func selectEmoji(_ emoji: EmojiItem) {
        selectedEmoji = emoji
    }

    func clearSelection() {
        selectedEmoji = nil
    }

    func refreshEmojis() {
        let selectedItems = Array(EmojiData.allEmojis.shuffled().prefix(emojiCount))
        floatingEmojis = selectedItems.map { item in
            createFloatingEmoji(item: item)
        }
    }
}

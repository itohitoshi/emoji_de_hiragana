import SwiftUI

struct FloatingEmojiView: View {
    let emoji: EmojiItem
    let onTap: () -> Void

    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0

    // ランダムな初期値
    private let randomSize: CGFloat
    private let animationDuration: Double
    private let maxOffset: CGFloat = 20

    init(emoji: EmojiItem, onTap: @escaping () -> Void) {
        self.emoji = emoji
        self.onTap = onTap
        self.randomSize = CGFloat.random(in: 50...80)
        self.animationDuration = Double.random(in: 2.0...4.0)
    }

    var body: some View {
        Text(emoji.emoji)
            .font(.system(size: randomSize))
            .offset(x: offsetX, y: offsetY)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .onAppear {
                startFloatingAnimation()
            }
            .onTapGesture {
                onTap()
            }
            // 幼児向けに大きめのタップ領域
            .contentShape(Rectangle().size(width: randomSize + 20, height: randomSize + 20))
    }

    private func startFloatingAnimation() {
        // 初期オフセットをランダムに設定
        offsetX = CGFloat.random(in: -maxOffset...maxOffset)
        offsetY = CGFloat.random(in: -maxOffset...maxOffset)
        rotation = Double.random(in: -5...5)

        // 無限ループアニメーション
        withAnimation(
            Animation
                .easeInOut(duration: animationDuration)
                .repeatForever(autoreverses: true)
        ) {
            offsetX = CGFloat.random(in: -maxOffset...maxOffset)
            offsetY = CGFloat.random(in: -maxOffset...maxOffset)
            rotation = Double.random(in: -10...10)
            scale = CGFloat.random(in: 0.95...1.05)
        }
    }
}

#Preview {
    FloatingEmojiView(
        emoji: EmojiItem(emoji: "🐶", hiragana: "いぬ", category: .animal),
        onTap: {}
    )
}

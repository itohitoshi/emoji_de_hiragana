import SwiftUI

struct EmojiDetailView: View {
    let emoji: EmojiItem
    let onDismiss: () -> Void
    let onSpeak: (String) -> Void

    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // 半透明の背景
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            VStack(spacing: 30) {
                // 閉じるボタン（右上）
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding()
                }

                Spacer()

                // 絵文字表示
                Text(emoji.emoji)
                    .font(.system(size: 150))
                    .shadow(radius: 10)

                // ひらがな表示
                Text(emoji.hiragana)
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 5)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.pink, .orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(radius: 10)
                    )

                // タップで再読み上げのヒント
                Text("タップしてもういちど きく")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 20)

                Spacer()

                // とじるボタン（下部）
                Button(action: {
                    dismiss()
                }) {
                    Text("とじる")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(
                            Capsule()
                                .fill(Color.gray.opacity(0.6))
                                .shadow(radius: 5)
                        )
                }
                .padding(.bottom, 40)
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            // 表示アニメーション
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
            // 自動読み上げ
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onSpeak(emoji.hiragana)
            }
        }
        .onTapGesture {
            // タップで再読み上げ
            onSpeak(emoji.hiragana)
        }
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            scale = 0.5
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            onDismiss()
        }
    }
}

#Preview {
    EmojiDetailView(
        emoji: EmojiItem(emoji: "🐶", hiragana: "いぬ", category: .animal),
        onDismiss: {},
        onSpeak: { _ in }
    )
}

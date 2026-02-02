import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = EmojiViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景グラデーション
                LinearGradient(
                    colors: [
                        Color(red: 0.6, green: 0.9, blue: 1.0),
                        Color(red: 1.0, green: 0.9, blue: 0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // 浮遊する絵文字
                ForEach(viewModel.floatingEmojis) { emoji in
                    Text(emoji.item.emoji)
                        .font(.system(size: emoji.size))
                        .position(emoji.position)
                        .onTapGesture {
                            viewModel.selectEmoji(emoji.item)
                        }
                }

                // 上部：ホームボタン
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(Color.pink.opacity(0.8))
                                        .shadow(radius: 3)
                                )
                        }
                        .padding(.leading, 20)
                        .padding(.top, 10)
                        Spacer()
                    }
                    Spacer()
                }

                // 下部：えをかえるボタン
                VStack {
                    Spacer()
                    Button(action: {
                        viewModel.refreshEmojis()
                    }) {
                        Text("えを かえる")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [.orange, .pink],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(radius: 5)
                            )
                    }
                    .padding(.bottom, 40)
                }

                // 詳細画面（選択時に表示）
                if let selectedEmoji = viewModel.selectedEmoji {
                    EmojiDetailView(
                        emoji: selectedEmoji,
                        onDismiss: {
                            viewModel.clearSelection()
                        }
                    )
                    .transition(.opacity)
                }
            }
            .onAppear {
                viewModel.setScreenSize(geometry.size)
            }
            .onChange(of: geometry.size) { newSize in
                viewModel.setScreenSize(newSize)
            }
        }
    }
}

#Preview {
    ContentView()
}

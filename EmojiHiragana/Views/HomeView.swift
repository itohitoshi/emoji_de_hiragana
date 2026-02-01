import SwiftUI

struct HomeView: View {
    @State private var showGame = false
    @State private var showContact = false
    @State private var randomEmojiItem: EmojiItem = EmojiData.allEmojis[0]

    var body: some View {
        NavigationStack {
            ZStack {
                // 背景グラデーション
                LinearGradient(
                    colors: [
                        Color(red: 1.0, green: 0.85, blue: 0.9),
                        Color(red: 0.85, green: 0.9, blue: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // 広告エリア
                    AdBannerView()
                        .frame(height: 60)
                        .padding(.top, 10)

                    Spacer()

                    // 吹き出し + ランダム絵文字
                    VStack(spacing: 0) {
                        // 吹き出し
                        SpeechBubbleView(text: randomEmojiItem.hiragana)

                        // ランダム絵文字
                        Text(randomEmojiItem.emoji)
                            .font(.system(size: 100))
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 10)

                    // タイトル
                    Text("えもじで\nひらがな")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.pink)
                        .multilineTextAlignment(.center)
                        .shadow(color: .white, radius: 2)
                        .padding(.bottom, 40)

                    // あそぶボタン
                    Button(action: {
                        showGame = true
                    }) {
                        Text("あそぶ")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 220, height: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(
                                        LinearGradient(
                                            colors: [.orange, .pink],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .orange.opacity(0.5), radius: 10, y: 5)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())

                    Spacer()

                    // 下部エリア（問い合わせボタン）
                    HStack {
                        Spacer()
                        Button(action: {
                            showContact = true
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 28))
                                Text("といあわせ")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                            }
                            .foregroundColor(.gray)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationDestination(isPresented: $showGame) {
                ContentView()
                    .navigationBarBackButtonHidden(true)
            }
            .sheet(isPresented: $showContact) {
                ContactView()
            }
            .onAppear {
                randomEmojiItem = EmojiData.allEmojis.randomElement() ?? EmojiData.allEmojis[0]
            }
        }
    }
}

// 吹き出しビュー
struct SpeechBubbleView: View {
    let text: String

    var body: some View {
        VStack(spacing: 0) {
            // 吹き出し本体
            Text(text)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.pink)
                )

            // 吹き出しの三角形（しっぽ）
            Triangle()
                .fill(Color.pink)
                .frame(width: 16, height: 10)
        }
    }
}

// 三角形シェイプ
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// ボタンのスケールアニメーション
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// 広告バナープレースホルダー
struct AdBannerView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
            Text("広告エリア")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
    }
}

// 問い合わせ画面
struct ContactView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.98, green: 0.98, blue: 1.0)
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    Text("おといあわせ")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.pink)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("アプリについてのごいけん・ごようぼうは、したのメールアドレスまでおねがいします。")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.gray)

                        Text("example@example.com")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .gray.opacity(0.2), radius: 10)
                    )
                    .padding(.horizontal, 20)

                    Spacer()
                }
                .padding(.top, 40)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

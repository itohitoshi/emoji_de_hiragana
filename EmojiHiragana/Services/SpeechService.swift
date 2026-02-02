import AVFoundation

class SpeechService: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    private var japaneseVoice: AVSpeechSynthesisVoice?

    init() {
        // 高品質な日本語音声を探す
        let voices = AVSpeechSynthesisVoice.speechVoices()
        let japaneseVoices = voices.filter { $0.language.starts(with: "ja") }

        // 優先順位: Enhanced > Default
        if let enhanced = japaneseVoices.first(where: { $0.identifier.contains("enhanced") || $0.identifier.contains("premium") }) {
            japaneseVoice = enhanced
        } else {
            japaneseVoice = AVSpeechSynthesisVoice(language: "ja-JP")
        }
    }

    func speak(_ text: String) {
        // 既存の読み上げを停止
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)

        // 日本語音声を設定
        utterance.voice = japaneseVoice

        // 自然な速度（0.5がデフォルト、少しゆっくりめ）
        utterance.rate = 0.45

        // 音量とピッチの設定
        utterance.volume = 1.0
        utterance.pitchMultiplier = 1.0  // 自然なピッチ

        // 読み上げ前後の間を少し入れる
        utterance.preUtteranceDelay = 0.1
        utterance.postUtteranceDelay = 0.1

        synthesizer.speak(utterance)
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}

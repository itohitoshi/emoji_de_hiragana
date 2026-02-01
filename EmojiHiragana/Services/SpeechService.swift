import AVFoundation

class SpeechService: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        // 既存の読み上げを停止
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)

        // 日本語音声を設定
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")

        // 幼児向けにゆっくり読み上げ
        utterance.rate = 0.4

        // 音量とピッチの設定
        utterance.volume = 1.0
        utterance.pitchMultiplier = 1.1  // 少し高めの声

        synthesizer.speak(utterance)
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}

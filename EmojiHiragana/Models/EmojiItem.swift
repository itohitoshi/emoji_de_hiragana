import Foundation

enum Category: String, CaseIterable {
    case animal = "どうぶつ"
    case food = "たべもの"
    case vehicle = "のりもの"
    case nature = "しぜん"
    case object = "もの"
}

struct EmojiItem: Identifiable, Equatable {
    let id = UUID()
    let emoji: String
    let hiragana: String
    let category: Category

    static func == (lhs: EmojiItem, rhs: EmojiItem) -> Bool {
        lhs.id == rhs.id
    }
}

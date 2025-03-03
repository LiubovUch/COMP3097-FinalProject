import Foundation

struct WordPuzzle {
    let category: String
    let words: [String]
}

struct WordPuzzleModel {
    static let puzzles: [String: WordPuzzle] = [
        "ANIMALS": WordPuzzle(category: "ANIMALS", words: ["LION", "TIGER", "BEAR", "WOLF"]),
        "SPORTS": WordPuzzle(category: "SPORTS", words: ["SOCCER", "TENNIS", "GOLF", "RUGBY"]),
        "FASHION": WordPuzzle(category: "FASHION", words: ["DRESS", "SHOES", "JEANS", "HAT"]),
        "COUNTRY NAMES": WordPuzzle(category: "COUNTRY NAMES", words: ["FRANCE", "CANADA", "INDIA", "CHINA"])
    ]
}

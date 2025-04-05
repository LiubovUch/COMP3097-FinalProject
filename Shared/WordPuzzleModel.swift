
import Foundation

struct WordPuzzle {
    let category: String
    let words: [String]
    let gridSize: Int 
    
    init(category: String, words: [String], gridSize: Int) {
        self.category = category
        self.words = words
        self.gridSize = gridSize
    }
}

struct WordPuzzleModel {
    static let puzzles: [String: [Int: WordPuzzle]] = [
        "ANIMALS": [
            1: WordPuzzle(category: "ANIMALS", words: ["LION", "TIGER", "BEAR", "WOLF"], gridSize: 8),
            2: WordPuzzle(category: "ANIMALS", words: ["ELEPHANT", "GIRAFFE", "ZEBRA", "KANGAROO", "KOALA"], gridSize: 9),
            3: WordPuzzle(category: "ANIMALS", words: ["CROCODILE", "PENGUIN", "RHINO", "HIPPO", "LEOPARD", "CHEETAH"], gridSize: 10),
            4: WordPuzzle(category: "ANIMALS", words: ["GORILLA", "ORANGUTAN", "CROCODILE", "CHEETAH", "JAGUAR", "PANTHER", "ELEPHANT"], gridSize: 13),
            5: WordPuzzle(category: "ANIMALS", words: ["TURTLE", "CROCODILE", "LION", "RHINO", "GIRAFFE", "KOALA", "ZEBRA", "CHEETAH", "PANTHER", "HIPPO"], gridSize: 18)
        ],
        "SPORTS": [
            1: WordPuzzle(category: "SPORTS", words: ["SOCCER", "TENNIS", "GOLF", "RUGBY"], gridSize: 8),
            2: WordPuzzle(category: "SPORTS", words: ["BASKETBALL", "BASEBALL", "FOOTBALL", "HOCKEY", "CRICKET"], gridSize: 9),
            3: WordPuzzle(category: "SPORTS", words: ["BADMINTON", "TENNIS", "SWIMMING", "RUNNING", "JUDO", "SKATEBOARDING"], gridSize: 10),
            4: WordPuzzle(category: "SPORTS", words: ["SOCCER", "RUGBY", "CURLING", "ICEHOCKEY", "ATHLETICS", "CYCLING", "SNOWBOARDING"], gridSize: 13),
            5: WordPuzzle(category: "SPORTS", words: ["FOOTBALL", "GOLF", "TENNIS", "SKATEBOARDING", "SURFING", "CRICKET", "BADMINTON", "BASKETBALL", "SWIMMING", "RUNNING"], gridSize: 18)
        ],
        "FASHION": [
            1: WordPuzzle(category: "FASHION", words: ["DRESS", "SHOES", "JEANS", "HAT"], gridSize: 8),
            2: WordPuzzle(category: "FASHION", words: ["SHIRT", "PANTS", "SCARF", "JACKET", "SHOES"], gridSize: 9),
            3: WordPuzzle(category: "FASHION", words: ["JUMPSUIT", "SWEATER", "CARDIGAN", "HAT", "TROUSERS", "BOOTS"], gridSize: 10),
            4: WordPuzzle(category: "FASHION", words: ["SNEAKERS", "JACKET", "JEANS", "DRESS", "SKIRT", "BLOUSE", "SANDALS"], gridSize: 13),
            5: WordPuzzle(category: "FASHION", words: ["SHIRT", "TROUSERS", "DRESS", "JACKET", "SKIRT", "BLOUSE", "BOOTS", "SCARF", "PULLOVER", "HAT"], gridSize: 18)
        ],
        "COUNTRY NAMES": [
            1: WordPuzzle(category: "COUNTRY NAMES", words: ["FRANCE", "CANADA", "INDIA", "CHINA"], gridSize: 8),
            2: WordPuzzle(category: "COUNTRY NAMES", words: ["GERMANY", "JAPAN", "BRAZIL", "RUSSIA", "SPAIN"], gridSize: 9),
            3: WordPuzzle(category: "COUNTRY NAMES", words: ["MEXICO", "ITALY", "AUSTRALIA", "ARGENTINA", "ENGLAND", "SOUTHAFRICA"], gridSize: 10),
            4: WordPuzzle(category: "COUNTRY NAMES", words: ["USA", "AUSTRALIA", "CANADA", "FRANCE", "GERMANY", "ITALY", "JAPAN", "BRAZIL"], gridSize: 13),
            5: WordPuzzle(category: "COUNTRY NAMES", words: ["INDIA", "SPAIN", "CHINA", "RUSSIA", "ARGENTINA", "UNITEDKINGDOM", "BRAZIL", "GERMANY", "CANADA"], gridSize: 18)
        ]
    ]
}


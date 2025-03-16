import SwiftUI
import Combine

class GameState: ObservableObject {
    @Published var completedLevelsPerCategory: [String: Set<Int>] = [:]

    init() {
        for category in WordPuzzleModel.puzzles.keys {
            if completedLevelsPerCategory[category] == nil {
                completedLevelsPerCategory[category] = Set([0])
            }
        }

        loadCompletedLevels()
    }

    func isLevelUnlocked(level: Int, category: String) -> Bool {
        let completedLevels = completedLevelsPerCategory[category] ?? []
        return completedLevels.contains(level - 1)
    }

    func unlockNextLevel(currentLevel: Int, category: String) {
        let nextLevel = currentLevel 

        if completedLevelsPerCategory[category] == nil {
            completedLevelsPerCategory[category] = []
        }

        if !completedLevelsPerCategory[category]!.contains(nextLevel) {
            completedLevelsPerCategory[category]!.insert(nextLevel)
            saveCompletedLevels()
        }
    }

    func completeLevel(level: Int, category: String) {
        if completedLevelsPerCategory[category] == nil {
            completedLevelsPerCategory[category] = []
        }

        if level == (completedLevelsPerCategory[category]?.max() ?? 0) + 1 {
            completedLevelsPerCategory[category]?.insert(level)
            saveCompletedLevels()

            unlockNextLevel(currentLevel: level, category: category)
        }
    }



    func saveCompletedLevels() {
        let convertedCompletedLevels = completedLevelsPerCategory.mapValues { Array($0) }
        UserDefaults.standard.set(convertedCompletedLevels, forKey: "completedLevelsPerCategory")
    }

    func loadCompletedLevels() {
        if let savedLevels = UserDefaults.standard.dictionary(forKey: "completedLevelsPerCategory") as? [String: [Int]] {
            completedLevelsPerCategory = savedLevels.reduce(into: [String: Set<Int>]()) { result, entry in
                result[entry.key] = Set(entry.value)
            }
        }
    }


    func resetGame() {
        for category in WordPuzzleModel.puzzles.keys {
            completedLevelsPerCategory[category] = Set([0])
        }

        saveCompletedLevels()
    }
}


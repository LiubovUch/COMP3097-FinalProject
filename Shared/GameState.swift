import SwiftUI
import Combine

// GameState class manages game progress, including completed levels and unlocking new ones.
class GameState: ObservableObject {
    @Published var completedLevelsPerCategory: [String: Set<Int>] = [:] // Tracks completed levels per category

    init() {
        // Initialize completed levels for each category, ensuring at least level 0 is present
        for category in WordPuzzleModel.puzzles.keys {
            if completedLevelsPerCategory[category] == nil {
                completedLevelsPerCategory[category] = Set([0])
            }
        }

        loadCompletedLevels() // Load saved progress from storage
    }

    // Checks if a given level is unlocked based on completed levels
    func isLevelUnlocked(level: Int, category: String) -> Bool {
        let completedLevels = completedLevelsPerCategory[category] ?? []
        return completedLevels.contains(level - 1) // A level is unlocked if the previous one is completed
    }

    // Unlocks the next level when the current level is completed
    func unlockNextLevel(currentLevel: Int, category: String) {
        let nextLevel = currentLevel // Next level is the current level (potential bug: should it be currentLevel + 1?)

        if completedLevelsPerCategory[category] == nil {
            completedLevelsPerCategory[category] = []
        }

        // Add next level to the completed levels if not already present
        if !completedLevelsPerCategory[category]!.contains(nextLevel) {
            completedLevelsPerCategory[category]!.insert(nextLevel)
            saveCompletedLevels() // Save progress
        }
    }

    // Marks a level as completed and unlocks the next one
    func completeLevel(level: Int, category: String) {
        if completedLevelsPerCategory[category] == nil {
            completedLevelsPerCategory[category] = []
        }

        // Ensure levels are completed in order
        if level == (completedLevelsPerCategory[category]?.max() ?? 0) + 1 {
            completedLevelsPerCategory[category]?.insert(level)
            saveCompletedLevels()

            unlockNextLevel(currentLevel: level, category: category) // Unlock the next level
        }
    }

    // Saves completed levels to UserDefaults for persistence
    func saveCompletedLevels() {
        let convertedCompletedLevels = completedLevelsPerCategory.mapValues { Array($0) }
        UserDefaults.standard.set(convertedCompletedLevels, forKey: "completedLevelsPerCategory")
    }

    // Loads previously saved completed levels from UserDefaults
    func loadCompletedLevels() {
        if let savedLevels = UserDefaults.standard.dictionary(forKey: "completedLevelsPerCategory") as? [String: [Int]] {
            completedLevelsPerCategory = savedLevels.reduce(into: [String: Set<Int>]()) { result, entry in
                result[entry.key] = Set(entry.value)
            }
        }
    }

    // Resets all progress, setting completed levels back to level 0 for all categories
    func resetGame() {
        for category in WordPuzzleModel.puzzles.keys {
            completedLevelsPerCategory[category] = Set([0])
        }

        saveCompletedLevels() // Persist reset progress
    }
}

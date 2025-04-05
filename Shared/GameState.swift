import SwiftUI
import Combine

// GameState class manages game progress, including completed levels and unlocking new ones.
class GameState: ObservableObject {
    @Published var username: String = "" {
        didSet {
            loadCompletedLevels()  // Load levels when username is updated
        }
    }
    @Published var completedLevelsPerCategory: [String: Set<Int>] = [:] // Tracks completed levels per category

    init() {
        // Initialize completed levels for each category, ensuring at least level 0 is present
        for category in WordPuzzleModel.puzzles.keys {
            completedLevelsPerCategory[category] = Set([0])
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
        let nextLevel = currentLevel // Potential improvement: currentLevel + 1

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
        guard !username.isEmpty else { return }  // Don't save if no username
        let convertedCompletedLevels = completedLevelsPerCategory.mapValues { Array($0) }
        UserDefaults.standard.set(convertedCompletedLevels, forKey: "completedLevels_\(username)")
    }

    // Loads previously saved completed levels from UserDefaults
    func loadCompletedLevels() {
        guard !username.isEmpty else { return }  // Don't load if no username
        if let savedLevels = UserDefaults.standard.dictionary(forKey: "completedLevels_\(username)") as? [String: [Int]] {
            completedLevelsPerCategory = savedLevels.reduce(into: [String: Set<Int>]()) { result, entry in
                result[entry.key] = Set(entry.value)
            }
        } else {
            // If no saved data, initialize default levels
            for category in WordPuzzleModel.puzzles.keys {
                completedLevelsPerCategory[category] = Set([0])
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

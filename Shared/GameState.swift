// Liubov Uchamprina 101445260
import SwiftUI
import Combine

class GameState: ObservableObject {
    @Published var username: String = "" {
        didSet {
            loadCompletedLevels()  
        }
    }
    @Published var completedLevelsPerCategory: [String: Set<Int>] = [:] 
    init() {
        for category in WordPuzzleModel.puzzles.keys {
            completedLevelsPerCategory[category] = Set([0])
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
        guard !username.isEmpty else { return }  
        let convertedCompletedLevels = completedLevelsPerCategory.mapValues { Array($0) }
        UserDefaults.standard.set(convertedCompletedLevels, forKey: "completedLevels_\(username)")
    }

    
    func loadCompletedLevels() {
        guard !username.isEmpty else { return }  
        if let savedLevels = UserDefaults.standard.dictionary(forKey: "completedLevels_\(username)") as? [String: [Int]] {
            completedLevelsPerCategory = savedLevels.reduce(into: [String: Set<Int>]()) { result, entry in
                result[entry.key] = Set(entry.value)
            }
        } else {
            for category in WordPuzzleModel.puzzles.keys {
                completedLevelsPerCategory[category] = Set([0])
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

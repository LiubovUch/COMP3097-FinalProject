//Daria Ignateva 10143112
import Foundation

struct Utilities {
    // Generates a word search grid with given size and category
    static func generateWordGrid(category: String, gridSize: Int) -> [[Character]] {
        var grid = Array(repeating: Array(repeating: Character("-"), count: gridSize), count: gridSize)
        let words = WordPuzzleModel.puzzles[category]?.words ?? []
        
        // Place each word in the grid
        for word in words {
            placeWordInGrid(&grid, word: word, gridSize: gridSize)
        }
        
        // Fill empty spaces with random letters
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col] == Character("-") {
                    grid[row][col] = randomLetter()
                }
            }
        }

        return grid
    }
   
    // Attempts to place a word in the grid at a random position and direction
    static func placeWordInGrid(_ grid: inout [[Character]], word: String, gridSize: Int) {
        let directions = [(1, 0), (0, 1), (1, 1), (-1, 1)] // Possible word directions: vertical, horizontal, diagonal
        var placed = false

        while !placed {
            let row = Int.random(in: 0..<gridSize)
            let col = Int.random(in: 0..<gridSize)
            let direction = directions.randomElement()!

            var canPlace = true
            for i in 0..<word.count {
                let r = row + i * direction.0
                let c = col + i * direction.1
                if r < 0 || c < 0 || r >= gridSize || c >= gridSize || grid[r][c] != "-" {
                    canPlace = false
                    break
                }
            }

            // If word can be placed, insert it into the grid
            if canPlace {
                for (i, char) in word.enumerated() {
                    let r = row + i * direction.0
                    let c = col + i * direction.1
                    grid[r][c] = char
                }
                placed = true
            }
        }
    }

    // Generates a random uppercase letter (A-Z) to fill empty grid spaces
    static func randomLetter() -> Character {
        return Character(UnicodeScalar(Int.random(in: 65...90))!)
    }
}

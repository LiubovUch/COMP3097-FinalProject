import Foundation

struct Utilities {
    static func generateWordGrid(category: String, gridSize: Int) -> [[Character]] {
        var grid = Array(repeating: Array(repeating: Character("-"), count: gridSize), count: gridSize)
        let words = WordPuzzleModel.puzzles[category]?.words ?? []
        for word in words {
            placeWordInGrid(&grid, word: word, gridSize: gridSize)
        }
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col] == Character("-") {
                    grid[row][col] = randomLetter()
                }
            }
        }

        return grid
    }
   
    
    static func placeWordInGrid(_ grid: inout [[Character]], word: String, gridSize: Int) {
        let directions = [(1, 0), (0, 1), (1, 1), (-1, 1)]
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

    static func randomLetter() -> Character {
        return Character(UnicodeScalar(Int.random(in: 65...90))!)
    }
}

// Liubov Uchamprina 101445260
import SwiftUI
import Combine

struct WordSearchView: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let category: String
    let level: Int

@State private var grid: [[Character]] = []
@State private var selectedPositions: [GridPosition] = []
@State private var foundWords: Set<String> = []
@State private var foundWordPositions: Set<GridPosition> = []
@State private var timeElapsed: Int = 0
@State private var timer: AnyCancellable?
@State private var gameEnded: Bool = false
@State private var navigateToNextLevel: Bool = false
@State private var navigateToCategorySelection: Bool = false
@State private var navigateToWelcomeScreen: Bool = false
@State private var finalScore: Int = 0

    var levelData: WordPuzzle? {
        WordPuzzleModel.puzzles[category]?[level]
    }

    // Get the grid size for the current level, default to 5x5 if data is unavailable
    var gridSize: Int {
        levelData?.gridSize ?? 5
    }

    // Retrieve the list of words to find in the current puzzle
    var wordsToFind: [String] {
        levelData?.words ?? []
    }

    var body: some View {
        VStack {
            headerView() // Header with game title, home button, and timer

            Text("Category: \(category)")
                .font(.headline)
                .foregroundColor(.blue)

            HStack {
                Text("Level \(level)")
                    .font(.headline)
                    .foregroundColor(.purple)

                Spacer()

                Text("Score: \(calculateScore())")
                    .font(.headline)
                    .foregroundColor(.purple)
            }
            .padding(.horizontal)

            // Grid view displaying the word search puzzle
            WordGridView(
                grid: grid,
                selectedPositions: $selectedPositions,
                foundWords: $foundWords,
                foundWordPositions: $foundWordPositions,
                wordsToFind: wordsToFind
            )

            wordListView() // List of words to be found
        }
        .padding()
        .onAppear(perform: loadLevel) 
        .onDisappear { timer?.cancel() } 
        .alert(isPresented: $gameEnded) { gameOverAlert() } 
        .background(navigationLinks()) 
    }

    // Header view containing the home button, game title, and timer
    private func headerView() -> some View {
        HStack {
            Image(systemName: "house.fill")
                .foregroundColor(.black)
                .font(.title)
                .onTapGesture {
                    navigateToCategorySelection = true
                }
            Spacer()
            Text("WORD PUZZLE")
                .font(.title2)
                .foregroundColor(.purple)
                .bold()
            Spacer()
            Text(timeString(from: timeElapsed))
                .font(.headline)
                .padding(8)
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
        }
        .padding()
    }

    // Displays the list of words the player needs to find
    private func wordListView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Find the words:")
                .font(.headline)
                .foregroundColor(.purple)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)]) {
                ForEach(wordsToFind, id: \.self) { word in
                    Text(word)
                        .font(.body)
                        .foregroundColor(foundWords.contains(word) ? .gray : .black)
                        .overlay(
                            foundWords.contains(word) ?
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.gray)
                                .offset(y: 0)
                            : nil
                        )
                }
            }
        }
        .padding(.horizontal)
    }

    // Load level data, generate the word grid, and start the timer
    private func loadLevel() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let puzzle = levelData {
                let generatedGrid = Utilities.generateWordGrid(category: category, level: level)
                DispatchQueue.main.async {
                    grid = generatedGrid
                    gameState.loadCompletedLevels()
                    startTimer()
                }
            }
        }
    }

    // Start the game timer, incrementing every second
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                timeElapsed += 1
                if foundWords.count == wordsToFind.count {
                    endGame()
                }
            }
    }

    // Handle the end of the game, update scores, and unlock next level
    private func endGame() {
        timer?.cancel()
        finalScore = calculateFinalScore()
        
        if !gameState.username.isEmpty { // Ensure username is not empty
            saveScore(for: gameState.username, score: finalScore)
        }

        gameEnded = true
        gameState.completeLevel(level: level, category: category)
        gameState.unlockNextLevel(currentLevel: level, category: category)
    }


    private func calculateScore() -> Int {
        foundWords.count * 10
    }

    // Calculate the final score including extra points based on time taken
    private func calculateFinalScore() -> Int {
        calculateScore() + extraPoints()
    }
    private func saveScore(for username: String, score: Int) {
        var leaderboard = UserDefaults.standard.array(forKey: "leaderboard") as? [[String: Any]] ?? []
        
        if let index = leaderboard.firstIndex(where: { $0["name"] as? String == username }) {
            leaderboard[index]["points"] = (leaderboard[index]["points"] as? Int ?? 0) + score
        } else {
            leaderboard.append(["name": username, "points": score])
        }
        
        UserDefaults.standard.set(leaderboard, forKey: "leaderboard")
    }


    // Award extra points based on completion time
    private func extraPoints() -> Int {
        switch timeElapsed {
        case ..<10: return 50
        case ..<20: return 30
        case ..<30: return 10
        default: return 0
        }
    }

    // Convert time in seconds to MM:SS format
    private func timeString(from time: Int) -> String {
        String(format: "%02d:%02d", time / 60, time % 60)
    }

    private func gameOverAlert() -> Alert {
        Alert(
            title: Text("Game Over"),
            message: Text("Time: \(timeString(from: timeElapsed))\nExtra Points: \(extraPoints())\nTotal Score: \(finalScore)"),
            primaryButton: .default(Text("Next Level")) {
                gameState.unlockNextLevel(currentLevel: level, category: category)
                goBack()
            },
            secondaryButton: .default(Text("Main Menu")) {
                navigateToWelcomeScreen = true // Set this flag to navigate to WelcomeScreen
            }
        )
    }

    // Navigation logic for moving between game screens
    private func navigationLinks() -> some View {
        Group {
            // Navigate to Category Selection View
            NavigationLink(destination: CategorySelectionView(), isActive: $navigateToCategorySelection) { EmptyView() }
            
            // Navigate to Level Selection View for the next level
            NavigationLink(destination: LevelSelectionView(category: category), isActive: $navigateToNextLevel) { EmptyView() }
            
            // Navigate to WelcomeScreen when the "Main Menu" button is clicked
            NavigationLink(destination: WelcomeScreen(), isActive: $navigateToWelcomeScreen) { EmptyView() }
        }
    }

    private func goBack() {
        self.presentationMode.wrappedValue.dismiss()  
    }
}

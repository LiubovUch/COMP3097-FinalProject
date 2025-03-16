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
    @State private var finalScore: Int = 0

    var levelData: WordPuzzle? {
        WordPuzzleModel.puzzles[category]?[level]
    }

    var gridSize: Int {
        levelData?.gridSize ?? 5
    }

    var wordsToFind: [String] {
        levelData?.words ?? []
    }

    var body: some View {
        VStack {
            headerView()

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

            WordGridView(
                grid: grid,
                selectedPositions: $selectedPositions,
                foundWords: $foundWords,
                foundWordPositions: $foundWordPositions,
                wordsToFind: wordsToFind
            )

            wordListView()
        }
        .padding()
        .onAppear(perform: loadLevel)
        .onDisappear { timer?.cancel() }
        .alert(isPresented: $gameEnded) { gameOverAlert() }
        .background(navigationLinks())
    }

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

    private func endGame() {
        timer?.cancel()
        finalScore = calculateFinalScore()
        gameEnded = true
        gameState.completeLevel(level: level, category: category)
        gameState.unlockNextLevel(currentLevel: level, category: category)
    }

    private func calculateScore() -> Int {
        foundWords.count * 10
    }

    private func calculateFinalScore() -> Int {
        calculateScore() + extraPoints()
    }

    private func extraPoints() -> Int {
        switch timeElapsed {
        case ..<10: return 50
        case ..<20: return 30
        case ..<30: return 10
        default: return 0
        }
    }

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
                navigateToCategorySelection = true
            }
        )
    }

    private func navigationLinks() -> some View {
        Group {
            NavigationLink(destination: CategorySelectionView(), isActive: $navigateToCategorySelection) { EmptyView() }
            NavigationLink(destination: LevelSelectionView(category: category), isActive: $navigateToNextLevel) { EmptyView() }
        }
    }

    private func goBack() {
        self.presentationMode.wrappedValue.dismiss()  
    }
}


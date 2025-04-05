//Daria Ignateva 10143112
import SwiftUI

struct LevelSelectionView: View {
    @EnvironmentObject var gameState: GameState
    let category: String
    let totalLevels = 5

    @State private var selectedLevel: Int?
    @State private var navigateToGame = false

    var body: some View {
        VStack {
            Text("Select a Level")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Category: \(category)")
                .font(.title2)
                .foregroundColor(.blue)

            
            ForEach(1...totalLevels, id: \.self) { level in
                Button(action: {
                    if gameState.isLevelUnlocked(level: level, category: category) {
                        selectedLevel = level
                        navigateToGame = true
                    }
                }) {
                    HStack {
                        Text("Level \(level)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(gameState.isLevelUnlocked(level: level, category: category) ? .white : .gray)
                        Spacer()
                        if !gameState.isLevelUnlocked(level: level, category: category) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(gameState.isLevelUnlocked(level: level, category: category) ? Color.blue : Color.gray.opacity(0.5))
                    .cornerRadius(10)
                }
                .disabled(!gameState.isLevelUnlocked(level: level, category: category))
                .padding(.horizontal, 20)
            }

            Spacer()

            
        }
        .padding()
        .background(
            NavigationLink(
                destination: WordSearchView(
                    category: category,
                    level: selectedLevel ?? 1  
                ),
                isActive: $navigateToGame,
                label: { EmptyView() }
            )
        )


    }
}



import SwiftUI

struct WordSearchView: View {
    let category: String
    let grid: [[Character]]
    let wordsToFind: [String]
   
    var body: some View {
        VStack {
            // Header (Back Button, Title, Timer)
            HStack {
                Image(systemName: "house.fill")
                    .foregroundColor(.black)
                    .font(.title)

                Spacer()
                Text("WORD PUZZLE")
                    .font(.title2)
                    .foregroundColor(.purple)
                    .fontWeight(.bold)
                Spacer()
               
                Text("00:15")
                    .font(.headline)
                    .padding(8)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding()
           
            // Category Title
            Text("Category: \(category)")
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.bottom, 5)

            // Word Search Grid
            WordGridView(grid: grid)
                .padding(.bottom, 15)
           
            // Word List
            VStack {
                Text("Find the words:")
                    .font(.headline)
                    .foregroundColor(.black)
               
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 5) {
                    ForEach(wordsToFind, id: \.self) { word in
                        Text(word)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(6)
                            .frame(minWidth: 100, maxWidth: .infinity)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
           

            Text("Score: 45")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .frame(width: 150)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
    }
}

struct WordGridView: View {
    let grid: [[Character]]

    var body: some View {
        VStack(spacing: 3) {
            ForEach(0..<grid.count, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<grid[row].count, id: \.self) { col in
                        Text(String(grid[row][col]))
                            .font(.system(size: 20, weight: .bold)) // Adjust font for readability
                            .frame(width: 30, height: 30) // Adjusted size
                            .background(Color.purple.opacity(0.2))
                            .cornerRadius(5)
                    }
                }
            }
        }
        .padding()
    }
}


struct WordSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchView(category: "Animals", grid: Utilities.generateWordGrid(category: "Animals", gridSize: 10), wordsToFind: WordPuzzleModel.puzzles["Animals"]?.words ?? [])
    }
}

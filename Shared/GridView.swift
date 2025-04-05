//Daria Ignateva 10143112
import SwiftUI

struct GridView: View {
    let grid: [[Character]]

    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<grid.count, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<grid[row].count, id: \.self) { col in
                        Text(String(grid[row][col]))
                            .frame(width: 30, height: 30)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .padding()
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        let grid = Utilities.generateWordGrid(category: "Animals", gridSize: 10)
        GridView(grid: grid)
    }
}



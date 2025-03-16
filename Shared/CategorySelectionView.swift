import SwiftUI

struct CategorySelectionView: View {
    let categories = ["ANIMALS", "FASHION", "COUNTRY NAMES", "SPORTS"]

    var body: some View {
        VStack(spacing: 20) {
            Text("WORD PUZZLE")
                .font(.title)
                .foregroundColor(.purple)
                .fontWeight(.bold)

            Text("CLASSIC")
                .font(.title2)
                .foregroundColor(.black)

            ForEach(categories, id: \.self) { category in
                NavigationLink(
                    destination: LevelSelectionView(category: category)
                ) {
                    Text(category)
                        .padding()
                        .frame(width: 250)
                        .background(Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
struct CategorySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectionView()
    }
}


import SwiftUI

struct WelcomeScreen: View {
    var username: String

    var body: some View {
        VStack(spacing: 20) {
            Text("WORD PUZZLE")
                .font(.title)
                .foregroundColor(.purple)
                .fontWeight(.bold)

            Text("Welcome, \(username)!")
                .font(.title2)
                .foregroundColor(.black)

            NavigationLink(destination: CategorySelectionView()) {
                Text("PLAY!")
                    .padding()
                    .frame(width: 200)
                    .background(Color.purple.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            NavigationLink(destination: LeaderboardView()) {
                Text("LEADERBOARD")
                    .padding()
                    .frame(width: 200)
                    .background(Color.pink.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(username: "Player")
    }
}


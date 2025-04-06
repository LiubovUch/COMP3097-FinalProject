// Liubov Uchamprina 101445260
import SwiftUI

struct LeaderboardView: View {
    let leaderboard = [
        ("Miak", 100),
        ("James", 90),
        ("Olivia", 85),
        ("Liam", 80),
        ("Sophia", 75)
    ]

    var body: some View {
        VStack {
            Text("WORD PUZZLE")
                .font(.title)
                .foregroundColor(.purple)
                .fontWeight(.bold)

            Text("LEADERBOARD")
                .font(.title2)
                .foregroundColor(.black)

            List(leaderboard, id: \.0) { player in
                HStack {
                    Text(player.0)
                    Spacer()
                    Text("\(player.1) pts")
                        .fontWeight(.bold)
                }
                .padding()
            }
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}

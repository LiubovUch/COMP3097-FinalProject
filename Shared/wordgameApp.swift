import SwiftUI

@main
struct wordgameApp: App {
    @StateObject var gameState = GameState()
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .environmentObject(gameState) 
        }
    }
}


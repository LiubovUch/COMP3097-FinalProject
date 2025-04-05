//Daria Ignateva 10143112
import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            Color.pink.opacity(0.2).ignoresSafeArea()

            VStack(spacing: 20) {
                Text("WORD\nPUZZLE")
                    .font(.system(size: 50, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.purple)
                    .padding(20)
                    .background(Color.blue.opacity(0.3))
                    .cornerRadius(40)

                VStack(spacing: 10) {
                    Text("Developed by Group-24")
                        .font(.title2)
                        .foregroundColor(.white)
                   
                    Text("Daria Ignateva\nLiubov Uchamprina")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center) 
                   
                }
                .padding(20)
                .background(Color.purple.opacity(0.3))
                .cornerRadius(20)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            UsernameScreen()
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}

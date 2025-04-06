// Liubov Uchamprina 101445260
import SwiftUI

struct UsernameScreen: View {
    @State private var username: String = ""
   
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("WORD PUZZLE")
                    .font(.title)
                    .foregroundColor(.purple)
                    .bold()
               
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: 300, height: 100)
                   
                    HStack {
                        TextField("Enter your name", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .frame(width: 230)
                       
                        NavigationLink(destination: WelcomeScreen(username: username)) {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.black)
                                .font(.title)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("")
        }
    }
}

struct UsernameScreen_Previews: PreviewProvider {
    static var previews: some View {
        UsernameScreen()
    }
}

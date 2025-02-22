import SwiftUI



// Dummy Profilansicht
struct ProfileView: View {
    @ObservedObject var progressManager = LessonProgressManager() // ✅ Fortschrittsmanager

    var body: some View {
        VStack(spacing: 20) {
            Text("Profil & Einstellungen")
                .font(.largeTitle)
                .padding()

            Button(action: {
                progressManager.resetProgress() // ✅ Fortschritt zurücksetzen
            }) {
                Text("Fortschritt zurücksetzen")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
        .padding()
    }
}


// Vorschau
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            LessonOverviewView()
        }
    }
}

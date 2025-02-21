import SwiftUI


import SwiftUI

// Einzelne Lektion als UI-Element
struct LessonRowView: View {
    let lesson: Lesson
    let isCompleted: Bool // ✅ Neuer Parameter zur Anzeige des Fortschritts

    var body: some View {
        HStack {
            Text(lesson.title)
                .font(.headline)
                .foregroundColor(lesson.isUnlocked ? .black : .gray)
            
    
            Spacer()

            if isCompleted {
                Image(systemName: "checkmark.circle.fill") // ✅ Anzeige für abgeschlossene Lektionen
                    .foregroundColor(.green)
            } else {
                Image(systemName: lesson.isUnlocked ? "lock.open" : "lock")
                    .foregroundColor(lesson.isUnlocked ? .green : .red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

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
        LessonOverviewView()
    }
}

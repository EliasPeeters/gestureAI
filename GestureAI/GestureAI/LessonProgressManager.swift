import Foundation
import Combine

class LessonProgressManager: ObservableObject {
    @Published var completedLessons: Set<String> = [] {
        didSet {
            saveProgress() // ✅ Fortschritt speichern, wenn sich etwas ändert
        }
    }

    private let storageKey = "completedLessons"

    init() {
        loadProgress()
    }

    // ✅ Eine Lektion als abgeschlossen speichern
    func completeLesson(_ lesson: Lesson) {
        completedLessons.insert(lesson.id)
    }

    // ✅ Prüfen, ob eine Lektion abgeschlossen wurde
    func isLessonCompleted(_ lesson: Lesson) -> Bool {
        return completedLessons.contains(lesson.id)
    }

    // ✅ Speichern des Fortschritts in UserDefaults
    private func saveProgress() {
        UserDefaults.standard.set(Array(completedLessons), forKey: storageKey)
        print("✅ Fortschritt gespeichert: \(completedLessons)")
    }

    // ✅ Fortschritt aus UserDefaults laden
    private func loadProgress() {
        if let savedLessonIDs = UserDefaults.standard.array(forKey: storageKey) as? [String] {
            completedLessons = Set(savedLessonIDs)
        }
        print("📂 Geladene abgeschlossene Lektionen: \(completedLessons)")
    }

    // ✅ Fortschritt zurücksetzen
    func resetProgress() {
        completedLessons.removeAll() // Fortschritt leeren
        UserDefaults.standard.removeObject(forKey: storageKey) // Speicherung zurücksetzen
        print("⚠️ Fortschritt zurückgesetzt!")
    }
}

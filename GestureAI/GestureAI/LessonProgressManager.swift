import Foundation
import Combine

class LessonProgressManager: ObservableObject {
    @Published var completedLessons: Set<String> = [] {
        didSet {
            saveProgress() // ✅ Fortschritt speichern
        }
    }

    @Published var totalPoints: Int = 0 { // ✅ Punkte werden gespeichert
        didSet {
            savePoints()
        }
    }

    private let storageKey = "completedLessons"
    private let pointsKey = "totalPoints"

    init() {
        loadProgress()
        loadPoints()
    }

    // ✅ Eine Lektion als abgeschlossen speichern
    func completeLesson(_ lesson: Lesson) {
        completedLessons.insert(lesson.id)
    }

    // ✅ Berechnet die Anzahl abgeschlossener Aufgaben
    func completedTasksCount(in lessons: [Lesson]) -> Int {
        return lessons.reduce(0) { total, lesson in
            total + (isLessonCompleted(lesson) ? lesson.tasks.count : 0)
        }
    }
    
    func getPoints() -> Int {
        return totalPoints
    }
    
    func getCompletedLessonsCount() -> Int {
        return completedLessons.count
    }

    // ✅ Berechnet die Gesamtanzahl an Aufgaben
    func totalTasksCount(in lessons: [Lesson]) -> Int {
        return lessons.reduce(0) { total, lesson in
            total + lesson.tasks.count
        }
    }

    // ✅ Punkte hinzufügen & speichern
    func addPoints(_ points: Int) {
        totalPoints += points
    }

    // ✅ Prüfen, ob eine Lektion abgeschlossen wurde
    func isLessonCompleted(_ lesson: Lesson) -> Bool {
        return completedLessons.contains(lesson.id)
    }

    // ✅ Prüfen, ob eine Lektion freigeschaltet ist
    func isLessonUnlocked(_ lesson: Lesson, in lessons: [Lesson]) -> Bool {
        if lesson.id == lessons.first?.id { return true } // Erste Lektion immer freigeschaltet
        if let previousLesson = getPreviousLesson(for: lesson, in: lessons) {
            return isLessonCompleted(previousLesson) // ✅ Vorherige Lektion muss abgeschlossen sein
        }
        return false
    }

    // ✅ Finde die vorherige Lektion
    private func getPreviousLesson(for lesson: Lesson, in lessons: [Lesson]) -> Lesson? {
        guard let index = lessons.firstIndex(where: { $0.id == lesson.id }), index > 0 else {
            return nil
        }
        return lessons[index - 1]
    }

    // ✅ Fortschritt speichern
    private func saveProgress() {
        UserDefaults.standard.set(Array(completedLessons), forKey: storageKey)
        print("✅ Fortschritt gespeichert: \(completedLessons)")
    }

    // ✅ Fortschritt laden
    private func loadProgress() {
        if let savedLessonIDs = UserDefaults.standard.array(forKey: storageKey) as? [String] {
            completedLessons = Set(savedLessonIDs)
        }
        print("📂 Geladene abgeschlossene Lektionen: \(completedLessons)")
    }

    // ✅ Punkte speichern
    private func savePoints() {
        UserDefaults.standard.set(totalPoints, forKey: pointsKey)
        print("🏆 Punkte gespeichert: \(totalPoints)")
    }

    // ✅ Punkte laden
    private func loadPoints() {
        totalPoints = UserDefaults.standard.integer(forKey: pointsKey)
        print("📂 Geladene Punkte: \(totalPoints)")
    }

    // ✅ Fortschritt zurücksetzen
    func resetProgress() {
        completedLessons.removeAll()
        totalPoints = 0
        UserDefaults.standard.removeObject(forKey: storageKey)
        UserDefaults.standard.removeObject(forKey: pointsKey)
        print("⚠️ Fortschritt und Punkte zurückgesetzt!")
    }
}

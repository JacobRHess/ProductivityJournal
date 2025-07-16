import Foundation
import SwiftUI

class JournalManager: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var overallScore: Double = 0.0
    @Published var categoryBreakdown: [CategoryBreakdown] = []
    
    private let taskCategories = [
        TaskCategory(name: "Deep Work", keywords: ["coding", "writing", "research", "analysis", "planning", "designing", "studying"], score: 10, color: .green),
        TaskCategory(name: "Communication", keywords: ["meeting", "email", "call", "discussion", "review", "feedback"], score: 7, color: .blue),
        TaskCategory(name: "Administrative", keywords: ["organizing", "filing", "scheduling", "paperwork", "admin"], score: 5, color: .orange),
        TaskCategory(name: "Learning", keywords: ["reading", "tutorial", "course", "learning", "training"], score: 8, color: .purple),
        TaskCategory(name: "Break", keywords: ["lunch", "break", "coffee", "walk", "rest", "personal"], score: 3, color: .gray),
        TaskCategory(name: "Low Value", keywords: ["browsing", "social media", "distracted", "procrastinating"], score: 1, color: .red)
    ]
    
    func addEntry(task: String) {
        updatePreviousEntryDuration()
        
        let entry = JournalEntry(
            task: task,
            startTime: Date()
        )
        entries.append(entry)
    }
    
    func analyzeEntries() {
        updatePreviousEntryDuration()
        
        var analyzedEntries: [JournalEntry] = []
        
        for entry in entries {
            let category = categorizeTask(entry.task)
            let analyzedEntry = JournalEntry(
                id: entry.id,
                task: entry.task,
                startTime: entry.startTime,
                duration: entry.duration,
                category: category,
                productivityScore: category.score
            )
            analyzedEntries.append(analyzedEntry)
        }
        
        entries = analyzedEntries
        calculateOverallScore()
        generateCategoryBreakdown()
    }
    
    private func updatePreviousEntryDuration() {
        guard let lastIndex = entries.indices.last,
              entries[lastIndex].duration == nil else { return }
        
        let duration = Int(Date().timeIntervalSince(entries[lastIndex].startTime) / 60)
        entries[lastIndex].duration = max(1, duration)
    }
    
    private func categorizeTask(_ task: String) -> TaskCategory {
        let taskLower = task.lowercased()
        
        for category in taskCategories {
            if category.keywords.contains(where: { taskLower.contains($0) }) {
                return category
            }
        }
        
        return TaskCategory(name: "General", keywords: [], score: 5, color: .gray)
    }
    
    private func calculateOverallScore() {
        let totalWeightedScore = entries.compactMap { entry -> Double? in
            guard let score = entry.productivityScore,
                  let duration = entry.duration else { return nil }
            return Double(score * duration)
        }.reduce(0, +)
        
        let totalDuration = entries.compactMap { $0.duration }.reduce(0, +)
        
        overallScore = totalDuration > 0 ? totalWeightedScore / (Double(totalDuration) * 10.0) : 0.0
    }
    
    private func generateCategoryBreakdown() {
        let totalDuration = entries.compactMap { $0.duration }.reduce(0, +)
        
        let entriesWithCategories = entries.compactMap { entry -> (TaskCategory, Int)? in
            guard let category = entry.category,
                  let duration = entry.duration else { return nil }
            return (category, duration)
        }
        
        let grouped = Dictionary(grouping: entriesWithCategories, by: { $0.0.name })
        
        categoryBreakdown = grouped.compactMap { (categoryName, items) -> CategoryBreakdown? in
            guard let firstItem = items.first else { return nil }
            let category = firstItem.0
            let totalMinutes = items.map { $0.1 }.reduce(0, +)
            let percentage = totalDuration > 0 ? Double(totalMinutes) / Double(totalDuration) * 100 : 0
            
            return CategoryBreakdown(
                category: category,
                totalMinutes: totalMinutes,
                percentage: percentage
            )
        }.sorted { $0.totalMinutes > $1.totalMinutes }
    }
    
    func generateSummary() -> String {
        let totalTime = entries.compactMap { $0.duration }.reduce(0, +)
        let mostProductiveCategory = categoryBreakdown.max(by: { $0.totalMinutes < $1.totalMinutes })
        
        var summary = "You tracked \(totalTime) minutes across \(entries.count) tasks today. "
        
        if let topCategory = mostProductiveCategory {
            summary += "You spent most of your time on \(topCategory.category.name) activities (\(topCategory.totalMinutes) minutes). "
        }
        
        switch overallScore {
        case 0.8...1.0:
            summary += "Excellent productivity today! You focused on high-value activities."
        case 0.6...0.79:
            summary += "Good productivity today with room for improvement."
        case 0.4...0.59:
            summary += "Average productivity. Consider focusing more on deep work tomorrow."
        default:
            summary += "Low productivity today. Try to minimize distractions and focus on important tasks."
        }
        
        return summary
    }
}

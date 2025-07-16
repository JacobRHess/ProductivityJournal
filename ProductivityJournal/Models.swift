import Foundation
import SwiftUI

struct JournalEntry: Identifiable {
    let id = UUID()
    let task: String
    let startTime: Date
    var duration: Int?
    var category: TaskCategory?
    var productivityScore: Int?
    
    init(task: String, startTime: Date) {
        self.task = task
        self.startTime = startTime
    }
    
    init(id: UUID = UUID(), task: String, startTime: Date, duration: Int?, category: TaskCategory?, productivityScore: Int?) {
        self.task = task
        self.startTime = startTime
        self.duration = duration
        self.category = category
        self.productivityScore = productivityScore
    }
}

struct TaskCategory {
    let name: String
    let keywords: [String]
    let score: Int
    let color: Color
}

struct CategoryBreakdown {
    let category: TaskCategory
    let totalMinutes: Int
    let percentage: Double
}

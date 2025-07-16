import SwiftUI

struct EntryRow: View {
    let entry: JournalEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.task)
                    .font(.body)
                    .lineLimit(2)
                
                HStack {
                    Text(entry.startTime.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let duration = entry.duration {
                        Text("• \(duration) min")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let category = entry.category {
                        Spacer()
                        CategoryTag(category: category)
                    }
                }
            }
            
            Spacer()
            
            if let score = entry.productivityScore {
                ScoreCircle(score: score)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct CategoryTag: View {
    let category: TaskCategory
    
    var body: some View {
        Text(category.name)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(category.color.opacity(0.2))
            .foregroundColor(category.color)
            .cornerRadius(8)
    }
}

struct ScoreCircle: View {
    let score: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(scoreColor.opacity(0.2))
                .frame(width: 30, height: 30)
            
            Text("\(score)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(scoreColor)
        }
    }
    
    private var scoreColor: Color {
        switch score {
        case 8...10: return .green
        case 6...7: return .blue
        case 4...5: return .orange
        default: return .red
        }
    }
}

struct AnalysisView: View {
    @ObservedObject var journalManager: JournalManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Daily Productivity Score")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                                .frame(width: 120, height: 120)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(journalManager.overallScore))
                                .stroke(scoreColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut(duration: 1), value: journalManager.overallScore)
                            
                            Text("\(Int(journalManager.overallScore * 100))%")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(scoreColor)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category Breakdown")
                            .font(.headline)
                        
                        ForEach(journalManager.categoryBreakdown, id: \.category.name) { breakdown in
                            CategoryBreakdownRow(breakdown: breakdown)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Summary")
                            .font(.headline)
                        
                        Text(journalManager.generateSummary())
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Day Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var scoreColor: Color {
        switch journalManager.overallScore {
        case 0.8...1.0: return .green
        case 0.6...0.79: return .blue
        case 0.4...0.59: return .orange
        default: return .red
        }
    }
}

struct CategoryBreakdownRow: View {
    let breakdown: CategoryBreakdown
    
    var body: some View {
        HStack {
            CategoryTag(category: breakdown.category)
            
            Spacer()
            
            Text("\(breakdown.totalMinutes) min")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("(\(breakdown.percentage, specifier: "%.0f")%)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

import SwiftUI

struct ContentView: View {
    @StateObject private var journalManager = JournalManager()
    @State private var currentTask = ""
    @State private var showAnalysis = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(Date().formatted(date: .omitted, time: .shortened))
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("What are you doing?")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    HStack {
                        TextField("Enter current task...", text: $currentTask)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onSubmit {
                                addEntry()
                            }
                        
                        Button(action: addEntry) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .disabled(currentTask.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding(.horizontal)
                }
                
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(journalManager.entries) { entry in
                            EntryRow(entry: entry)
                        }
                    }
                    .padding(.horizontal)
                }
                
                if !journalManager.entries.isEmpty {
                    Button("Analyze My Day") {
                        journalManager.analyzeEntries()
                        showAnalysis = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Daily Journal")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAnalysis) {
                AnalysisView(journalManager: journalManager)
            }
        }
    }
    
    private func addEntry() {
        guard !currentTask.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        journalManager.addEntry(task: currentTask)
        currentTask = ""
    }
}

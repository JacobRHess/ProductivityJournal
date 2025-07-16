# Daily Journal Productivity Tracker

An iOS app that tracks what you're doing throughout the day and tells you how productive you actually were.

## What it does

Track your daily activities in real-time and get an AI breakdown of how you spent your time. Just type what you're doing, and the app handles the rest.

### Main features
- Real-time task logging with automatic timestamps
- Duration tracking between tasks
- AI categorization of activities (Deep Work, Communication, Learning, etc.)
- Productivity scoring from 1-10
- End-of-day analysis with visual breakdown

### How scoring works
The app looks for keywords in your tasks and scores them:
- **Deep Work** (10 points) - coding, writing, research, analysis
- **Learning** (8 points) - reading, tutorials, courses
- **Communication** (7 points) - meetings, emails, calls
- **Administrative** (5 points) - organizing, scheduling, paperwork
- **Break/Personal** (3 points) - lunch, coffee, walks
- **Low Value** (1 point) - social media, browsing, distractions

## Tech stack

- SwiftUI for the interface
- iOS 15.0+ 
- MVVM architecture
- ObservableObject for data management

## Running the app

1. Clone this repo
2. Open `ProductivityJournal.xcodeproj` in Xcode
3. Build and run on simulator or device

## How to use

1. Open the app when you start your day
2. Type what you're doing and hit enter or tap the + button
3. Keep adding tasks as you switch between activities
4. Hit "Analyze My Day" to see your productivity breakdown

The more specific you are with task descriptions, the better the categorization works.

## File structure

- `JournalManager.swift` - Main logic for tracking and analyzing tasks
- `ContentView.swift` - Primary interface for entering tasks
- `AnalysisView.swift` - Results screen with charts and breakdown
- `Models.swift` - Data structures for entries and categories
- `Views.swift` - Reusable UI components

## Future ideas

- Save data between app launches
- Weekly and monthly reports
- Custom categories
- Apple Watch integration
- Export to CSV
- Focus mode integration

## Contributing

Feel free to submit issues or pull requests if you want to improve something.

## License

MIT License - do whatever you want with this code. # ProductivityJournal

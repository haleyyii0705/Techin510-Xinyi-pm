TECHIN510 project - Front-End

🧩 **Project Scope**  
EMO is a mobile-friendly emotion tracking application built with SwiftUI. The goal is to provide users with an intuitive way to record, review, and analyze their daily moods. The app is designed for personal wellness tracking and can be used for early-stage user testing or as a demo for further development.

🎯 **Target Users**  
- Individuals interested in tracking their emotional well-being
- Users who want to visualize mood trends and patterns
- Anyone seeking a simple, private, and local mood journal

🚀 **Features**

**Phase 1 – MVP**  
- Record Today's Mood: Users can select and save their mood for the day, which is instantly added to the recent records.
- Add Notes: Users can attach notes to each mood record for more context.
- Auto-updating Recent Records: After saving a mood, the "Recent Records" section on the home page instantly displays the latest data—no manual refresh needed (powered by `@Published`).
- Mood Trends & Distribution: Built-in line and bar charts (using Swift Charts) provide a visual overview of mood changes and distribution.
- Local Data Persistence: All data is stored locally and will not be lost after restarting the app.

**Phase 2 – Future Scope**  
- User Authentication: Secure login for personalized access
- Cloud Sync: Option to back up and sync mood data across devices
- Advanced Analytics: More detailed statistics and insights

🗓️ **Timeline**

| Phase                  | Duration |
|------------------------|----------|
| Low-Fidelity Design    | 1 week   |
| High-Fidelity Design   | 1 week   |
| Frontend Prototype     | 1 week   |
| Backend Development    | 3 weeks  |
| Testing & Evaluation   | 1 week   |

👥 **Contact Information**  
- Client: Linzhengrong Shao – sshaolinzr@gmail.com
- Developer: Xinyi Hu – haleyyii0705@gmail.com

## develop
- Front-End: SwiftUI
- Back-End: (future scope)
- Database: Local (UserDefaults), future: CloudKit or other

## development environment setting
1. Clone repository
```bash
git clone [repository-url]
```
2. Install dependencies
- SwiftUI, Combine, Charts (Swift Charts)

3. Run the Project
- Open in Xcode and run on a simulator or device

---

## Recent Updates
- Recent Records now auto-refreshes after saving a new mood, without manual reload (using `@Published`).
- All views share the same singleton data service (`EmotionDataService.shared`).
- Removed duplicate `Mood` enum definitions; now only one source of truth in the Models folder.
- Statistics and distribution charts are implemented using Swift Charts.
- Centralized definition of the `Mood` enum and `EmotionRecord` struct to avoid type conflicts.

## Project Overview
EMO is an emotion tracking app built with SwiftUI. It allows users to record their daily mood, add notes, view recent records, and analyze mood trends and statistics.

## Key Features
- **Record Today's Mood**: Select your mood and save it, which will be automatically added to the recent records.
- **Add Notes**: Attach a note to each mood record for more context.
- **Auto-updating Recent Records**: After saving your mood, the "Recent Records" section on the home page will instantly display the latest data—no manual refresh needed, thanks to the use of `@Published` in the data service.
- **Mood Trends & Distribution Statistics**: Built-in line and bar charts (using Swift Charts) provide a visual overview of your mood changes and distribution.
- **Local Data Persistence**: All data is stored locally and will not be lost after restarting the app.

## Technical Highlights
- Uses `@StateObject` and `@Published` for data-driven UI auto-refresh. The `records` property in `EmotionDataService` is marked as `@Published`, so any change (such as saving today's mood) will immediately update all views that depend on it.
- Employs a singleton `EmotionDataService` as the global data source, shared across all views. All mood records and statistics are managed through this single instance.
- Centralized definition of the `Mood` enum and `EmotionRecord` struct in the Models folder to avoid type conflicts and ambiguity. Any duplicate definitions have been removed.
- Statistics page utilizes Swift Charts for visualizing mood trends and distribution.

## Project Structure
```
EMO/
├── Sources/
│   ├── Models/
│   │   └── EmotionRecord.swift
│   ├── Services/
│   │   └── EmotionDataService.swift
│   └── Views/
│       ├── HomeView.swift
│       ├── EmotionRecordView.swift
│       └── StatisticsView.swift
├── README.md
└── ...
```

## Getting Started
1. Open the project in Xcode.
2. Run on a simulator or a real device.
3. Select and save your mood on the home page to experience instant updates and statistics.

## Dependencies
- SwiftUI
- Combine
- Charts (Swift Charts)

## Notes
To customize mood types, statistics, or UI style, edit `Models/EmotionRecord.swift` and the relevant view files.

**Recent changes:**
- Recent Records now auto-refreshes after saving a new mood, without manual reload.
- All views share the same singleton data service (`EmotionDataService.shared`).
- Removed duplicate `Mood` enum definitions; now only one source of truth in the Models folder.
- Statistics and distribution charts are implemented using Swift Charts.

## Latest Progress (June 2024)
- The homepage now features a full calendar. You can click any date to add or edit your mood via a popup.
- Each calendar cell displays the mood icon for that day.
- The homepage layout is simplified, focusing on the calendar and recent mood records for a cleaner experience.
- You can add or modify moods for any historical date.
- The project is nearly complete—welcome to try it and give feedback!




# TECHIN510 Project 

## 🧩 Project Scope
Moomo is a mobile app for tracking emotions, writing daily journals, and managing your daily to-do list. No login is required, and all data is stored locally. The app supports monthly, weekly, and daily board views, helping you organize and review your life and emotions in multiple dimensions.

## 🎯 Target Users
- Individuals who care about emotional well-being and enjoy journaling
- Users who need to manage daily tasks and plan their lives
- Anyone who wants a private, local app to record emotions and tasks

## 🚀 Features
- **Record Daily Emotions:** Select and save your mood for each day, supporting multiple emotion types
- **Write Journals:** Add a text journal for each day to capture your thoughts and experiences
- **To-Do List:** Add and manage multiple tasks per day, recording start, end, and completion times
- **Monthly/Weekly/Daily Boards:** Switch between month, week, and day views on the home page to intuitively see your emotions, journals, and tasks
- **Local Data Only:** All data is stored locally on your device, no login or cloud sync, ensuring privacy and security

## 🗓️ Timeline
| Phase                | Duration |
|----------------------|----------|
| Low-Fidelity Design  | 1 week   |
| High-Fidelity Design | 1 week   |
| Frontend Prototype   | 1 week   |
| Backend Development  | 3 weeks  |
| Testing & Evaluation | 1 week   |

> **Testing will begin next week. Welcome to try it and give feedback!**

## 👥 Contact
- Client: Linzhengrong Shao – sshaolinzr@gmail.com
- Developer: Xinyi Hu – haleyyii0705@gmail.com

## Tech Stack
- Frontend: SwiftUI
- Backend: Local Flask (can be extended to cloud in the future)
- Database: Local JSON file

## Development Setup
1. Clone the repository
   ```bash
   git clone [repository-url]
   ```
2. Install dependencies
   - SwiftUI, Combine, Charts (Swift Charts)
   - Backend: Flask, flask-cors, requests
3. Run the project
   - Open and run in Xcode (simulator or device)
   - Backend: `python3 app.py`

## Project Structure
```
Moomo/
├── MoomoApp.swift
├── HomeView.swift
├── ContentView.swift
├── ...
├── app.py
├── days_data.json
└── README.md
```

## Getting Started
- Open the project in Xcode and run on a simulator or device
- On the home page, select and save your mood, write a journal, and add tasks to experience local data sync and multi-view boards

## Dependencies
- SwiftUI
- Combine
- Charts (Swift Charts)
- Flask (local backend)

## Notes
- All data is stored locally, no login required, privacy guaranteed
- Supports switching between month, week, and day boards for multi-dimensional review
- To customize emotion types, tasks, or UI style, edit the relevant SwiftUI view files

## Recent Updates
- The home page now features a full calendar; you can tap any date to add/edit moods, journals, and tasks
- Calendar cells display the mood icon for each day
- Recent records auto-refresh, and all views share a singleton data service
- Statistics and distribution charts are implemented using Swift Charts
- The project is about to enter the testing phase—welcome to try it and give feedback! 
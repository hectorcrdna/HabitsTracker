<img width="1512" height="953" alt="Screenshot 2026-10-11 at 2 54 03 PM" src="https://github.com/user-attachments/assets/4d9e0d70-096b-4e7e-9702-b7b6406c7222" />

# HabitsTracker

Help create and stay on top of new habits with scheduled reminders.

## This project was made for learning purposes.

It has a lot of functionality packed in to one project designed to experiment and learn with real world examples.
It is made using `Xcode 27.0`, minimum deployments are `iOS 17`, `macOS 14 Sonoma`, `visionOS 2` and `watchOS 10`. 

## Included

- CoreData
- iCloud
- CoreSpotlight
- VoiceOver support
- HapticFeedback
- Shortcuts app integration
- SwiftUI
- UIKit (for Home Screen shortcut integration)
- UserNotifications
- StoreKit
- WidgetKit (iOS, macOS)
- Watch app
- Localization (English, Spanish and Hungarian)
- UnitTest

## Challenges with watchOS

A few problems integrating watchOS in this project, had to opt-out of using the search bar in the app since it was causing the view to render the bar behind the toolbar making it unusable, also watchOS does not have Menu support so had to remove the filter menu.



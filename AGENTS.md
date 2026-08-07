# AGENTS.md

Fresh Xcode iOS app scaffold (SwiftUI) named "JustFocus". Not a git repo. There are no tests, package dependencies, CI, README, or `Info.plist`.

## Build / run

- Requires full Xcode. This machine currently has `xcode-select` pointed at CommandLineTools, so `xcodebuild` fails until you switch with `sudo xcode-select -s /Applications/Xcode.app`.
- Build (scheme is auto-generated):
  ```
  xcodebuild -project JustFocus.xcodeproj -scheme JustFocus -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build
  ```
- No test target exists; there is no lint/format setup.

## Architecture

- One Swift file per type (the target uses a `PBXFileSystemSynchronizedRootGroup`, so new files under `JustFocus/` are auto-registered — never hand-edit `project.pbxproj`).
  - `JustFocusApp.swift` — `@main` `App`; launches `ContentView()` and wires SwiftData via `.modelContainer(for: TaskItem.self)`.
  - `TaskItem.swift` — SwiftData `@Model` class (`id`, `title`, `taskDescription`, `dueDate: Date`, `note`, `isCompleted`, `isPinned`). `@Model` requires a `class` with `var` stored properties, and a stored property cannot be named `description` (reserved by the macro), so the field is `taskDescription`.
  - `ContentView.swift` — `TabView` shell with two tabs: `FocusView` (task list) and `CalendarReal` (calendar page).
  - `FocusView.swift` — `NavigationStack` + `List` (`.insetGrouped`, default system background) rendering `TaskCardView` rows, each in a `NavigationLink` to `TaskDetail`, with `swipeActions`: Delete (calls `modelContext.delete`) and Pin (toggles `isPinned`, sorts pinned tasks first). `@Query` loads `allTasks`; the visible list filters out `isCompleted` tasks. When a completed task was the last unfinished one due today, it presents `CongratsScreen` via `fullScreenCover`. The plus toolbar button opens `AddTaskSheet` (`.sheet`).
  - `TaskCardView.swift` — the list row content.
  - `AddTaskSheet.swift` — native `Form` (TextField, DatePicker x3 for start/end/time, TextEditor) with a checkmark save button and a cancel button provided by `DiscardAlertModifier` (shows a "Discard Changes?" confirmation when the form was edited). Save: inserts a new `TaskItem` via `modelContext`, or mutates the passed `editingTask`'s properties directly (reference semantics update the UI automatically). Presented from both `FocusView` (add) and `TaskDetail` (edit).
  - `DiscardAlertModifier.swift` — `ViewModifier` + `.discardAlert(show:isEdited:)` that injects the cancel toolbar button and a discard confirmation alert.
  - `TaskDetail.swift` — detail destination pushed from `FocusView`; takes a `TaskItem` reference and renders description/due date/note. Pencil opens `AddTaskSheet(editingTask:)`; the checkmark toolbar button completes the task (`isCompleted = true`), fires `onCompleted` (which may trigger `CongratsScreen`), and pops back to the list.
  - `CalendarReal.swift` — calendar tab: streak counter (flame) + custom month grid with hardcoded `completedDates` and `currentMonth` state. Not wrapped in a `NavigationStack` and does not read task data.
  - `CongratsScreen.swift` — celebration screen presented as a `fullScreenCover` from `FocusView`; its xmark button dismisses it.
- Use system colors (`Color(.systemGroupedBackground)`, `.primary`/`.secondary`) rather than hardcoding new ones.
- SwiftData: autosave is enabled (no manual `save()` calls). Previews that use `@Query` or `@Environment(\.modelContext)` must add `.modelContainer(for: TaskItem.self)` (see the `ContentView` and `TaskDetail` previews).
- Current state: tasks persist via SwiftData (first launch starts empty). Delete swipe works; Pin swipe toggles `isPinned` and sorts pinned first; TaskDetail's checkmark marks a task completed (hidden from the list) and opens `CongratsScreen` when no unfinished tasks remain for today.

## Project quirks (would be easy to get wrong)

- `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` is set in build settings: new code is MainActor-isolated by default. Account for this when writing async/concurrency code.
- `GENERATE_INFOPLIST_FILE = YES` and no `Info.plist`: add app keys via `INFOPLIST_KEY_*` build settings in `JustFocus.xcodeproj/project.pbxproj`.
- Build settings to keep in mind: `SWIFT_VERSION = 5.0` with `SWIFT_APPROACHABLE_CONCURRENCY` and `SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY`; iOS deployment target `26.5`; bundle id `tunamsam.JustFocus`; `DEVELOPMENT_TEAM = PM55368KTX`.

# Alter Session Context

Use this file to restore the important project context for future Codex sessions.

## Maintenance Rule

- This file should be updated proactively after meaningful repo changes.
- The local skill `alter-ios-swiftui` is expected to keep this file current without the user having to request it each time.

## Project

- Repo: `Alter`
- Platform: iOS, SwiftUI
- Architecture: strict MVVM
- Service layer: protocol-oriented for mockability and unit testing
- State management:
  - `@StateObject` for view models in views
  - `@Published` for UI state in view models
- Theming:
  - shared colors and typography under `Alter/Core/Theme`
  - design should stay easy to rebrand / whitelabel

## Current Navigation

- Root uses a `TabView` with 2 tabs:
  - `Projects`
  - `Account`
- Implemented in [RootView.swift](/Users/zorior/Desktop/Projects/Practice_Code/Alter/Alter/Presentation/Navigation/RootView.swift)
- The `+` action from `Projects` presents a full-screen creation flow.
- Bottom tab bar must be hidden during creation flow.
- The creation flow starts directly on `ImportPhotoView`.
- The old welcome screen is not used in the plus-flow.
- Back from `ImportPhotoView` dismisses the full-screen modal.

## Import Flow Rules

- `ImportPhotoView` is single-selection only.
- No multi-select.
- No `Select All`.
- No preview canvas in import flow.
- No `Next` button.
- No explicit `Import Photo` confirmation button.
- In the `Recent` tab, the first tile is a camera button matching the exported design.
- Tapping the camera tile opens the camera full-screen from `ImportPhotoView`.
- Capturing a photo immediately navigates to the editor using that image.
- Cancelling camera capture returns to `ImportPhotoView`.
- Tapping a photo immediately loads it and navigates to the editor.
- Header uses chevron-only back navigation, not text-based back.
- Import screen should avoid blocking spinners for initial gallery rendering.
- Photo metadata should load first, with thumbnails populated lazily at the cell level so the UI appears fast.

## Photo Source Tabs

- `Recent`
  - shows device photos sorted by newest first
- `Albums`
  - first shows albums list
  - tap an album to drill into that album's assets
- `Favorites`
  - shows only system favorite photos
- The section title below the tab selector is dynamic and should match the current tab / selected album context.

## Photo Library Architecture

- Domain models live in `Alter/Domain/Models/EditorModels.swift`
- Photo access service lives in `Alter/Domain/Services/PhotoLibraryService.swift`
- `PhotoLibraryService` protocol exists and should remain the abstraction boundary.
- `SystemPhotoLibraryService` is the concrete Photos-framework implementation.
- `ImportPhotoViewModel` owns:
  - authorization state
  - recent assets
  - favorite assets
  - album list
  - selected album
  - selected album assets
  - loading and error state

## Editor Handoff

- The editor now receives a real `UIImage` wrapped in `EditorImage`.
- `EditorViewModel` uses `EditorImage` rather than the old demo `PhotoAsset`.
- `PreviewCanvas` also renders a real `UIImage`.

## Editor Layout Rules

- The main editor should follow the exported HTML layout with a full-bleed image viewport.
- The editor image should handle portrait and landscape assets non-destructively using fit-style scaling instead of cropping.
- The editor canvas background should stay a unified theme color behind any unused image space.
- The compare pill and tool belt stay pinned at the bottom as a static bottom sheet.
- The bottom tool belt should not scroll vertically with the image content.
- The bottom tool belt is implemented as a reusable liquid-glass component with material blur, rounded corners, and subtle spring feedback on tool changes.

## AI Service Contract

Keep these protocol entry points available for integration and mocking:

- `removeObject(from image: UIImage, mask: Path)`
- `changeBackground(image: UIImage, prompt: String)`
- `swapOutfit(image: UIImage, category: OutfitCategory)`

## Reusable Components Already Introduced

- `PrimaryButton`
- `IconButton`
- `FeatureCard`
- `GlassCard`
- `PreviewCanvas`
- `LibraryPhotoTile`
- `AlbumTile`
- `EmptyStateView`

Prefer composing from reusable atomic components instead of building large one-off screens.

## UX Decisions To Preserve

- Keep layouts adaptive across iPhone sizes.
- Prefer `VStack`, `HStack`, `LazyVStack`, and `LazyVGrid` to mirror exported HTML/CSS layout behavior.
- The import photo asset grid uses fixed square tiles sized to match the exported recent-photos layout.
- Empty and permission-denied states should use reusable UI, not raw text.
- Use `NavigationStack` for structured navigation.

## Known Notes

- Build command used successfully:

```bash
xcodebuild -project Alter.xcodeproj -scheme Alter -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/AlterDerived CODE_SIGNING_ALLOWED=NO build
```

- There may still be room to refine the Photos service actor-isolation warning if it reappears, but the app builds successfully.

## Recommended Prompt To Restore Context

Start a future session with something close to:

```text
Read docs/codex-session-context.md first and use it as the working context for this repo. Follow the local skill alter-ios-swiftui for SwiftUI changes in this project. Then work on: <your task>.
```

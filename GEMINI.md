# DesignGrid.AI - Premium Design Studio

DesignGrid.AI is a fluid, multi-platform application designed for a premium design studio experience. It features a striking ultra-deep charcoal and amber aesthetic, focusing on responsive layouts and seamless AI integration.

## Core Features
- **The Hub:** 3D stacked deck carousel with automated project showcases.
- **Creator Studio:** A hybrid canvas layout supporting both manual editing and AI-powered co-pilot modes (via Gemini).
- **Project Terminal:** Local design persistence using a structured project grid.
- **Identity Terminal:** OS-style account settings with dynamic theme switching and secure credential management.

## Technical Architecture
- **Framework:** Flutter
- **State Management:** BLoC (Business Logic Component)
- **Navigation:** GoRouter with `StatefulShellRoute` for perfect state preservation.
- **Security:** `flutter_secure_storage` for local encryption of API keys.
- **Styling:** Custom dark/amber theme with 12px-16px corner radii and Google Fonts (Inter).

## Implementation Phases

### Phase 1: Project Scaffolding & Core Architecture ✅
- Initialize Flutter project.
- Core dependencies (BLoC, GoRouter, Secure Storage).
- Global Theme configuration (Dark/Light mode).

### Phase 2: Navigation & Shell Setup ✅
- GoRouter with StatefulShellRoute.
- Styled floating Bottom Navigation Dock.
- Page scaffolding.

### Phase 3: BLoC Implementation 🔄
- **CanvasBloc:** Layer management and editor modes.
- **ProjectsBloc:** Local persistence logic.
- **Auth/SettingsBloc:** Secure storage and user preferences.

### Phase 4: UI Development - Screen by Screen
- Home Page (Carousel & Quick Hub).
- Creator Studio (Preset Gallery & Mode Toggle).
- My Projects (Project Grid).
- Me Page (OS-style settings).

### Phase 5: Verification & Testing
- Final color and layout audit.
- State preservation verification.
- Security audit for API key handling.

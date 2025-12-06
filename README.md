# Blockerino Flutter

A Block Blast-style puzzle game rebuilt in Flutter from the original React Native/Expo version.

## Game Features

- **Two Game Modes**:
  - **Classic Mode**: 8x8 grid with 3 pieces
  - **Chaos Mode**: 10x10 grid with 5 pieces
- Drag and drop piece placement
- Line clearing mechanics (horizontal and vertical)
- Combo system with multipliers
- Score tracking
- Haptic feedback
- Smooth animations
- Game over detection

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   ├── piece.dart                 # Piece data structure and library
│   ├── board.dart                 # Board logic and block management
│   └── game_mode.dart             # Game mode configurations
├── providers/
│   ├── game_state_provider.dart   # Game state management
│   └── settings_provider.dart     # App settings (sound, haptics)
├── screens/
│   ├── main_menu_screen.dart      # Main menu with mode selection
│   └── game_screen.dart           # Game play screen
└── widgets/
    ├── board_grid_widget.dart     # Game board display
    ├── hand_pieces_widget.dart    # Player's piece inventory
    ├── game_hud_widget.dart       # Score and combo display
    └── draggable_piece_widget.dart # Draggable piece implementation
```

## Installation

### Prerequisites

- Flutter SDK (>=3.2.0)
- Dart SDK
- iOS Simulator / Android Emulator / Physical Device

### Setup

1. **Navigate to the Flutter project**:
```bash
cd flutter_blockerino
```

2. **Install dependencies**:
```bash
flutter pub get
```

3. **Run the app**:
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d chrome
```

## Key Components

### Models

- **Piece**: Defines block shapes, colors, and properties
- **Board**: Manages the game grid, piece placement, and line clearing
- **GameMode**: Configuration for different game modes

### State Management

- **Provider pattern** for reactive state management
- **GameStateProvider**: Manages game logic, score, combo, and piece placement
- **SettingsProvider**: Handles user preferences (sound, haptics, animations)

### Game Logic

- **Piece Placement**: Validates and places pieces on the board
- **Line Breaking**: Detects and clears complete rows/columns
- **Scoring System**:
  - Base points for placing blocks
  - Bonus points for clearing lines (10 pts per line)
  - Combo multiplier for consecutive line clears
- **Game Over**: Detects when no valid moves remain

### UI/UX

- **Drag and Drop**: Native Flutter draggable/drag target widgets
- **Haptic Feedback**: Vibration on piece placement and game events
- **Animations**: Smooth transitions and visual effects
- **Responsive Design**: Adapts to different screen sizes

## Differences from React Native Version

### Architecture
- **State Management**: Provider instead of Jotai
- **Navigation**: MaterialPageRoute instead of expo-router
- **Animations**: Flutter's built-in animation system instead of Reanimated

### UI Implementation
- **Layout**: Flutter's widget tree vs React Native's component tree
- **Styling**: Flutter's declarative styling vs StyleSheet
- **Drag & Drop**: Flutter's Draggable/DragTarget vs react-native-dnd

### Platform Features
- **Haptics**: vibration package vs expo-haptics
- **Storage**: shared_preferences vs AsyncStorage
- **Fonts**: google_fonts package vs expo-font

## Next Steps

To complete the implementation:

1. **Run `flutter pub get`** to install dependencies
2. **High Scores**: Implement persistence with SharedPreferences
3. **Sound Effects**: Add audio feedback using audioplayers package
4. **Animations**: Enhance with flutter_animate for line clears
5. **Particles**: Add particle effects for visual feedback
6. **Testing**: Write unit tests for game logic
7. **Polish**: Fine-tune drag-and-drop grid mapping precision

## Dependencies

- `flutter` - UI framework
- `provider` - State management
- `shared_preferences` - Local storage
- `vibration` - Haptic feedback
- `flutter_animate` - Animation effects
- `google_fonts` - Press Start 2P font

## License

Same as original project (see LICENSE file in root)

# Gowagr Event App

A Flutter app for the Gowagr Mobile Engineer assessment, displaying public events with pagination, search, category filtering, and offline support.

## 📱 Download APK

**Release APK**: [Download from Google Drive](https://drive.google.com/file/d/1qPdeOcY-jFohw_PT2lSTX4_tGBUoMTDh/view?usp=sharing)

*File size: 22.5 MB | Build type: Release | Optimized for production*

## Setup Instructions
1. Clone the repository: `git clone <https://github.com/eyitayojason/Gowagr-Mobile-Engineer-Task>`
2. Install dependencies: `flutter pub get`
3. Run the app: `flutter run`

## Architecture & Folder Structure

The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── config/                 # Application configuration
│   └── app_config.dart    # Centralized config values
├── constants/             # App-wide constants
│   ├── app_theme.dart     # Theme configuration
│   ├── categories.dart    # Category definitions
│   └── colors.dart        # Color palette
├── data/                  # Data Layer
│   ├── models/           # Data models
│   │   └── event.dart    # Event entity
│   ├── repositories/     # Data access abstraction
│   │   └── event_repository.dart
│   └── services/         # External data sources
│       ├── api_service.dart      # REST API client
│       └── database_service.dart # Local SQLite cache
├── domain/               # Business Logic Layer
│   ├── enums/           # Domain enums
│   ├── event.dart       # Domain entity
│   └── services/        # Business logic services
│       └── event_classification_service.dart
├── presentation/         # Presentation Layer
│   ├── controllers/     # UI controllers
│   ├── providers/       # State management
│   ├── screens/         # Full-screen UI
│   └── widgets/         # Reusable UI components
└── utils/               # Utility classes
    ├── debounce.dart    # Search debouncing
    ├── logger.dart      # Logging utility
    └── snack_bar_utils.dart
```

### Architecture Principles

- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Single Responsibility**: Each class has one reason to change
- **Testability**: Business logic is isolated from UI and data layers

## State Management

The app uses **Provider pattern** with `ChangeNotifier` for state management:


### State Management Features

- **Reactive Updates**: UI automatically updates when state changes via `notifyListeners()`
- **Loading States**: Manages loading, error, empty, and success states
- **Debounced Search**: Prevents excessive API calls with 500ms debounce
- **Pagination State**: Tracks current page and whether more data is available
- **Filter State**: Manages search, category, and trending filters


## Caching Implementation

The app implements a **offline-first caching strategy** using SQLite:


### Caching Strategy

1. **Offline-First Approach**: 
   - App loads cached data immediately on startup
   - Fresh data fetched in background when online
   - Users see content instantly, even offline

2. **Intelligent Caching**:
   - Events cached with `REPLACE` conflict resolution
   - Automatic cache invalidation on schema updates
   - Configurable cache size limits (1000 events max)

3. **Connectivity Awareness**:
   - Uses `connectivity_plus` to detect network status
   - Graceful fallback to cached data when offline
   - Silent caching errors don't break the app

### Cache Implementation Details


## Design Decisions & Trade-offs

### 1. State Management Choice: Provider vs BLoC

**Decision**: Chose Provider over BLoC
- **Pros**: Simpler learning curve, less boilerplate, faster development
- **Cons**: Less structured for complex state, potential for large providers
- **Rationale**: Project scope was manageable with Provider, and team familiarity

### 2. Manual Pagination Implementation

**Decision**: Implemented pagination without external libraries
- **Pros**: Full control over pagination logic, meets specific requirements
- **Cons**: More code to maintain, potential for edge cases
- **Rationale**: Requirements specified manual pagination with `page` and `size` parameters

### 3. Offline-First Architecture

**Decision**: Prioritized offline experience over real-time updates
- **Pros**: Better user experience, works without internet
- **Cons**: Data might be stale, more complex state management
- **Rationale**: Mobile apps should work offline, and events data doesn't change frequently

### 4. SQLite for Caching

**Decision**: Used SQLite over simpler storage solutions
- **Pros**: Structured data, query capabilities, ACID compliance
- **Cons**: More complex setup, larger app size
- **Rationale**: Events have complex structure, need relational storage for future features

### 5. Error Handling Strategy

**Decision**: Graceful degradation with cached data
- **Pros**: App continues working even with API failures
- **Cons**: Users might not know they're seeing cached data
- **Rationale**: Better user experience than showing error screens

### 6. Search Debouncing

**Decision**: 500ms debounce for search
- **Pros**: Reduces API calls, better performance
- **Cons**: Slight delay in search results
- **Rationale**: Balance between responsiveness and server load

### 7. UI/UX Trade-offs

**Decision**: Prioritized functionality over animations
- **Pros**: Met all functional requirements, stable performance
- **Cons**: Less polished feel, no micro-interactions
- **Rationale**: Time constraints, focus on core functionality

## Performance Optimizations

1. **ListView.builder**: Efficient scrolling for large lists
2. **Debounced Search**: Prevents excessive API calls
3. **Cached Network Images**: Reduces bandwidth usage
4. **Batch Database Operations**: Efficient caching
5. **Lazy Loading**: Load more data only when needed

## Future Enhancements

1. **Real-time Updates**: WebSocket integration for live data
2. **Advanced Caching**: Cache invalidation strategies
3. **Animations**: Smooth transitions and micro-interactions
4. **Authentication**: User accounts and personalized content
5. **Push Notifications**: Event updates and reminders

## Features

- ✅ Fetches events from `https://api.gowagr.app/pm/events/public-events`
- ✅ Manual pagination with `page` and `size` parameters
- ✅ Search functionality with `keyword` parameter
- ✅ Category filtering and trending toggle
- ✅ Offline support with cached data
- ✅ Loading states and error handling
- ✅ Responsive UI matching Figma design
- ✅ Debounced search to reduce API calls
- ✅ Connectivity-aware data fetching
- ✅ Graceful error handling with fallbacks

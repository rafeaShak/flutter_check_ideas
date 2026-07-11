# Async Interview Lab

> **Flutter Async Interview Lab** is a hands-on Flutter project for mastering asynchronous programming, Clean Architecture, MVVM, and interview-ready patterns. The project intentionally simulates a backend using fake data sources so every async concept can be learned in isolation before integrating with a real API.

---

# Overview

Async Interview Lab demonstrates modern Flutter asynchronous programming through practical, self-contained examples.

The project uses:

- Flutter
- Dart
- MVVM
- Clean Architecture
- Repository Pattern
- Manual Dependency Injection
- Use Cases
- Futures
- Streams
- FutureBuilder
- StreamBuilder

The goal is to become a personal reference project covering nearly every asynchronous concept commonly asked during Flutter interviews.

---

# Current Features

- Loading tasks asynchronously
- Loading user profile information
- Future.wait examples
- FutureBuilder examples
- StreamBuilder examples
- Task progress stream
- Notification stream widget
- Shared loading/error/empty/success widgets
- Task CRUD simulation
- Stream subscription management
- Manual dependency injection
- MVVM with Clean Architecture

---

# Folder Structure

```text
lib/
├── app/
├── core/
│   └── presentation/
│       └── widgets/
│           ├── async_loading_content.dart
│           ├── async_error_content.dart
│           ├── async_empty_content.dart
│           └── async_success_content.dart
├── features/
│   ├── async_tasks/
│   └── widgets/
│       ├── profile_future_card.dart
│       ├── tasks_future_builder_card.dart
│       ├── dashboard_loader_card.dart
│       ├── task_progress_stream_card.dart
│       └── notifications_stream_card.dart
```

# Reusable Async Widgets

- ProfileFutureCard
- TasksFutureBuilderCard
- DashboardLoaderCard
- TaskProgressStreamCard
- NotificationsStreamCard

# Shared Async UI

Reusable widgets:

- AsyncLoadingContent
- AsyncErrorContent
- AsyncEmptyContent
- AsyncSuccessContent

Located in:

`lib/core/presentation/widgets`

Feature-specific UI remains inside its feature.

# Async Concepts Implemented

- Future
- async / await
- Future.delayed
- Future.wait
- FutureBuilder
- Stream
- StreamBuilder
- StreamSubscription
- async*
- yield
- ChangeNotifier
- Loading/Error/Empty states
- Repository Pattern
- Use Cases
- MVVM
- Clean Architecture

# Remaining Work

- DTOs
- Mappers
- Notification source
- Future.timeout
- Future.any
- StreamController
- Broadcast Streams
- await for
- yield*
- Stream transformers
- Widget tests
- Repository tests
- ViewModel tests

# Learning Progress

Completed:

- Domain layer
- Data layer
- Presentation layer
- Use Cases
- FutureBuilder widgets
- StreamBuilder widgets
- Shared async presentation widgets
- Future.wait
- Stream subscriptions

Next focus:

1. Widget tests
2. ViewModel tests
3. Repository tests
4. Advanced async examples

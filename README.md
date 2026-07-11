# Async Interview Lab

## Overview

Async Interview Lab is a Flutter learning project created to practise asynchronous programming concepts commonly discussed in Flutter and Dart interviews.

The application simulates asynchronous backend operations without requiring a real server. It currently supports loading tasks, displaying user information, adding tasks, completing tasks, handling errors, and observing task updates through a stream.

The project uses:

* Flutter
* Dart
* MVVM
* Clean Architecture principles
* Repository Pattern
* Manual Dependency Injection
* Futures
* Streams

---

## Project Goals

The goal is to create a practical reference project in which every important asynchronous concept has a clear, working example.

The complete project will demonstrate:

* `Future`
* `async` and `await`
* `Future.delayed`
* `Future.wait`
* `Future.any`
* `Future.timeout`
* Error handling
* Custom exceptions
* `Stream`
* `StreamController`
* Single-subscription streams
* Broadcast streams
* `StreamSubscription`
* `async*`
* `yield`
* `yield*`
* `await for`
* `FutureBuilder`
* `StreamBuilder`
* Stream cancellation
* Retry patterns
* Repository Pattern
* Dependency Injection
* MVVM
* Clean Architecture
* Separation of concerns

---

## Current Features

The application currently supports:

* Loading tasks asynchronously
* Loading user profile information
* Running independent Futures concurrently with `Future.wait`
* Displaying loading indicators
* Displaying error messages
* Adding new tasks
* Marking tasks as completed
* Updating the completed-task count
* Watching task changes through a Stream
* Cancelling a `StreamSubscription`
* Simulating network delays
* Handling missing-task errors
* Injecting dependencies manually
* Updating the UI through `ChangeNotifier`

---

## Architecture

The project follows MVVM and Clean Architecture principles.

```text
Presentation
     ↓
Domain
     ↑
Data
```

The dependency direction is important:

* The Presentation layer depends on Domain abstractions.
* The Data layer implements contracts defined by the Domain layer.
* The Domain layer does not depend on Flutter widgets, APIs, or databases.

The UI does not access the data source directly.

```text
AsyncTasksScreen
        ↓
AsyncTasksViewModel
        ↓
TaskRepository
        ↑
TaskRepositoryImpl
        ↓
FakeTaskRemoteDataSource
```

---

## Folder Structure

```text
lib/
├── app/
│   └── async_interview_app.dart
│
├── features/
│   ├── data/
│   │   ├── datasources/
│   │   │   └── fake_task_remote_data_source.dart
│   │   │
│   │   └── repositories/
│   │       └── task_repository_impl.dart
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── async_task.dart
│   │   │   └── user_profile.dart
│   │   │
│   │   └── repositories/
│   │       └── task_repository.dart
│   │
│   └── presentation/
│       ├── screens/
│       │   └── async_tasks_screen.dart
│       │
│       └── viewmodels/
│           └── async_tasks_view_model.dart
│
└── main.dart
```

Additional folders will be introduced as the project grows:

```text
lib/
├── core/
│   ├── errors/
│   ├── result/
│   └── utils/
│
└── features/
    ├── data/
    │   ├── models/
    │   ├── mappers/
    │   └── datasources/
    │
    ├── domain/
    │   └── usecases/
    │
    └── presentation/
        └── widgets/
```

---

# Implemented Files

## `lib/main.dart`

The application entry point.

Responsibilities:

* Start the Flutter application
* Create the root application widget

```dart
void main() {
  runApp(const AsyncInterviewApp());
}
```

---

## `lib/app/async_interview_app.dart`

The root application widget.

Responsibilities:

* Create `MaterialApp`
* Configure the application theme
* Create dependencies
* Inject the data source into the repository
* Inject the repository into the ViewModel
* Inject the ViewModel into the screen

The current dependency graph is:

```text
FakeTaskRemoteDataSource
        ↓
TaskRepositoryImpl
        ↓
AsyncTasksViewModel
        ↓
AsyncTasksScreen
```

This is manual dependency injection. A dependency-injection package is intentionally not required at this stage.

---

# Domain Layer

The Domain layer contains the application's business models and contracts.

It must not know about:

* Flutter widgets
* HTTP
* Firebase
* SQLite
* JSON responses
* UI state
* Data-source implementation details

## `async_task.dart`

Represents a task inside the business domain.

Properties:

* `id`
* `title`
* `completed`

It also provides `copyWith`, which allows an immutable task to be copied with selected properties changed.

Example:

```dart
final completedTask = task.copyWith(
  completed: true,
);
```

---

## `user_profile.dart`

Represents the user inside the business domain.

Properties:

* `id`
* `name`
* `completedTasks`

The entity does not know how user information is fetched or stored.

---

## `task_repository.dart`

Defines the operations required by the application.

```dart
abstract class TaskRepository {
  Future<List<AsyncTask>> fetchTasks();

  Future<UserProfile> fetchUser();

  Future<void> addTask(String title);

  Future<void> completeTask(String id);

  Stream<List<AsyncTask>> watchTasks();
}
```

The repository interface describes what the application needs without specifying how the operations are implemented.

### Future methods

A `Future` produces one result or one error.

Examples:

```dart
Future<List<AsyncTask>> fetchTasks();
Future<UserProfile> fetchUser();
Future<void> addTask(String title);
```

### Stream method

A `Stream` can produce multiple values over time.

```dart
Stream<List<AsyncTask>> watchTasks();
```

---

# Data Layer

The Data layer is responsible for retrieving and modifying data.

## `fake_task_remote_data_source.dart`

Simulates a remote backend using an in-memory list.

Responsibilities:

* Store fake tasks
* Simulate network delays
* Return tasks asynchronously
* Return user information asynchronously
* Add tasks
* Complete tasks
* Throw an exception when a task cannot be found

Example simulated delay:

```dart
await Future.delayed(
  const Duration(seconds: 1),
);
```

This makes the data source behave similarly to an API without requiring a real backend.

The data source currently demonstrates:

* `Future`
* `async`
* `await`
* `Future.delayed`
* Exceptions
* Immutable returned collections

---

## `task_repository_impl.dart`

Implements the Domain repository contract.

Responsibilities:

* Call the fake remote data source
* Return Domain entities
* Expose task updates as a Stream

The task stream is implemented as an asynchronous generator:

```dart
Stream<List<AsyncTask>> watchTasks() async* {
  while (true) {
    final tasks = await remoteDataSource.fetchTasks();

    yield tasks;

    await Future.delayed(
      const Duration(seconds: 3),
    );
  }
}
```

Important concepts:

### `async*`

A function marked with `async*` returns a Stream.

### `yield`

`yield` sends a value through the Stream without closing it.

### Stream cancellation

The asynchronous generator stops being observed when its subscription is cancelled.

---

# Presentation Layer

The Presentation layer contains Flutter UI and UI state management.

## `async_tasks_view_model.dart`

Acts as the bridge between the screen and the Domain layer.

The ViewModel extends `ChangeNotifier` and owns the screen state.

State managed by the ViewModel:

* Tasks
* User profile
* Loading status
* Error message
* Task stream subscription

### Concurrent operations

The initial tasks and user profile are loaded concurrently:

```dart
final results = await Future.wait([
  repository.fetchTasks(),
  repository.fetchUser(),
]);
```

`Future.wait` is appropriate because the two operations are independent.

### Error handling

Asynchronous operations use:

```dart
try {
  // Async operation
} catch (error) {
  // Store error
} finally {
  // Stop loading
}
```

The `finally` block runs whether the operation succeeds or fails.

### Stream subscription

The ViewModel listens to live task updates using:

```dart
repository.watchTasks().listen(...)
```

The returned `StreamSubscription` is stored so it can be cancelled later.

```dart
StreamSubscription<List<AsyncTask>>? _tasksSubscription;
```

### Resource cleanup

The subscription is cancelled when the ViewModel is disposed:

```dart
@override
void dispose() {
  _tasksSubscription?.cancel();
  super.dispose();
}
```

This helps prevent unnecessary work and memory leaks.

---

## `async_tasks_screen.dart`

The main application screen.

Responsibilities:

* Display the user profile
* Display the list of tasks
* Accept a new task title
* Trigger task creation
* Trigger task completion
* Display loading indicators
* Display errors
* Listen to ViewModel changes
* Clean up listeners and controllers

The screen starts loading data in `initState`:

```dart
@override
void initState() {
  super.initState();

  viewModel.addListener(_onViewModelChanged);
  viewModel.loadInitialData();
  viewModel.startWatchingTasks();
}
```

The screen checks `mounted` before calling `setState`:

```dart
void _onViewModelChanged() {
  if (mounted) {
    setState(() {});
  }
}
```

The screen removes listeners and disposes resources in `dispose`.

For callbacks that call asynchronous functions, the callback can be wrapped in a synchronous closure:

```dart
onPressed: viewModel.isLoading
    ? null
    : () {
        _addTask();
      },
```

This satisfies Flutter's `VoidCallback` requirement while starting the asynchronous operation.

---

# Async Concepts Implemented

## Future

Used for operations that complete once.

Examples:

* Fetching tasks
* Fetching a user
* Adding a task
* Completing a task

## `async` and `await`

Used to write asynchronous code in a readable sequential style.

## `Future.delayed`

Used to simulate network latency.

## `Future.wait`

Used to run independent operations concurrently.

## Error handling

Implemented with:

* `try`
* `catch`
* `finally`
* `throw Exception`

## Stream

Used to emit updated task lists over time.

## `async*` and `yield`

Used to create an asynchronous task generator.

## StreamSubscription

Used to listen to and cancel Stream events.

## `ChangeNotifier`

Used to notify the Flutter screen when UI state changes.

---

# Remaining Concepts

The following concepts are planned but have not yet been implemented:

* DTO models
* Entity mappers
* Use cases
* Custom application exceptions
* Typed async result states
* `Future.timeout`
* `Future.any`
* Retry logic
* `FutureBuilder`
* `StreamBuilder`
* `StreamController`
* `Timer.periodic`
* Broadcast streams
* `addError`
* `await for`
* `yield*`
* Stream transformers
* Cancellation patterns for Futures
* Isolates and `compute`
* Unit tests
* Widget tests

---

# Development Roadmap

## Phase 1 — Project setup

* [x] Create the Flutter project
* [x] Create the GitHub repository
* [x] Create the initial folder structure
* [x] Configure the application entry point
* [x] Configure the root application widget

## Phase 2 — Domain layer

* [x] Create `AsyncTask`
* [x] Create `UserProfile`
* [x] Create `TaskRepository`
* [ ] Create `TaskNotification`
* [ ] Create use cases

## Phase 3 — Data layer

* [x] Create the fake task remote data source
* [x] Implement asynchronous delays
* [x] Implement task creation
* [x] Implement task completion
* [x] Add missing-task error handling
* [x] Implement the repository
* [x] Create an asynchronous task Stream
* [ ] Add DTO models
* [ ] Add entity mappers
* [ ] Add a notification Stream source

## Phase 4 — Presentation layer

* [x] Create `AsyncTasksViewModel`
* [x] Manage loading state
* [x] Manage error state
* [x] Load tasks and profile concurrently
* [x] Listen to task updates
* [x] Cancel the Stream subscription
* [x] Create `AsyncTasksScreen`
* [x] Display tasks and user information
* [x] Add task interaction
* [x] Complete task interaction
* [ ] Extract reusable widgets

## Phase 5 — Future examples

* [ ] Add a `FutureBuilder` example
* [ ] Add a timeout example
* [ ] Add a retry example
* [ ] Add a `Future.any` example
* [ ] Add typed Future results

## Phase 6 — Stream examples

* [ ] Add a `StreamBuilder` example
* [ ] Add `StreamController`
* [ ] Add notification events
* [ ] Add a broadcast Stream
* [ ] Add Stream error events
* [ ] Add `await for`
* [ ] Add `yield*`
* [ ] Add a Stream transformer

## Phase 7 — Advanced asynchronous programming

* [ ] Explain the Dart event loop
* [ ] Demonstrate the event queue
* [ ] Demonstrate the microtask queue
* [ ] Add Future cancellation patterns
* [ ] Add an isolate example
* [ ] Add a `compute` example

## Phase 8 — Testing

* [ ] Add entity tests
* [ ] Add data-source tests
* [ ] Add repository tests
* [ ] Add ViewModel tests
* [ ] Add widget tests

---

# Interview Topics Covered So Far

The current implementation can be used to explain:

* What a Future is
* What `async` means
* What `await` does
* How asynchronous errors propagate
* Why `finally` is useful
* How `Future.wait` works
* The difference between a Future and a Stream
* What `async*` means
* What `yield` does
* What a `StreamSubscription` is
* Why subscriptions should be cancelled
* Why `mounted` should be checked
* How `ChangeNotifier` updates the UI
* Why the repository interface belongs in the Domain layer
* How the Data layer implements a Domain contract
* How manual dependency injection works
* How MVVM separates UI from state management

---

# Running the Project

Make sure Flutter is installed and configured.

Check the environment:

```bash
flutter doctor
```

Install dependencies:

```bash
flutter pub get
```

Run static analysis:

```bash
flutter analyze
```

Run the application:

```bash
flutter run
```

Run tests:

```bash
flutter test
```

---

# Development Rules

1. Build one focused file at a time.
2. Give every file a single responsibility.
3. Keep the code simple enough to explain in an interview.
4. Add a practical example for every async concept.
5. Run `flutter analyze` after meaningful changes.
6. Test the application before committing.
7. Use clear Git commit messages.
8. Update this README as the implementation progresses.

---

# Current Status

The basic vertical feature is working:

```text
UI
 ↓
ViewModel
 ↓
Repository contract
 ↑
Repository implementation
 ↓
Fake data source
```

Completed:

* [x] Domain entities
* [x] Repository contract
* [x] Fake remote data source
* [x] Repository implementation
* [x] ViewModel
* [x] Main screen
* [x] Loading state
* [x] Error handling
* [x] Task creation
* [x] Task completion
* [x] User profile loading
* [x] Concurrent Future loading
* [x] Task Stream
* [x] Stream subscription cancellation
* [x] Manual dependency injection

Still in progress:

* [ ] Use cases
* [ ] DTOs and mappers
* [ ] Dedicated Future examples
* [ ] Dedicated Stream examples
* [ ] Advanced async examples
* [ ] Automated tests

---

# Next Step

The next development step is to improve the Domain layer by adding use cases between the ViewModel and repository.

Suggested first file:

```text
lib/features/domain/usecases/get_tasks_use_case.dart
```

After adding the use cases, the dependency flow will become:

```text
AsyncTasksScreen
        ↓
AsyncTasksViewModel
        ↓
Use Cases
        ↓
TaskRepository
        ↑
TaskRepositoryImpl
        ↓
FakeTaskRemoteDataSource
```

# Async Interview Lab

## Overview

**Async Interview Lab** is a Flutter project created specifically to master asynchronous programming concepts that are commonly asked in Flutter interviews.

The goal of this project is **not** to build a production application, but to build a complete reference project demonstrating every important async feature in Dart and Flutter while following a clean architecture.

By the end of the project, every asynchronous concept should have a real implementation that can be explained during an interview.

---

# Main Goals

This project should demonstrate:

* Futures
* async / await
* Future.delayed
* Future.wait
* Future.timeout
* Error handling
* Custom Exceptions
* Streams
* StreamController
* Broadcast Streams
* async*
* yield
* await for
* StreamSubscription
* FutureBuilder
* StreamBuilder
* Repository Pattern
* Dependency Injection
* MVVM
* Clean Architecture

The application should simulate network requests without requiring a real backend.

---

# Architecture

The project follows **Clean Architecture** together with **MVVM**.

```
Presentation
      ↓
Domain
      ↓
Data
```

The Presentation layer must never know where the data comes from.

The Domain layer contains business logic only.

The Data layer is responsible for fetching, mapping and providing data.

---

# Folder Structure

```
lib/

app/
core/

features/
    async_tasks/
        data/
        domain/
        presentation/
```

Each layer has a single responsibility.

---

# File Responsibilities

## app/

### async_interview_app.dart

Responsible for:

* MaterialApp
* Theme
* Routes
* Dependency injection initialization

---

## core/

### errors/app_exception.dart

Contains custom exceptions.

Examples:

* NetworkException
* TimeoutException
* UnknownException

Purpose:

Learn custom exception handling.

---

### result/async_result.dart

Represents loading states.

Possible states:

* Loading
* Success
* Error

Purpose:

Avoid returning nullable values everywhere.

---

### utils/delay_helper.dart

Contains helper methods for fake delays.

Example:

```
Future<void> waitTwoSeconds()
```

Purpose:

Avoid repeating Future.delayed everywhere.

---

# Feature

```
features/
    async_tasks/
```

Everything related to the interview project lives here.

---

# DATA Layer

## datasources/

### fake_task_remote_data_source.dart

This class simulates a REST API.

It should demonstrate:

* Future.delayed
* async
* await
* throw Exception
* timeout
* random success/failure

Functions to implement:

```
fetchUser()

fetchTasks()

fetchTaskDetails()

fetchDashboard()
```

Nothing here should know about Flutter widgets.

---

### fake_notification_stream_source.dart

This class simulates live updates.

It should use:

* StreamController
* Timer.periodic
* add()
* addError()
* close()

Purpose:

Teach how live events are produced.

---

## models/

### task_dto.dart

Represents the raw API model.

Example:

```
id
title
completed
```

---

### user_dto.dart

Represents the raw user response.

---

## mappers/

### async_task_mapper.dart

Responsible for converting

DTO

↓

Domain Entity

No business logic belongs here.

---

## repositories/

### async_task_repository_impl.dart

Implements the repository interface.

Responsibilities:

* Call data sources
* Convert DTOs into Entities
* Handle exceptions
* Return clean domain objects

Presentation must never access a data source directly.

---

# DOMAIN Layer

Contains only business logic.

No Flutter imports.

No HTTP.

No Firebase.

No Widgets.

---

## entities/

### async_task.dart

Pure business model.

---

### user_profile.dart

Pure user entity.

---

### task_notification.dart

Represents a notification event.

---

## repositories/

### async_task_repository.dart

Repository contract.

Example:

```
Future<UserProfile> getUser();

Future<List<AsyncTask>> getTasks();

Stream<int> watchProgress();
```

The Data layer implements this interface.

---

## usecases/

Each use case performs one business action.

Files:

```
get_user_profile_usecase.dart

get_tasks_usecase.dart

get_dashboard_data_usecase.dart

watch_task_progress_usecase.dart

watch_notifications_usecase.dart
```

Purpose:

One use case = one action.

---

# PRESENTATION Layer

Contains Flutter UI.

---

## viewmodels/

### async_tasks_view_model.dart

Acts as the bridge between UI and Domain.

Responsibilities:

* Call UseCases
* Manage loading state
* Store data
* Listen to streams
* Cancel subscriptions
* Notify listeners

Concepts to demonstrate:

* Future
* StreamSubscription
* dispose()
* notifyListeners()

---

## screens/

### async_tasks_screen.dart

Main interview screen.

Should contain several independent sections.

Examples:

Future Example

Stream Example

Timeout Example

Future.wait Example

Error Example

---

## widgets/

Widgets should remain small.

Example widgets:

```
profile_future_card.dart

tasks_future_builder_card.dart

dashboard_loader_card.dart

task_progress_stream_card.dart

notifications_stream_card.dart
```

Each widget demonstrates one async concept.

---

# Development Plan

We will build the project one small step at a time.

## Phase 1

Create project structure.

---

## Phase 2

Create Domain entities.

---

## Phase 3

Create fake API.

---

## Phase 4

Create repository.

---

## Phase 5

Create use cases.

---

## Phase 6

Create ViewModel.

---

## Phase 7

Create UI.

---

## Phase 8

FutureBuilder examples.

---

## Phase 9

StreamBuilder examples.

---

## Phase 10

Advanced async examples.

Including:

* Future.wait
* timeout
* retry
* cancellation pattern
* broadcast streams
* await for
* async generators

---

# Interview Topics Covered

By the end of this project I should be able to confidently explain:

* What is Future?
* What is async?
* What does await do?
* Event Loop
* Microtask Queue
* Future.wait
* Future.any
* Future.timeout
* Error propagation
* try/catch/finally
* Stream
* Single-subscription vs Broadcast Stream
* StreamController
* StreamSubscription
* async*
* yield
* yield*
* await for
* FutureBuilder
* StreamBuilder
* Repository Pattern
* Clean Architecture
* MVVM
* Dependency Injection
* Separation of Concerns

---

# Rules During Development

1. Build one file at a time.
2. Every file must have a single responsibility.
3. Add comments explaining important concepts.
4. After each completed file, create a Git commit.
5. Do not skip steps.
6. Ensure every async concept has a practical example.
7. Keep the code simple enough to explain during an interview.

---

# Current Status

✅ Flutter project created.

✅ GitHub repository created.

⬜ Project folder structure.

⬜ Domain entities.

⬜ Fake remote data source.

⬜ Repository.

⬜ Use cases.

⬜ ViewModel.

⬜ UI.

⬜ Future examples.

⬜ Stream examples.

⬜ Advanced async examples.

---

# Next Step

The next file to implement is:

```
lib/features/async_tasks/domain/entities/async_task.dart
```

After completing each file, update this README by marking the corresponding section as completed and commit the changes to Git with a meaningful commit message.

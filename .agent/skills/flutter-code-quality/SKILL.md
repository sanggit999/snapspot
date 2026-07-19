---
name: flutter-code-quality
description: Audits, refactors, and guides Dart and Flutter code to ensure high quality, adherence to Clean Architecture, optimal widget structures, performance patterns, and proper naming conventions.
version: 1.0.0
author: Antigravity
tags:
  - flutter
  - dart
  - clean-code
  - best-practices
---

# Flutter Code Quality & Best Practices Skill

## Overview
This skill guides the development and auditing of Dart and Flutter codebase. It ensures clean code, solid architecture, and efficient UI rebuilding.

## When to Use
- When writing new Flutter screens, widgets, or business logic.
- When refactoring existing Flutter/Dart code to improve readability and performance.
- When performing a code quality review.

## Coding Conventions & Best Practices

### 1. Naming Conventions
- **Files & Directories**: Always use `snake_case` (e.g., `user_profile_screen.dart`).
- **Classes, Enums, Mixins, Extensions**: Use `UpperCamelCase` (e.g., `UserProfileScreen`).
- **Variables, Functions, Parameters**: Use `lowerCamelCase` (e.g., `getUserProfile`).
- **Private members**: Prefix with an underscore `_` (e.g., `_isLoaded`).

### 2. Widget Construction & Performance
- **Split Large Widgets**: Do not create massive `build` methods. Split widgets into small, dedicated sub-widgets (`StatelessWidget` or `StatefulWidget`).
- **Prefer Sub-widgets over Helper Methods**: 
  - ❌ Avoid: `Widget _buildHeader() { ... }` (Rebuilds everything inside, has no separate element tree context).
  -   Avoid: Use `class HeaderWidget extends StatelessWidget { ... }` (Enables rebuild optimization and const optimization).
- **Use `const` Constructors**: Always use `const` for widgets with static content to allow Flutter to skip rebuilding them.
- **Minimize `setState` Scope**: Avoid calling `setState` at the root of a large widget tree. Use state management or local state in smaller, leaf widgets.

### 3. Clean Architecture & Functional Error Handling (fpdart) Guidelines
- **UI Layer**: Purely presentation. It only displays state and triggers events/calls. No direct DB access, API calls, or business logic.
- **Domain Layer**: Houses pure business logic, entities, and use cases (UseCases). It should be independent of external libraries/frameworks.
  - **UseCase Return Types**: UseCases must return `Future<Either<Failure, T>>` to represent success and failure paths explicitly.
- **Data Layer**: Houses repositories, data sources (local database, remote API), and models (JSON serialization/deserialization).
  - **Repository Return Types**: Repositories must always return `Future<Either<Failure, T>>`. They map concrete data into domain models and translate raw exceptions into domain-level `Failure` objects.
  - **Try/Catch Scope**: Use try/catch blocks **only** at the Data Source or Repository implementation level. Intercept raw exceptions (e.g., `DioException`, `DatabaseException`) and convert them to `Left(Failure)`.
- **Either Rules (fpdart)**:
  - All operations prone to failure (API requests, database operations, file storage, auth logic) must return `Either<Failure, Success>` instead of throwing raw exceptions or returning implicit error values like `null`, `false`, `-1`, or empty objects.


### 5. Dependency Injection (get_it) Rules
- **Use get_it as the Central Service Locator**: Use a global `getIt` instance (usually in a file named `injection_container.dart` or `service_locator.dart`) to register and retrieve dependencies.
- **Choose the Right Registration Lifecycle**:
  - **`registerLazySingleton`**: Use for stateless dependencies that should persist throughout the app's lifecycle (e.g., API clients, repositories, local storage, auth services). They are only instantiated when first accessed.
  - **`registerFactory`**: Use for stateful dependencies that should be recreated every time they are requested (e.g., UI controllers, local BLoCs/Cubits, or transient forms).
  - **`registerSingleton`**: Avoid using this unless immediate initialization at app startup is strictly required (e.g., configuring analytics or critical crash reporting services).
- **Interface Segregation in Registration**: When registering dependencies, always register them against their abstract/interface class, not their concrete implementation. This facilitates mock injection during tests.
  - ❌ Avoid: `getIt.registerLazySingleton<UserRepositoryImpl>(() => UserRepositoryImpl(getIt()));`
  - ✅ Prefer: `getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt()));`
- **Avoid Calling get_it Directly Inside UI Widgets**:
  - Widgets should receive their data/controllers from state management (BLoC/Riverpod/Provider) or via constructor parameter. Do NOT call `getIt<T>()` inside a widget's build method.
  - Only use `getIt` inside the state management configuration layer, repositories, or services to inject constructors.

### 4. Code Formatting
- Always run `dart format .` to maintain a consistent spacing and line-wrap.
- Prefer trailing commas for arguments, parameters, and collections containing more than one item to improve readability and git diff quality.

## Instructions
1. Analyze the requested file or code snippet.
2. Identify code quality issues (naming, structure, N+1 layout passes, mutable state leaks, or hardcoded dependencies).
3. Apply the recommended refactoring according to clean code and dependency injection (get_it) guidelines.
4. Verify compiling and formatting compatibility.

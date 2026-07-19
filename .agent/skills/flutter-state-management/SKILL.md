---
name: flutter-state-management
description: Establishes conventions and architectures for managing state in Flutter, focusing on clean separation of presentation and business logic using popular packages like Riverpod, BLoC, or Provider.
version: 1.0.0
author: Antigravity
tags:
  - flutter
  - state-management
  - riverpod
  - bloc
---

# Flutter State Management Skill

## Overview
This skill defines standard patterns for state management, ensuring a clear separation between the UI presentation layer and the application state/business logic layer.

## When to Use
- When introducing a new feature that requires managing dynamic state.
- When refactoring state management in existing screens.
- When deciding how to structure data flow within the application.

## Key Principles

### 1. Separation of Concerns
- **UI (Widgets)**: Should remain completely declarative and simple. They subscribe to state changes and render UI components accordingly.
- **State Holders (Notifier / BLoC / Controller)**: Contain the business logic, state mutations, and call API repositories. They do NOT import `package:flutter/material.dart` or interact directly with the UI elements.

### 2. State Modeling Best Practices
- Prefer **Immutable States**. Use packages like `freezed` or `equatable` to make states immutable.
- Always model states explicitly using classes. For example, instead of multiple flags (`isLoading`, `isError`), use a union class or a single state object:
  - `CounterInitial`, `CounterLoading`, `CounterSuccess`, `CounterFailure`.

### 3. Package-Specific Best Practices

#### Riverpod
- Use `Notifier` or `AsyncNotifier` for complex state logic.
- Keep providers scoped and autodisposed where appropriate (`.autoDispose`).
- Read providers in widgets using `ref.watch` for rebuilding and `ref.read` inside callbacks (e.g., button onPressed).

#### BLoC / Cubit
- Keep events and states simple.
- Emit new states instead of mutating existing ones.
- Use `BlocBuilder` for rebuilding widgets, `BlocListener` for side effects (e.g. navigation, showing SnackBar), and `BlocConsumer` when both are needed.
- **No Raw Try/Catch in Cubits/BLoCs**: Avoid using try/catch blocks to intercept exceptions from Repositories/UseCases. Because Repositories return an `Either` containing the `Failure`, the Cubit should handle errors cleanly without expecting raw exceptions.
- **Handling Either in State Management**: Always handle the `Either` result using **`fold()`** or **`match()`** to exhaustively map both `Failure` and `Success` branches to appropriate UI states.
  - ❌ Avoid (Catching raw exceptions):
    ```dart
    try {
      final user = await authRepository.login(email, password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
    ```
  - ✅ Prefer (Folding Either):
    ```dart
    final result = await authRepository.login(email, password);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
    ```


### 4. Dependency Injection using get_it
- **Constructor Injection**: Never instantiate repositories, services, or storage dependencies directly inside BLoCs, Cubits, or Notifiers. Pass them through the constructor.
  - ❌ Avoid:
    ```dart
    class AuthCubit extends Cubit<AuthState> {
      final authRepository = AuthRepositoryImpl(); // Tight coupling
    }
    ```
  - ✅ Prefer:
    ```dart
    class AuthCubit extends Cubit<AuthState> {
      final AuthRepository authRepository;

      AuthCubit(this.authRepository) : super(AuthInitial());
    }
    ```
- **Instantiation using get_it**: Use `get_it` to resolve the required parameters when registering or creating the BLoC/Cubit:
  - Inside the routes/navigation setup or widget injection layer:
    ```dart
    BlocProvider(
      create: (context) => AuthCubit(getIt<AuthRepository>()),
      child: const LoginScreen(),
    )
    ```

## Instructions
1. Determine the appropriate state management solution.
2. Structure the states, events/actions, and notifier/bloc classes.
3. Keep the UI layer dumb and decoupled.
4. Ensure states are immutable and easily testable.
5. Apply Dependency Injection via get_it to decouple business logic from data sources.


---
name: flutter-widget-testing
description: Standardizes writing, structuring, and execution of Dart unit tests and Flutter widget tests. Enforces test isolation, mock declarations, and AAA (Arrange-Act-Assert) pattern.
version: 1.0.0
author: Antigravity
tags:
  - flutter
  - testing
  - widget-test
  - mocktail
---

# Flutter Widget & Unit Testing Skill

## Overview
This skill outlines how to write reliable, readable, and maintainable unit and widget tests in a Flutter application.

## When to Use
- When writing tests for new logic, viewmodels, repositories, or services.
- When creating widget/UI component tests.
- When verifying code behavior programmatically.

## Testing Best Practices

### 1. Test File Structure
- Test files must reside in the `test` directory matching the source file path.
- Test files must end with `_test.dart` (e.g., `lib/src/domain/counter.dart` -> `test/src/domain/counter_test.dart`).

### 2. Arrange-Act-Assert (AAA) Pattern
Every test should clearly structure its phases:
- **Arrange**: Set up the environment, instantiate classes, mock dependencies.
- **Act**: Call the method or interact with the widget under test.
- **Assert**: Verify that the outcomes match expectations (using `expect`, `verify`).

### 3. Mocking Dependencies
- Avoid hitting real network APIs or databases in tests.
- Prefer packages like `mocktail` or `mockito` to mock external collaborators.
- Setup mocks inside `setUp` or specific test groups to keep them isolated.

### 4. Widget Testing Specifics
- Use `tester.pumpWidget` to inflate the widget inside a testing harness.
- Wrap widgets with `MaterialApp` or necessary providers (like `ProviderScope`, `BlocProvider`) to satisfy theme or state requirements.
- Use `tester.pump()` or `tester.pumpAndSettle()` to wait for animations, microtasks, or state updates to finish.
- Use `find.byType`, `find.byKey`, or `find.text` to target widgets.
### 5. Mocking get_it Dependencies in Tests
- **Allow Reassignment**: In the `setUp` method of your tests, set `getIt.allowReassignment = true` to replace production implementations with mocks.
- **Isolate Test State**: Always reset `getIt` at the end of every test suite inside `tearDown` or `tearDownAll` to prevent stale states or side-effects from leaking into other tests.
- **Example Pattern**:
  ```dart
  late MockUserRepository mockUserRepository;

  setUp(() {
    getIt.allowReassignment = true;
    mockUserRepository = MockUserRepository();
    getIt.registerLazySingleton<UserRepository>(() => mockUserRepository);
  });

  tearDown(() async {
    await getIt.reset();
  });
  ```

## Instructions
1. Review the component or class that needs to be tested.
2. Structure the test suite with descriptive `group` and `testWidgets` or `test` blocks.
3. Write isolated unit or widget tests using AAA pattern.
4. Ensure all asynchronous calls are correctly awaited and pumped.
5. If testing components that rely on get_it, mock dependencies correctly in setUp and reset getIt in tearDown.


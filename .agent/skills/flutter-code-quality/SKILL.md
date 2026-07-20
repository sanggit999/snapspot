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

### 2. Widget Construction, Performance & Composition Pattern
- **Split Large Widgets**: Do not create massive `build` methods. Split widgets into small, dedicated sub-widgets (`StatelessWidget` or `StatefulWidget`).
- **Prefer Sub-widgets over Helper Methods**: 
  - ❌ Avoid: `Widget _buildHeader() { ... }` (Rebuilds everything inside, has no separate element tree context).
  - ✅ Prefer: Use `class HeaderWidget extends StatelessWidget { ... }` (Enables rebuild optimization and const optimization).
- **Use `const` Constructors**: Always use `const` for widgets with static content to allow Flutter to skip rebuilding them.
- **Minimize `setState` Scope**: Avoid calling `setState` at the root of a large widget tree. Use state management or local state in smaller, leaf widgets.

#### 2.1. Widget Composition Pattern
- **Objective**: Reduce the complexity of a screen's `build()` method by breaking the UI down into multiple small, focused widgets per section. A single Screen file should **NOT** contain hundreds of lines of a nested Widget Tree.
- **Single Responsibility Principle (SRP) for Widgets**: A widget must only have one specific responsibility.
  - ✅ Prefer: `PostHeader`, `PostCommentItem`, `PostCommentInput` (Single responsibility).
  - ❌ Avoid: `PostHeaderAndComment` (Violates SRP, hard to maintain and reuse).
- **Standard Folder Structure**:
  Organize UI code under the presentation layer by separating high-level orchestration screens from low-level section widgets:
  ```text
  presentation/
  ├── screens/
  │     post_detail_screen.dart     # Contains the orchestration layout with small component widgets
  │
  └── widgets/
        post_image_carousel.dart    # Isolated child widgets (Feature-scoped)
        post_header.dart
        post_location_section.dart
        post_caption_section.dart
        post_comment_section.dart
        post_comment_item.dart
        post_comment_input.dart
  ```

#### 2.2. Global Reusable Core Widgets (`lib/core/widgets/`)
- **2 Features Rule**: If a UI component is used in **only 1 feature**, keep it in `lib/features/<feature>/presentation/widgets/`. If it is shared by **2 or more features**, move it to `lib/core/widgets/` (e.g., `lib/core/widgets/buttons/`, `lib/core/widgets/inputs/`).
- **Naming Convention**: All global reusable widgets in `lib/core/widgets/` **must start with the `App` prefix** (`AppButton`, `AppTextField`, `AppCard`, `AppDialog`, `AppLoading`).
- **Zero Hardcoding**: Reusable core widgets must strictly consume design tokens (`AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadius`) and receive data exclusively via constructor parameters.

- **Example Pattern**:
  - ❌ **Bad (Single screen containing the entire massive widget tree)**:
    ```dart
    class PostDetailScreen extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Column(
            children: [
              // Image widget code (50 lines) ...
              // Author header widget code (40 lines) ...
              // Caption widget code (30 lines) ...
              // Comment list widget code (100 lines) ...
              // Input field widget code (50 lines) ...
            ],
          ),
        );
      }
    }
    ```
  - ✅ **Good (Composed Screen using dedicated sub-widgets)**:
    ```dart
    class PostDetailScreen extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PostImageCarousel(),
                      PostHeader(),
                      PostLocationSection(),
                      PostCaptionSection(),
                      PostCommentSection(),
                    ],
                  ),
                ),
              ),
              PostCommentInput(),
            ],
          ),
        );
      }
    }
    ```


### 3. Clean Architecture & Functional Error Handling (fpdart) Guidelines
- **UI Layer**: Purely presentation. It only displays state and triggers events/calls. No direct DB access, API calls, or business logic.
- **Domain Layer**: Houses pure business logic, entities, and use cases (UseCases). It should be independent of external libraries/frameworks.
  - **UseCase Return Types**: UseCases must return `Future<Either<Failure, T>>` to represent success and failure paths explicitly.
- **Data Layer**: Houses repositories, data sources (local database, remote API), and models (JSON serialization/deserialization).
  - **Repository Return Types**: Repositories must always return `Future<Either<Failure, T>>`. They map concrete data into domain models and translate raw exceptions into domain-level `Failure` objects.
  - **Try/Catch Scope**: Use try/catch blocks **only** at the Data Source or Repository implementation level. Intercept raw exceptions (e.g., `DioException`, `DatabaseException`) and convert them to `Left(Failure)`.
- **Either Rules (fpdart)**:
  - All operations prone to failure (API requests, database operations, file storage, auth logic) must return `Either<Failure, Success>` instead of throwing raw exceptions or returning implicit error values like `null`, `false`, `-1`, or empty objects.

### 3.1. Mapper Rules (Model ↔ Entity Conversion)
- **Layer Isolation**: The Data Layer and Domain Layer must be strictly separated. **Mappers** are the exclusive bridge between them.
  - `Model → Entity`: The **Mapper** converts a Data Model into a pure Domain Entity.
  - `Entity → Model`: The **Mapper** converts a Domain Entity back into a Data Model for persistence or outbound transmission.
  - The **Repository** is the **only place** that calls the Mapper and returns results to the Domain layer.
  - **Presentation** and **Domain** layers must never import or manipulate Model classes directly.
  - **Data** layer must never use Entities for reading/writing JSON or interacting with API/Database.

- **Mapper Location Rule** (Single Responsibility Principle):
  - ❌ **Do NOT** define `toEntity()` or `toModel()` as methods inside the Model or Entity class.
  - ❌ **Do NOT** place mapping logic inside Repository implementation methods.
  - ✅ **Always** create a dedicated **Mapper** in `data/mappers/<feature_name>_mapper.dart`.
  - Mapper can be implemented as either a **Dart Extension** (preferred for simplicity) or a **Mapper Class** (preferred when mapping logic is complex or requires injection).

- **Standard directory structure**:
  ```text
  features/
    auth/
      data/
        models/
          user_model.dart       # Only: @freezed, fromJson(), toJson()
        mappers/
          user_mapper.dart      # Only: Model ↔ Entity conversion logic
        repositories/
          auth_repository_impl.dart
      domain/
        entities/
          user_entity.dart      # Only: pure business fields, no JSON, no fromJson
        repositories/
          auth_repository.dart
  ```

- **Model** (pure data representation, NO mapping logic):
  ```dart
  // data/models/user_model.dart
  @freezed
  abstract class UserModel with _$UserModel {
    const factory UserModel({
      required String id,
      required String email,
      @JsonKey(name: 'full_name') required String fullName,
    }) = _UserModel;

    factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
    // ❌ NO toEntity() here — that belongs in the Mapper
  }
  ```

- **Mapper** (Extension preferred — isolated in `data/mappers/`):
  ```dart
  // data/mappers/user_mapper.dart
  import 'package:snapspot/features/auth/data/models/user_model.dart';
  import 'package:snapspot/features/auth/domain/entities/user_entity.dart';

  extension UserModelMapper on UserModel {
    /// Model → Entity (Data → Domain)
    UserEntity toEntity() => UserEntity(
          id: id,
          email: email,
          fullName: fullName,
        );
  }

  extension UserEntityMapper on UserEntity {
    /// Entity → Model (Domain → Data)
    UserModel toModel() => UserModel(
          id: id,
          email: email,
          fullName: fullName,
        );
  }
  ```

- **Repository** calls Mapper — the only layer that touches both Model and Entity:
  ```dart
  // data/repositories/auth_repository_impl.dart
  import 'package:snapspot/features/auth/data/mappers/user_mapper.dart';

  Future<Either<Failure, UserEntity>> getUserById(String id) async {
    try {
      final model = await remoteDataSource.fetchUser(id);
      return Right(model.toEntity()); // Extension from user_mapper.dart
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
  ```





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

### 6. Immutable Models, JSON Mapping, and Code Generation (freezed & json_serializable)
- **Immutable Data Models & States**: Always design Data Layer Models (DTOs) and Presentation Layer States as immutable classes. Use **`freezed`** to automatically generate value equality (`==`), `hashCode`, `toString()`, and `copyWith` methods.
- **Auto-generated JSON Mapping**: Integrate **`json_serializable`** with `freezed` to automate model serialization and deserialization. Avoid writing manual `fromJson`/`toJson` mappings by hand.
- **Standard structures & Examples**:
  
  * **Simple Immutable Class**:
    ```dart
    @freezed
    abstract class MyClass with _$MyClass {
      factory MyClass({String? a, int? b}) = _MyClass;
    }
    // Usage:
    final example = MyClass(a: '42', b: 42);
    final cloned = example.copyWith(a: null); // MyClass(a: null, b: 42)
    ```

  * **Standard Serializable Class (json_serializable only)**:
    For mutable or standard class objects not requiring `freezed`, use `@JsonSerializable` on its own:
    ```dart
    import 'package:json_annotation/json_annotation.dart';

    part 'person.g.dart';

    @JsonSerializable()
    class Person {
      final String firstName, lastName;
      final DateTime? dateOfBirth;

      Person({required this.firstName, required this.lastName, this.dateOfBirth});

      factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
      Map<String, dynamic> toJson() => _$PersonToJson(this);
    }
    ```

  * **Union Classes (Perfect for State Management)**:
    ```dart
    @freezed
    sealed class Union with _$Union {
      const factory Union(int value) = Data;
      const factory Union.loading() = Loading;
      const factory Union.error([String? message]) = ErrorDetails;
      const factory Union.complex(int a, String b) = Complex;

      factory Union.fromJson(Map<String, Object?> json) => _$UnionFromJson(json);
    }
    ```

  * **Dart 3.0 Pattern Matching (UI Rendering)**:
    Use Dart 3.0's switch expressions instead of old `when` or `maybeWhen` callbacks for better performance and compile-time exhaustiveness checks:
    ```dart
    const unionExample = Union(42);
    final display = switch (unionExample) {
      Data(:final value) => 'Data: $value',
      Loading _ => 'Loading...',
      ErrorDetails(:final message) => 'Error: $message',
      Complex(:final a, :final b) => 'Complex: $a, $b',
    };
    ```

  * **Shared Properties in Union Classes**:
    Declare properties with the same name across different constructors to access them directly:
    ```dart
    @freezed
    abstract class SharedProperty with _$SharedProperty {
      factory SharedProperty.person({String? name, int? age}) = SharedProperty0;
      factory SharedProperty.city({String? name, int? population}) = SharedProperty1;
    }
    // Usage:
    var example = SharedProperty.person(name: 'Remi', age: 24);
    print(example.name); // OK: 'name' is shared
    // print(example.age); // COMPILE ERROR: age is not shared
    ```



- **Code Generation Rules (build_runner)**:
  - Do NOT modify generated files (ending in `.freezed.dart` or `.g.dart`) manually.
  - To generate code, run: `dart run build_runner build --delete-conflicting-outputs`.
  - When writing code that depends on generated files (e.g., calling generated constructors or `copyWith`), ensure you run the generator to keep files up-to-date.


### 4. Code Formatting
- Always run `dart format .` to maintain a consistent spacing and line-wrap.
- Prefer trailing commas for arguments, parameters, and collections containing more than one item to improve readability and git diff quality.

## Instructions
1. Analyze the requested file or code snippet.
2. Identify code quality issues (naming, structure, N+1 layout passes, mutable state leaks, hardcoded dependencies, or manual JSON mapping).
3. Apply the recommended refactoring according to clean code, dependency injection (get_it), and code generation (freezed) guidelines.
4. Verify compiling and formatting compatibility.


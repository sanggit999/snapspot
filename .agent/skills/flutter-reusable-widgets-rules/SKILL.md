---
name: flutter-reusable-widgets-rules
description: Quy chuẩn thiết kế và quản lý Reusable Widgets trong Flutter theo các thực thi tốt nhất (2026), phân tách `lib/core/widgets/` vs `features/<feature>/presentation/widgets/`, đặt tên với tiền tố App, và áp dụng 5 quy tắc chuẩn cho dự án lớn.
version: 1.0.0
author: Antigravity
tags:
  - flutter
  - ui
  - reusable-widgets
  - clean-architecture
  - design-system
---

# Flutter Reusable Widgets Skill

## Role & Overview

This skill guides Senior Flutter Developers in building production-ready, reusable UI components that are:
- **Reusable & Scalable**
- **Maintainable & Testable**
- **Clean Architecture Compliant**

---

## 1. Core Principles & Placement Rules (2 Features Rule)

### Rule 1: Feature-Scoped vs. Core-Shared Widgets
- **Feature-Scoped Widgets**: If a widget is used by **only one feature**, keep it inside that specific feature:
  `lib/features/<feature_name>/presentation/widgets/`
  *Examples*: `LoginForm`, `ProfileHeader`, `HomeBanner`, `ProductCard`, `NotificationItem`.
- **Core-Shared Widgets**: If a widget is shared by **two or more features (>= 2)**, move it into the global core UI module:
  `lib/core/widgets/`
  *Do not duplicate UI components across features.*

---

## 2. Folder Structure Guidelines

Flutter recommends using `lib/core/widgets/` (instead of top-level `widgets/`) to avoid confusion with the Flutter SDK and maintain a clear design system architecture:

```text
lib/
└── core/
    └── widgets/
        ├── app_avatar.dart
        ├── app_button.dart
        ├── app_card.dart
        ├── app_dialog.dart
        ├── app_icon_button.dart
        ├── app_loading.dart
        ├── app_text_field.dart
        └── main_navigation_layout.dart
```

---

## 3. Naming Conventions

### Core Reusable Widgets (`lib/core/widgets/`)
All global reusable widgets **must start with the `App` prefix** to distinguish them from standard Flutter SDK widgets:
- `AppButton`, `AppOutlinedButton`, `AppIconButton`
- `AppTextField`, `AppPasswordField`, `AppSearchField`
- `AppCard`, `AppDialog`, `AppLoading`, `AppAvatar`
- `AppNetworkImage`, `AppDivider`, `AppBottomSheet`, `AppSnackBar`

### Feature-Specific Widgets (`lib/features/<feature>/presentation/widgets/`)
Feature-scoped widgets must be named after the feature domain or section:
- `LoginForm`, `ProfileHeader`, `HomeBanner`, `ProductCard`, `NotificationItem`

---

## 4. Widget Responsibilities & Logic Separation

### Rule 2: Pure UI Responsibility
Widgets MUST ONLY be responsible for rendering UI components.
- ❌ **NEVER** contain business logic inside widgets.
- ❌ **NEVER** call API endpoints directly.
- ❌ **NEVER** access Repositories or UseCases.
- ❌ **NEVER** query Databases directly.
- ❌ **NEVER** manage global/feature application state inside reusable core widgets.
- ✅ **ALWAYS** receive data and callbacks exclusively through constructor parameters (`final String title`, `final VoidCallback? onPressed`).

---

## 5. Reusability & Composition Rules

### Rule 3: Highly Configurable via Composition
- **Composition over Inheritance**: Use constructor parameters to make widgets flexible instead of creating multiple similar widgets.
- Avoid hardcoded values inside reusable widgets. Expose commonly customized properties:
  - `text`, `onPressed`, `icon`, `color`, `height`, `width`
  - `padding`, `margin`, `borderRadius`, `isLoading`, `enabled`

*Example*:
Instead of `AppLoadingButton` and `AppDisabledButton`, use `AppButton` with `isLoading: true` or `enabled: false`.

---

## 6. Design System & Theme Rules

### Rule 4: Centralized Tokens (Zero Hardcoding)
Never hardcode raw values directly inside widgets:
- ❌ `Color(0xFF6C5CE7)` ➡️ ✅ `AppColors.primary`
- ❌ `16.0` (fontSize) ➡️ ✅ `AppTextStyles.bodyMedium`
- ❌ `FontWeight.bold` ➡️ ✅ `AppTextStyles.headlineSmall.fontWeight`
- ❌ `12.0` (radius) ➡️ ✅ `AppRadius.md`
- ❌ `16.0` (padding) ➡️ ✅ `AppSpacing.md`
- ❌ `Duration(milliseconds: 300)` ➡️ ✅ `AppDuration.fast`

---

## 7. File & Import Rules

### Rule 5: Direct Explicit Import (No Barrel Files)
- **One widget per file**: Each reusable widget resides in its own `.dart` file named in `snake_case` (e.g., `app_button.dart`).
- **No Barrel Files**: Absolute NO barrel files (`widgets.dart` or `index.dart`). Every consumer widget must directly import the exact target widget file:
  ```dart
  // ✅ Direct Explicit Import:
  import 'package:snapspot/core/widgets/buttons/app_button.dart';
  import 'package:snapspot/core/widgets/inputs/app_text_field.dart';
  ```

---

## 8. Performance Rules

- **Prefer `StatelessWidget`**: Use `StatelessWidget` whenever local state is not required.
- **`const` Constructors**: Always provide and use `const` constructors to prevent unnecessary rebuilds.
- **Minimize Rebuild Scope**: Keep widget trees shallow and extract sub-trees into separate const widgets.

---

## 9. Documentation Standard

Every reusable widget must include docstrings covering:
1. **Purpose**: What the component represents.
2. **Parameters**: Key parameters explained.
3. **Usage Example**: How to instantiate it.

```dart
/// Purposed: Reusable primary action button across SnapSpot.
///
/// Parameters:
/// - [text]: The label displayed on the button.
/// - [onPressed]: Callback when tapped.
/// - [isLoading]: Displays a progress indicator if true.
///
/// Usage:
/// ```dart
/// AppButton(
///   text: 'Submit',
///   onPressed: () => _handleSubmit(),
/// )
/// ```
class AppButton extends StatelessWidget { ... }
```

---

## 10. Agent Output Rules

When generating or refactoring reusable widgets:
1. **Explain reusability reason**: State whether it belongs in `core/widgets/` (shared >= 2 features) or `features/<feature>/presentation/widgets/`.
2. **Suggest exact folder & file path**: e.g., `lib/core/widgets/app_button.dart`.
3. **Strict Lint & Clean Architecture**: Ensure code passes all Flutter lints with 0 warnings.
4. **Production-Ready Code Only**: Never generate quick prototypes or hardcoded temporary placeholders.

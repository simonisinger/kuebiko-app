# Service Locator - Dependency Injection Service

This package provides a simple dependency injection (DI) service for the Kuebiko Web Client application using the Service Locator pattern.

## Overview

The `ServiceLocator` class is a centralized registry for application-wide dependencies. It follows the service locator pattern to provide easy access to services throughout the application.

Key features:
- Singleton implementation for application-wide access
- Lazy initialization of services
- Type-safe service registration and retrieval
- BuildContext extension for convenient access in widgets

## Usage

### Initialization

Initialize the service locator at application startup:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the service locator
  await ServiceLocator.instance.initialize();

  runApp(MyApp());
}
```

### Registering Services

Services are registered during initialization in the `initialize()` method:

```dart
Future<void> initialize() async {
  if (_isInitialized) return;

  // Register secure storage
  final secureStorage = FlutterSecureStorage(
    aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock)
  );
  register<FlutterSecureStorage>(secureStorage);

  // Register other services
  register<MyService>(MyService());

  _isInitialized = true;
}
```

You can also register services manually:

```dart
// Create a service instance
final authService = AuthService();

// Register it with the service locator
ServiceLocator.instance.register<AuthService>(authService);
```

### Accessing Services

There are two ways to access services:

#### 1. Using BuildContext Extension (Recommended)

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get a service using the context extension
    final settingsService = context.service<SettingService>();

    return Text('Font: ${settingsService.fontFamily}');
  }
}
```

#### 2. Direct Access

```dart
class MyService {
  void doSomething() {
    final otherService = ServiceLocator.instance.get<OtherService>();
    // Use otherService...
  }
}
```

## Benefits

Using the Service Locator pattern provides several benefits:

1. **Centralized Dependency Management**: All dependencies are managed in one place.
2. **Reduced Coupling**: Components depend on abstractions rather than concrete implementations.
3. **Easier Testing**: Services can be easily mocked or replaced for testing.
4. **Simplified Service Access**: Services can be accessed from anywhere in the application.
5. **Lazy Initialization**: Services are only created when needed.

## Example

See the `examples/di_example_widget.dart` file for a complete example of how to use the ServiceLocator in widgets.

## Best Practices

1. Register services by their interface type when possible
2. Initialize the service locator as early as possible in the application lifecycle
3. Prefer using the BuildContext extension in widgets
4. Use direct access sparingly, mainly in service-to-service communication
5. Consider using factory functions for services that need custom initialization

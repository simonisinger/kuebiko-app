import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kuebiko_web_client/services/settings/app.dart';
import 'package:kuebiko_web_client/services/client.dart';
import 'package:kuebiko_web_client/services/storage/storage.dart';

/// A simple dependency injection service that manages application-wide dependencies.
/// 
/// This class follows the service locator pattern to provide centralized access
/// to services throughout the application. It lazily initializes services
/// when they are first requested and maintains singleton instances.
class ServiceLocator {
  // Private constructor to prevent external instantiation
  ServiceLocator._();
  
  // Singleton instance
  static final ServiceLocator _instance = ServiceLocator._();
  
  // Factory constructor to return the singleton instance
  factory ServiceLocator() => _instance;
  
  // Static getter for easier access
  static ServiceLocator get instance => _instance;
  
  // Map to store service instances
  final Map<Type, Object> _services = {};
  
  // Flag to track initialization status
  bool _isInitialized = false;
  
  /// Initialize all required services.
  /// 
  /// This method should be called once during app startup, before
  /// any services are accessed.
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Register secure storage
    final secureStorage = FlutterSecureStorage(
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true
      ),
      iOptions: const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock
      )
    );
    register<FlutterSecureStorage>(secureStorage);
    
    // Register storage service
    register<StorageService>(StorageService());
    
    // Initialize and register settings service
    final settingsService = await SettingService.init();
    register<SettingService>(settingsService);
    
    // Register client service
    register<ClientService>(ClientService());
    
    _isInitialized = true;
  }
  
  /// Register a service instance with the service locator.
  /// 
  /// This method allows registering a service with its type as the key.
  void register<T>(Object service) {
    _services[T] = service;
  }
  
  /// Get a service instance by its type.
  /// 
  /// This method retrieves a previously registered service.
  /// Throws an exception if the service is not registered.
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service of type $T not registered');
    }
    return service as T;
  }
  
  /// Check if a service is registered.
  bool isRegistered<T>() {
    return _services.containsKey(T);
  }
  
  /// Reset all registered services.
  /// 
  /// This method is primarily useful for testing.
  void reset() {
    _services.clear();
    _isInitialized = false;
  }
}

/// Extension method to easily access the service locator from BuildContext
extension ServiceLocatorExtension on BuildContext {
  ServiceLocator get serviceLocator => ServiceLocator.instance;
  
  /// Convenient method to get a service directly from BuildContext
  T service<T>() => serviceLocator.get<T>();
}
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage storage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true
  ),
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock
  )
);
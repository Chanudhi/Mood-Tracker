import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static final _storage = FlutterSecureStorage();
  static final _encrypter = Encrypter(AES(Key.fromSecureRandom(32)));

  static Future<void> init() async {
    if (await _storage.read(key: 'key') == null) {
      await _storage.write(key: 'key', value: _encrypter.key.base64);
    }
  }

  static Future<String> encrypt(String text) async {
    final key = await _storage.read(key: 'key');
    final iv = IV.fromSecureRandom(16);
    return Encrypter(AES(Key.fromBase64(key!))).encrypt(text, iv: iv).base64;
  }

  static Future<String> decrypt(String encrypted) async {
    final key = await _storage.read(key: 'key');
    final iv = IV.fromSecureRandom(16);
    return Encrypter(AES(Key.fromBase64(key!))).decrypt64(encrypted, iv: iv);
  }
}
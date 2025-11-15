import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:agristack/domain/services/secrets_service.dart';

class SecureSecretsService implements SecretsService {
  static const _k = 'gemini_api_key';
  final _store = const FlutterSecureStorage();

  @override
  Future<String?> getGeminiApiKey() async {
    const fromEnv = String.fromEnvironment('GEMINI_API_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    return await _store.read(key: _k);
  }

  @override
  Future<void> saveGeminiApiKey(String value) async {
    await _store.write(key: _k, value: value.trim());
  }
}
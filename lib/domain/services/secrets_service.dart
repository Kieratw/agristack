abstract class SecretsService {
  Future<String?> getGeminiApiKey();      
  Future<void> saveGeminiApiKey(String value);  // <- dodaj nazwę parametru
}
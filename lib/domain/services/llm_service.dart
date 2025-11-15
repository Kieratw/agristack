import 'package:agristack/domain/value/result.dart';

abstract class LlmService {
  Future<Result<String>> generateContent(
    String prompt, {
    double temperature = 0.4,
    int maxTokens = 600,
  });

  Stream<String> streamContent(
    String prompt, {
    double temperature = 0.4,
    int maxTokens = 600,
  });
}
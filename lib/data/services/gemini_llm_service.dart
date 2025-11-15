import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:agristack/domain/services/llm_service.dart';
import 'package:agristack/domain/value/result.dart';

class GeminiLlmService implements LlmService {
  final String apiKey; // <- wstrzykiwany z zewnątrz
  static const String _modelName = 'gemini-1.5-flash-latest';

  GeminiLlmService({required this.apiKey});

  GenerativeModel _buildModel({double temperature = 0.4, int maxTokens = 600}) {
    if (apiKey.isEmpty) {
      throw const AppError('llm.no_key', 'Brak klucza API.');
    }
    return GenerativeModel(
      model: _modelName,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: temperature,
        maxOutputTokens: maxTokens,
      ),
    );
  }

  @override
  Future<Result<String>> generateContent(
    String prompt, {
    double temperature = 0.4,
    int maxTokens = 600,
  }) async {
    try {
      final model = _buildModel(temperature: temperature, maxTokens: maxTokens);
      final resp = await model.generateContent([Content.text(prompt)]);
      final text = (resp.text ?? '').trim();
      if (text.isEmpty) {
        return const Result.err(AppError('llm.empty', 'Model nie zwrócił treści.'));
      }
      return Result.ok(text);
    } catch (e) {
      return Result.err(AppError('llm.failed', e.toString()));
    }
  }

  @override
  Stream<String> streamContent(
    String prompt, {
    double temperature = 0.4,
    int maxTokens = 600,
  }) async* {
    final controller = StreamController<String>();
    try {
      final model = _buildModel(temperature: temperature, maxTokens: maxTokens);
      final stream = model.generateContentStream([Content.text(prompt)]);
      stream.listen((event) {
        final chunk = event.text;
        if (chunk != null && chunk.isNotEmpty) controller.add(chunk);
      }, onError: (e, _) {
        controller.addError(AppError('llm.failed', e.toString()));
        controller.close();
      }, onDone: () => controller.close());
    } catch (e) {
      controller.addError(AppError('llm.failed', e.toString()));
      await controller.close();
    }
    yield* controller.stream;
  }
}
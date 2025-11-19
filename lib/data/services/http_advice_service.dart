import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agristack/domain/services/advice_service.dart';
import 'package:agristack/domain/value/result.dart';
import 'package:agristack/data/models/advice_dtos.dart';

class HttpAdviceService implements AdviceService {
  // TODO: Move to configuration/secrets
  static const String _baseUrl = 'https://agristack-advice-api-2739817dc93b.herokuapp.com';

  final http.Client _client;

  HttpAdviceService({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<Result<AdviceResponse>> getAdvice(AdviceRequest request) async {
    try {
      final url = Uri.parse('$_baseUrl/api/advice');
      final body = jsonEncode(request.toJson());

      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        return Result.ok(AdviceResponse.fromJson(json));
      } else {
        return Result.err(
          AppError(
            'advice.api_error',
            'API returned ${response.statusCode}: ${response.body}',
          ),
        );
      }
    } catch (e) {
      return Result.err(AppError('advice.network_error', e.toString()));
    }
  }
}

import 'package:agristack/domain/value/result.dart';
import 'package:agristack/data/models/advice_dtos.dart';

abstract class AdviceService {
  Future<Result<AdviceResponse>> getAdvice(AdviceRequest request);
}

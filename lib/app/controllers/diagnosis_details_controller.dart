import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agristack/app/di.dart';
import 'package:agristack/domain/entities/entities.dart';
import 'package:agristack/domain/usecases/agristack_usecases.dart';
import 'package:agristack/domain/value/result.dart';

final diagnosisDetailsControllerProvider = StateNotifierProvider.autoDispose<
    DiagnosisDetailsController, AsyncValue<String?>>(
  (ref) => DiagnosisDetailsController(ref),
);

class DiagnosisDetailsController
    extends StateNotifier<AsyncValue<String?>> {
  final Ref ref;
  DiagnosisDetailsController(this.ref) : super(const AsyncValue.data(null));

  String _inferCropFromModelId(String modelId) {
    final id = modelId.toLowerCase();
    if (id.startsWith('wheat_')) return 'wheat';
    if (id.startsWith('potato_')) return 'potato';
    if (id.startsWith('rape_') || id.startsWith('oilseed_rape')) {
      return 'oilseed_rape';
    }
    return 'unknown';
  }

  Future<void> askExpert(
    DiagnosisEntryEntity entry, {
    String? bbch,
    String? question,
  }) async {
    state = const AsyncValue.loading();
    try {
      final uc =
          await ref.read(getEnhancedRecommendationUseCaseProvider.future);

      final crop = _inferCropFromModelId(entry.modelId);

      final params = GetEnhancedParams(
        crop: crop,
        canonicalDiseaseId: entry.canonicalDiseaseId,
        bbch: (bbch != null && bbch.trim().isNotEmpty) ? bbch.trim() : null,
        userQuery: (question != null && question.trim().isNotEmpty)
            ? question.trim()
            : null,
        kb: const [],
        locale: 'pl',
      );

      final res = await uc.call(params);
      if (res.isOk && res.data != null) {
        state = AsyncValue.data(res.data);
      } else {
        state = AsyncValue.error(
          res.error ?? const AppError('llm.unknown', 'Brak odpowiedzi z modelu'),
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clearAnswer() {
    state = const AsyncValue.data(null);
  }
}

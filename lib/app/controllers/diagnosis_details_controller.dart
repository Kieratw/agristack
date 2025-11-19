import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agristack/app/di.dart';
import 'package:agristack/domain/entities/entities.dart';
import 'package:agristack/domain/usecases/agristack_usecases.dart';
import 'package:agristack/domain/value/result.dart';

import 'package:agristack/data/models/advice_dtos.dart';

final diagnosisDetailsControllerProvider =
    StateNotifierProvider.autoDispose<
      DiagnosisDetailsController,
      AsyncValue<AdviceResponse?>
    >((ref) => DiagnosisDetailsController(ref));

class DiagnosisDetailsController
    extends StateNotifier<AsyncValue<AdviceResponse?>> {
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
    String? seasonContext,
    int? timeSinceLastSprayDays,
    String? situationDescription,
  }) async {
    state = const AsyncValue.loading();
    try {
      final uc = await ref.read(
        getEnhancedRecommendationUseCaseProvider.future,
      );

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
        seasonContext: seasonContext ?? 'Brak danych o sezonie',
        timeSinceLastSprayDays: timeSinceLastSprayDays,
        situationDescription: situationDescription ?? 'Brak dodatkowego opisu',
      );

      final res = await uc.call(params);
      if (res.isOk && res.data != null) {
        state = AsyncValue.data(res.data);
      } else {
        state = AsyncValue.error(
          res.error ??
              const AppError('advice.unknown', 'Brak odpowiedzi z serwera'),
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

class AdviceRequest {
  final String crop;
  final String status;
  final String bbch;
  final String seasonContext;
  final int? timeSinceLastSprayDays;
  final String situationDescription;

  AdviceRequest({
    required this.crop,
    required this.status,
    required this.bbch,
    required this.seasonContext,
    this.timeSinceLastSprayDays,
    required this.situationDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'crop': crop,
      'status': status,
      'bbch': bbch,
      'season_context': seasonContext,
      'time_since_last_spray_days': timeSinceLastSprayDays,
      'situation_description': situationDescription,
    };
  }
}

class AdviceProduct {
  final String name;
  final String dose;
  final String storeTalkHint;

  AdviceProduct({
    required this.name,
    required this.dose,
    required this.storeTalkHint,
  });

  factory AdviceProduct.fromJson(Map<String, dynamic> json) {
    return AdviceProduct(
      name: json['name'] as String? ?? '',
      dose: json['dose'] as String? ?? '',
      storeTalkHint: json['store_talk_hint'] as String? ?? '',
    );
  }
}

class AdviceResponse {
  final String summary;
  final List<AdviceProduct> products;
  final List<String> sources;
  final String disclaimer;

  AdviceResponse({
    required this.summary,
    required this.products,
    required this.sources,
    required this.disclaimer,
  });

  factory AdviceResponse.fromJson(Map<String, dynamic> json) {
    return AdviceResponse(
      summary: json['summary'] as String? ?? '',
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => AdviceProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      disclaimer: json['disclaimer'] as String? ?? '',
    );
  }
}

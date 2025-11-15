class ExpertPromptBuilder {
  final String locale; // 'pl' lub 'en'
  ExpertPromptBuilder({this.locale = 'pl'});

  String build({
    required String crop,
    required String canonicalDiseaseId,
    required String diseaseDisplayPl,
    String? bbch,
    String? userQuery,
    List<String> kb = const [],
  }) {
    final lang = locale.toLowerCase().startsWith('pl') ? 'polsku' : 'English';
    final bbchLine = bbch == null ? 'nieokreślona' : bbch;
    final rag = kb.isEmpty ? '' : '\n\n# Kontekst (lokalny)\n' + kb.map((t) => '- $t').join('\n');

    return '''
Jesteś ekspertem agronomicznym AgriStack. Odpowiadasz zwięźle, w $lang, w listach punktowanych.
Nie podawaj nazw handlowych ani dawek. Działania chemiczne opisuj ogólnie (sprawdzić etykietę i lokalne przepisy UE/PL; konsultacja z doradcą).

Parametry:
- Uprawa: $crop
- Choroba: $diseaseDisplayPl ($canonicalDiseaseId)
- Faza BBCH: $bbchLine
- Pytanie: ${userQuery ?? 'Brak, podaj standardowe zalecenia.'}

Format:
1) Krótka ocena (1–2 zdania).
2) Działania niechemiczne (3–5 punktów).
3) Działania chemiczne (ogólnie, z notą bezpieczeństwa).
4) Kiedy wezwać doradcę (2–3 punkty).$rag
''';
  }
}

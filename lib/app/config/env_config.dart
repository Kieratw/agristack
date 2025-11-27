class EnvConfig {
  static const String adviceApiUrl = String.fromEnvironment(
    'ADVICE_API_URL',
    defaultValue: 'https://agristack-advice-api-2739817dc93b.herokuapp.com',
  );
}

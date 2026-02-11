# AgriStack 

Aplikacja mobilna wspierająca rolników w precyzyjnej diagnozie chorób roślin uprawnych. Wykorzystuje modele CNN (PyTorch Mobile) działające offline na urządzeniu — analiza jest możliwa bez dostępu do Internetu.

## Funkcjonalności

- **Diagnoza offline** — rozpoznawanie chorób pszenicy, ziemniaka, rzepaku i pomidora na podstawie zdjęć liści
- **Test-Time Augmentation (TTA)** — 4-krotna augmentacja obrazu (oryginał, flip, zoom, przyciemnienie) dla wyższej dokładności
- **Mapa pól** — zarządzanie polami, rysowanie granic, wizualizacja miejsc diagnoz na mapie Google
- **Historia diagnoz** — zapis wyników z lokalizacją GPS, datą i pewnością modelu
- **Porady eksperta (AI)** — integracja z LLM (wymaga backendu Advice API + Internetu)
- **Eksport PDF** — generowanie raportów z diagnoz
- **Lokalna baza danych** — dane przechowywane na urządzeniu (Isar DB)

## Technologie

| Warstwa | Technologia |
|---|---|
| UI & logika | Flutter & Dart |
| Stan aplikacji | Riverpod |
| Nawigacja | GoRouter |
| Baza danych | Isar (NoSQL, lokalna) |
| Inferencja AI | PyTorch Mobile (Android, MethodChannel) |
| Mapy | Google Maps SDK |
| Backend porad | Advice API (osobne repozytorium) |

## Architektura

Projekt stosuje **Clean Architecture** z podziałem na trzy warstwy:

```
lib/
├── domain/          # Encje, modele, interfejsy repozytoriów i serwisów, use case'y
├── data/            # Implementacje repozytoriów, serwisy (HTTP, MethodChannel), mappery
├── app/             # UI (pages), kontrolery, routing, DI (Riverpod), theme
│   ├── config/      # Konfiguracja środowiskowa (env_config.dart)
│   ├── controllers/ # Kontrolery stanu (Riverpod Notifiers)
│   ├── pages/       # Ekrany aplikacji
│   ├── services/    # Serwisy aplikacyjne (PDF, lokalizacja)
│   ├── usecases/    # Implementacje use case'ów
│   └── utils/       # Narzędzia (tłumaczenia, geometria)
└── main.dart
```

## Wymagania

- Flutter SDK ^3.8.1
- Android 5.0+ (API 21)
- Dostęp do aparatu i lokalizacji GPS

## Konfiguracja i uruchomienie

### 1. Klonowanie

```bash
git clone https://github.com/Kieratw/agristack.git
cd agristack
flutter pub get
```

### 2. Zmienne środowiskowe (`--dart-define`)

Aplikacja wymaga podania kluczy przy budowaniu/uruchamianiu:

| Zmienna | Opis | Wymagana? |
|---|---|---|
| `GOOGLE_MAPS_API_KEY` | Klucz API Google Maps (uzyskaj w [Google Cloud Console](https://console.cloud.google.com/apis/credentials)) | ✅ Tak |
| `ADVICE_API_URL` | URL backendu Advice API (np. `http://localhost:8000`) | Tylko dla porad AI |

Klucz Google Maps można też ustawić przez plik `android/local.properties`:
```properties
GOOGLE_MAPS_API_KEY_DEBUG=twoj_klucz
GOOGLE_MAPS_API_KEY_RELEASE=twoj_klucz
```

### 3. Backend — Advice API

Aby korzystać z funkcji **porad eksperckich (AI)**, musisz uruchomić serwer Advice API:

1. Sklonuj repozytorium: [Kieratw/agristack-advice-api](https://github.com/Kieratw/agristack-advice-api)
2. Skonfiguruj w nim klucz do **Google AI Studio** (Gemini API)
3. Uruchom serwer (domyślnie `http://localhost:8000`)

> **Uwaga:** Bez uruchomionego backendu aplikacja działa normalnie — jedynie funkcja porad AI będzie niedostępna.

### 4. Uruchomienie

```bash
flutter run \
  --dart-define=GOOGLE_MAPS_API_KEY="twoj_klucz_google_maps" \
  --dart-define=ADVICE_API_URL="http://twoj-adres-api:8000"
```

### 5. Budowanie APK

```bash
flutter build apk \
  --dart-define=GOOGLE_MAPS_API_KEY="twoj_klucz_google_maps" \
  --dart-define=ADVICE_API_URL="https://twoj-adres-api.com"
```

## Obsługiwane uprawy i modele

| Uprawa | Model | Architektura |
|---|---|---|
| Pszenica | `wheat_v2.ptl` | MobileNetV3_Large |
| Ziemniak | `potato_v2.ptl` | MobileNetV3_Large |
| Rzepak | `oilseed_rape_v2.ptl` | MobileNetV3_Large |
| Pomidor | `tomato_v2.ptl` | MobileNetV3_Large |

Modele CNN zostały wytrenowane w osobnym repozytorium: [**cropdoc-trainer**](https://github.com/Kieratw/cropdoc-trainer) — zawiera pipeline treningowy z Knowledge Distillation, ewaluację z TTA oraz eksport do PyTorch Mobile.

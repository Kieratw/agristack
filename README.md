# AgriStack

**AgriStack** to innowacyjna aplikacja mobilna wspierająca rolników w precyzyjnej diagnozie chorób roślin uprawnych. Wykorzystuje zaawansowane modele sztucznej inteligencji (CNN) działające bezpośrednio na urządzeniu (offline), co pozwala na szybką analizę bez konieczności dostępu do Internetu w polu.

## Główne Funkcjonalności

*   **Diagnoza Offline**: Rozpoznawanie chorób pszenicy, ziemniaka, rzepaku i pomidora na podstawie zdjęć liści.
*   **Mapa Pól**: Zarządzanie polami uprawnymi, rysowanie granic pól na mapie Google, wizualizacja miejsc wykonania diagnozy.
*   **Historia Diagnoz**: Zapisywanie wyników wraz z lokalizacją GPS, datą i pewnością modelu.
*   **Porady Eksperckie**: Integracja z systemem doradczym (LLM) w celu uzyskania szczegółowych zaleceń (wymaga Internetu).
*   **Lokalna Baza Danych**: Wszystkie dane są bezpiecznie przechowywane na urządzeniu użytkownika (Isar DB).

## Technologie

Projekt został zrealizowany przy użyciu nowoczesnych technologii:

*   **Flutter & Dart**: Wieloplatformowy framework UI.
*   **PyTorch Mobile**: Uruchamianie modeli sieci neuronowych na urządzeniu.
*   **Isar Database**: Wydajna, lokalna baza danych NoSQL.
*   **Riverpod**: Zarządzanie stanem aplikacji.
*   **Google Maps SDK**: Integracja z mapami.

## Wymagania

*   Android 5.0 (API level 21) lub nowszy.
*   Dostęp do aparatu i lokalizacji GPS.

## Konfiguracja i Uruchomienie

Aby w pełni korzystać z funkcji aplikacji (w tym z porad eksperckich), wymagane jest uruchomienie backendu **Advice API**.

### 1. Backend (Advice API)

Aplikacja komunikuje się z zewnętrznym API do generowania porad.
1.  Pobierz i uruchom projekt Advice API (dostępny w osobnym repozytorium).
2.  Upewnij się, że API działa i jest dostępne (np. pod adresem `http://localhost:8000` lub publicznym URL).

### 2. Aplikacja Mobilna

1.  **Klonowanie repozytorium**:
    ```bash
    git clone https://github.com/Kieratw/agristack.git
    cd agristack
    ```

2.  **Konfiguracja zmiennych środowiskowych**:
    Aplikacja domyślnie łączy się z produkcyjnym API. Aby wskazać własny adres backendu (np. lokalny), użyj flagi `--dart-define` przy uruchamianiu:

    ```bash
    flutter run --dart-define=ADVICE_API_URL="http://twoj-adres-api:8000"
    ```

    > **Uwaga**: Ten adres API jest niezbędny do komunikacji z modelem LLM (Google AI Studio) w celu generowania porad eksperckich.


3.  **Klucze API**:
    Utwórz plik `android/local.properties` i dodaj swój klucz Google Maps:
    ```properties
    GOOGLE_MAPS_API_KEY_DEBUG=twoj_klucz_debug
    GOOGLE_MAPS_API_KEY_RELEASE=twoj_klucz_release
    ```

4.  **Uruchomienie**:
    ```bash
    flutter pub get
    flutter run
    ```


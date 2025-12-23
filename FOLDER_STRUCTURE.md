# Klasör Yapısı

## Proje Kök Dizini

```
medication-tracking/
├── lib/
│   ├── core/                    # Çekirdek yapılandırmalar ve yardımcılar
│   │   ├── constants/          # Sabitler
│   │   ├── errors/             # Hata yönetimi
│   │   ├── network/            # Network yapılandırması
│   │   ├── theme/              # Tema ve stil
│   │   ├── utils/              # Yardımcı fonksiyonlar
│   │   ├── extensions/         # Extension'lar
│   │   ├── widgets/            # Ortak widget'lar (components)
│   │   ├── pages/              # Base page ve ortak page yapıları
│   │   └── logger/             # Logger yapılandırması
│   │
│   ├── features/               # Özellik bazlı klasör yapısı
│   │   └── [feature_name]/    # Her özellik için ayrı klasör
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   ├── local/
│   │       │   │   └── remote/
│   │       │   ├── models/
│   │       │   └── repositories/
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   ├── repositories/
│   │       │   └── usecases/
│   │       └── presentation/
│   │           ├── pages/
│   │           ├── widgets/
│   │           └── providers/  # veya controllers/blocs
│   │
│   ├── main.dart               # Uygulama giriş noktası
│   └── injection_container.dart # Dependency injection setup
│
├── test/                       # Test dosyaları
│   ├── core/
│   └── features/
│       └── [feature_name]/
│           ├── data/
│           ├── domain/
│           └── presentation/
│
├── assets/                     # Statik dosyalar
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── pubspec.yaml               # Bağımlılıklar
├── analysis_options.yaml      # Linter kuralları
├── ARCHITECTURE.md            # Bu mimari dokümantasyon
├── FOLDER_STRUCTURE.md        # Bu dosya
├── CODING_STANDARDS.md        # Kod standartları
└── PATTERNS.md                # Design pattern'ler
```

## Feature Bazlı Yapı

Her özellik (feature) kendi klasöründe ve kendi katmanlarıyla organize edilir:

### Örnek: Medication Feature

```
features/
└── medication/
    ├── data/
    │   ├── datasources/
    │   │   ├── local/
    │   │   │   └── medication_local_datasource.dart
    │   │   └── remote/
    │   │       └── medication_remote_datasource.dart
    │   ├── models/
    │   │   └── medication_model.dart
    │   └── repositories/
    │       └── medication_repository_impl.dart
    │
    ├── domain/
    │   ├── entities/
    │   │   └── medication.dart
    │   ├── repositories/
    │   │   └── medication_repository.dart
    │   └── usecases/
    │       ├── get_medications.dart
    │       ├── add_medication.dart
    │       └── delete_medication.dart
    │
    └── presentation/
        ├── pages/
        │   ├── medication_list_page.dart
        │   └── medication_detail_page.dart
        ├── widgets/
        │   ├── medication_card.dart
        │   └── medication_form.dart
        └── providers/
            └── medication_provider.dart
```

## İsimlendirme Kuralları

- **Dosya İsimleri**: snake_case (örn: `medication_repository.dart`)
- **Sınıf İsimleri**: PascalCase (örn: `MedicationRepository`)
- **Değişken İsimleri**: camelCase (örn: `medicationList`)
- **Sabitler**: lowerCamelCase veya SCREAMING_SNAKE_CASE (örn: `apiBaseUrl` veya `API_BASE_URL`)

## Core Klasörü

Core klasörü tüm özellikler tarafından kullanılan ortak yapıları içerir:

- **constants/**: Uygulama genelinde kullanılan sabitler (const değişkenler, static YASAK)
- **errors/**: Hata sınıfları ve exception'lar
- **network/**: API client, interceptors, network info
- **theme/**: Renkler (AppColors - dark/light tema uyumlu), text stilleri, tema yapılandırması
- **utils/**: Yardımcı fonksiyonlar (validators, formatters, vb.) - static YASAK, extension kullan
- **extensions/**: Dart extension'ları
- **widgets/**: Ortak kullanılan widget'lar (buttons, cards, inputs, vb.) - responsive ve tema uyumlu
- **pages/**: Base page sınıfı ve ortak page yapıları
- **logger/**: Logger yapılandırması ve helper'lar

## Önemli Notlar

1. **Feature Bazlı Yapı**: Her özellik bağımsız bir modül gibi düşünülür
2. **Katman Ayrımı**: Her feature içinde data, domain, presentation katmanları ayrı tutulur
3. **Core Kullanımı**: Core klasörü sadece ortak yapılar için kullanılır, feature-specific kodlar features içinde olmalıdır
4. **Test Eşleşmesi**: Test klasör yapısı lib klasör yapısını yansıtır


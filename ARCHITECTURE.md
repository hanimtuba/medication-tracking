# Mimari Dokümantasyon

## Genel Yaklaşım

Bu proje **Clean Architecture** prensiplerine uygun olarak geliştirilecektir. Katmanlı mimari yapısı kullanılacak ve her katmanın sorumluluğu net bir şekilde ayrılacaktır.

## Mimari Katmanlar

### 1. Presentation Layer (UI Katmanı)
- **Widgets**: UI bileşenleri
- **Pages/Screens**: Ekranlar
- **Controllers/ViewModels**: State yönetimi (Provider/Riverpod/Bloc)
- **Models**: UI için özel modeller (gerekirse)

### 2. Domain Layer (İş Mantığı Katmanı)
- **Entities**: Domain modelleri
- **Use Cases**: İş mantığı senaryoları
- **Repositories (Interfaces)**: Repository arayüzleri

### 3. Data Layer (Veri Katmanı)
- **Repositories (Implementations)**: Repository implementasyonları
- **Data Sources**: 
  - Local (Hive/SQLite/SharedPreferences)
  - Remote (API servisleri)
- **Models**: Data modelleri (DTOs)
- **Mappers**: Entity ↔ Model dönüşümleri

## Bağımlılık Yönü

```
Presentation → Domain ← Data
```

- Presentation katmanı sadece Domain katmanına bağımlıdır
- Data katmanı Domain katmanına bağımlıdır
- Domain katmanı hiçbir katmana bağımlı değildir (pure Dart)

## State Management

**Provider** kullanılacak. Tüm state yönetimi Provider pattern ile yapılacak.

## Dependency Injection

**get_it** veya **Riverpod** ile dependency injection yapılacak

## Veri Saklama

- **Local**: Hive veya SQLite (hafif veriler için Hive tercih edilir)
- **Remote**: REST API (http/dio paketi)

## Test Stratejisi

- **Unit Tests**: Domain ve Data katmanları için
- **Widget Tests**: UI bileşenleri için
- **Integration Tests**: End-to-end senaryolar için

## Önemli Prensipler

1. **SOLID Prensipleri**: Tüm kod SOLID prensiplerine uygun yazılacak
2. **DRY**: Kod tekrarından kaçınılacak
3. **KISS**: Basit ve anlaşılır kod yazılacak
4. **Separation of Concerns**: Her sınıf tek bir sorumluluğa sahip olacak
5. **Dependency Inversion**: Soyutlamalara bağımlılık, somut implementasyonlara değil

## Özel Gereksinimler

### Base Page Pattern
- Tüm page'ler `BasePage` sınıfından miras alacak
- Ortak işlevler (loading, error handling, lifecycle) base page'de olacak
- Her page sadece kendi özel UI'ını implement edecek

### Logging
- **Logger** paketi kullanılacak (logger paketi)
- Tüm hatalar loglanacak
- Debug, Info, Warning, Error seviyeleri kullanılacak
- Production'da sadece Error ve Warning logları aktif olacak

### Component Pattern
- Benzer tasarımlar için ortak component'ler kullanılacak
- `core/widgets/` klasöründe ortak widget'lar olacak
- Her component tekrar kullanılabilir ve test edilebilir olacak

### Build Metod Optimizasyonu
- Build metodları mümkün olduğunca küçük tutulacak
- Büyük widget ağaçları küçük widget'lara bölünecek
- `const` constructor'lar kullanılacak
- `Consumer` widget'ı ile sadece gerekli kısımlar rebuild edilecek
- `child` parametresi kullanılarak rebuild'ler minimize edilecek


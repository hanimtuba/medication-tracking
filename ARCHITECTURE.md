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

**get_it** kullanılacak. **KRİTİK**: Tüm bağımlılıklar DI container üzerinden yönetilecek.
- Hiçbir yerde `new` keyword'ü ile direkt instance oluşturulmayacak
- Tüm servisler, repository'ler, use case'ler DI ile inject edilecek
- Test edilebilirlik için DI zorunludur

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

### Responsive Tasarım
- **TÜM TASARIMLAR RESPONSIVE OLACAK** - Bu kritik bir gereksinimdir
- **flutter_screenutil** paketi kullanılacak
- Tüm boyutlar (width, height, font size, padding, margin) responsive olacak
- `sp()` fonksiyonu ile font boyutları responsive yapılacak
- `w()`, `h()`, `r()` fonksiyonları ile boyutlar responsive yapılacak
- Farklı ekran boyutlarına (phone, tablet, desktop) uyum sağlanacak
- Orientation değişikliklerine (portrait/landscape) uyum sağlanacak
- Her widget ve page responsive olarak tasarlanacak

### Color ve Tema Yönetimi
- **TÜM RENKLER DARK VE LIGHT TEMA UYUMLU OLMALI** - Bu zorunludur
- Renkler `Theme.of(context).colorScheme` veya `Theme.of(context).brightness` kullanılarak alınacak
- Sabit renkler (hardcoded colors) kullanılmayacak
- `Colors.white`, `Colors.black` gibi sabit renkler yerine tema renkleri kullanılacak
- Dark mode desteği için `ColorScheme` kullanılacak
- Custom renkler `AppColors` sınıfında tanımlanacak ve tema ile uyumlu olacak

### Static Kullanımı (YASAK)
- **STATIC KULLANILMAYACAK** - Bu kritik bir kuraldır
- Static method'lar, static field'lar, static değişkenler kullanılmayacak
- Sabitler için `const` kullanılacak ve constant sınıflar oluşturulacak
- Utility fonksiyonlar için extension'lar veya helper sınıflar kullanılacak
- Singleton pattern gerekirse factory constructor ile yapılacak, static kullanılmayacak


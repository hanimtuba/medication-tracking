# Kod Standartları

## Genel Prensipler

### 1. Kod Formatı
- **Dart Format**: `dart format` komutu ile formatlanmalı
- **Line Length**: Maksimum 80 karakter (tercihen 100'e kadar esneklik)
- **Indentation**: 2 space (Flutter standart)

### 2. İsimlendirme

#### Dosyalar
```dart
// ✅ DOĞRU
medication_repository.dart
medication_list_page.dart
medication_provider.dart

// ❌ YANLIŞ
MedicationRepository.dart
medication-list-page.dart
```

#### Sınıflar
```dart
// ✅ DOĞRU
class MedicationRepository {}
class MedicationListPage extends StatelessWidget {}
class MedicationProvider extends ChangeNotifier {}

// ❌ YANLIŞ
class medicationRepository {}
class medication_list_page {}
```

#### Değişkenler ve Fonksiyonlar
```dart
// ✅ DOĞRU
final medicationList = <Medication>[];
void getMedications() {}
const apiBaseUrl = 'https://api.example.com';

// ❌ YANLIŞ
final MedicationList = <Medication>[];
void get_medications() {}
```

### 3. Sınıf Yapısı

```dart
// ✅ DOĞRU - Sıralama
class MedicationRepository {
  // 1. Constants
  static const String _baseUrl = 'api/medications';
  
  // 2. Private fields
  final ApiClient _apiClient;
  
  // 3. Constructor
  MedicationRepository(this._apiClient);
  
  // 4. Public methods
  Future<List<Medication>> getMedications() async {
    // Implementation
  }
  
  // 5. Private methods
  void _handleError(Exception e) {
    // Implementation
  }
}
```

### 4. Null Safety

```dart
// ✅ DOĞRU - Null safety kullan
String? nullableString;
String nonNullableString = '';

// Nullable kontrolü
if (nullableString != null) {
  // Use nullableString
}

// Null-aware operators
final length = nullableString?.length ?? 0;
```

### 5. Async/Await

```dart
// ✅ DOĞRU
Future<List<Medication>> getMedications() async {
  try {
    final response = await _apiClient.get(_baseUrl);
    return response.map((json) => Medication.fromJson(json)).toList();
  } catch (e) {
    throw ServerException(e.toString());
  }
}

// ❌ YANLIŞ - then() kullanma
Future<List<Medication>> getMedications() {
  return _apiClient.get(_baseUrl).then((response) {
    return response.map((json) => Medication.fromJson(json)).toList();
  });
}
```

### 6. Error Handling

```dart
// ✅ DOĞRU - Özel exception'lar kullan
try {
  final medications = await repository.getMedications();
} on ServerException catch (e) {
  // Server hatası
} on CacheException catch (e) {
  // Cache hatası
} catch (e) {
  // Genel hata
  throw UnexpectedException(e.toString());
}
```

### 7. Widget Yapısı

```dart
// ✅ DOĞRU - Widget'ları küçük ve odaklı tut
class MedicationCard extends StatelessWidget {
  final Medication medication;
  
  const MedicationCard({
    Key? key,
    required this.medication,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(medication.name),
        subtitle: Text(medication.dosage),
      ),
    );
  }
}
```

### 8. Comments ve Documentation

```dart
// ✅ DOĞRU - Dokümantasyon yorumları
/// Medication repository implementation.
/// 
/// Handles all medication-related data operations including
/// fetching, adding, updating, and deleting medications.
class MedicationRepository {
  /// Fetches all medications from the remote data source.
  /// 
  /// Returns a [Future] that completes with a list of [Medication] entities.
  /// Throws [ServerException] if the request fails.
  Future<List<Medication>> getMedications() async {
    // Implementation
  }
}

// ✅ DOĞRU - Açıklayıcı yorumlar (gerekirse)
// Calculate the next medication time based on frequency
final nextTime = calculateNextTime(medication.frequency);
```

### 9. Imports

```dart
// ✅ DOĞRU - Import sıralaması
// 1. Dart core
import 'dart:async';
import 'dart:convert';

// 2. Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party packages
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// 4. Project imports
import 'package:medication_tracking/core/errors/exceptions.dart';
import 'package:medication_tracking/features/medication/domain/entities/medication.dart';
```

### 10. Constants (Static YASAK)

**ÖNEMLİ**: Static kullanılmayacak! Sabitler için const kullanılacak.

```dart
// ❌ YANLIŞ - Static kullanma
class AppConstants {
  static const String apiBaseUrl = 'https://api.example.com';
  static const int maxRetryAttempts = 3;
}

// ✅ DOĞRU - Const kullan, static yok
// core/constants/app_constants.dart
class AppConstants {
  const AppConstants._(); // Private constructor - instance oluşturulamaz
  
  static const String apiBaseUrl = 'https://api.example.com';
  static const int maxRetryAttempts = 3;
  static const Duration requestTimeout = Duration(seconds: 30);
}

// VEYA daha iyi yaklaşım - const değişkenler
// core/constants/app_constants.dart
const String apiBaseUrl = 'https://api.example.com';
const int maxRetryAttempts = 3;
const Duration requestTimeout = Duration(seconds: 30);

// Kullanım
final url = '$apiBaseUrl/medications';
```

**Kurallar**:
1. **Static method'lar YASAK**
2. **Static field'lar sadece const değerler için kabul edilebilir** (ama tercih edilmez)
3. **Sabitler için const değişkenler kullan**
4. **Utility fonksiyonlar için extension'lar kullan**
5. **Singleton için factory constructor kullan, static instance yok**

### 11. Magic Numbers/Strings

```dart
// ❌ YANLIŞ
if (medication.frequency == 8) { ... }
final timeout = Duration(seconds: 30);

// ✅ DOĞRU
class MedicationFrequency {
  static const int everyEightHours = 8;
  static const int twiceDaily = 2;
}

class NetworkConstants {
  static const Duration requestTimeout = Duration(seconds: 30);
}
```

### 12. Testing

```dart
// ✅ DOĞRU - Test dosyaları
// test/features/medication/domain/usecases/get_medications_test.dart
void main() {
  late GetMedications usecase;
  late MockMedicationRepository mockRepository;
  
  setUp(() {
    mockRepository = MockMedicationRepository();
    usecase = GetMedications(mockRepository);
  });
  
  test('should get medications from repository', () async {
    // Arrange
    final medications = [Medication(id: '1', name: 'Aspirin')];
    when(mockRepository.getMedications()).thenAnswer((_) async => medications);
    
    // Act
    final result = await usecase();
    
    // Assert
    expect(result, medications);
    verify(mockRepository.getMedications()).called(1);
  });
}
```

## Linter Kuralları

`analysis_options.yaml` dosyasında aşağıdaki kurallar aktif olmalıdır:

- `always_declare_return_types`
- `avoid_print`
- `avoid_unnecessary_containers`
- `prefer_const_constructors`
- `prefer_const_literals_to_create_immutables`
- `prefer_final_fields`
- `use_key_in_widget_constructors`

### 13. Build Metod Optimizasyonu

```dart
// ❌ YANLIŞ - Büyük build metodu
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(...),
    body: Column(
      children: [
        // 50+ satır widget kodu burada
      ],
    ),
  );
}

// ✅ DOĞRU - Küçük build metodu, widget'lar ayrılmış
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    body: _buildBody(),
  );
}

PreferredSizeWidget _buildAppBar() {
  return const AppBar(title: Text('Title'));
}

Widget _buildBody() {
  return const BodyWidget();
}
```

### 14. Component Kullanımı (Reusable Widgets)

```dart
// ✅ DOĞRU - Ortak component kullan
// core/widgets/custom_button.dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

// Kullanım - const ile optimize
const CustomButton(
  text: 'Kaydet',
  onPressed: save,
)
```

### 15. Logger Kullanımı

```dart
// ✅ DOĞRU - Logger kullan
import 'package:medication_tracking/core/logger/app_logger.dart';

try {
  final medications = await repository.getMedications();
  AppLogger.info('Medications loaded successfully');
} catch (e, stackTrace) {
  AppLogger.error('Failed to load medications', e, stackTrace);
  throw ServerException(e.toString());
}
```

### 16. Base Page Kullanımı

```dart
// ✅ DOĞRU - BasePage'den miras al
class MedicationListPage extends BasePage<MedicationProvider> {
  const MedicationListPage({Key? key}) : super(key: key);
  
  @override
  BasePageState<MedicationProvider, MedicationListPage> createState() => 
      _MedicationListPageState();
}

class _MedicationListPageState 
    extends BasePageState<MedicationProvider, MedicationListPage> {
  @override
  MedicationProvider get provider => getIt<MedicationProvider>();
  
  @override
  Widget buildBody(BuildContext context) {
    return Consumer<MedicationProvider>(
      builder: (context, provider, child) {
        return MedicationListView(medications: provider.medications);
      },
    );
  }
}
```

### 17. Responsive Tasarım (KRİTİK - ZORUNLU)

**ÖNEMLİ**: TÜM TASARIMLAR RESPONSIVE OLACAK! Bu bir zorunluluktur.

```dart
// ❌ YANLIŞ - Sabit değerler kullanma
Container(
  width: 100,
  height: 50,
  padding: EdgeInsets.all(16),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16),
  ),
)

// ✅ DOĞRU - Responsive değerler kullan
import 'package:flutter_screenutil/flutter_screenutil.dart';

Container(
  width: 100.w,        // Responsive width
  height: 50.h,         // Responsive height
  padding: EdgeInsets.all(16.r),  // Responsive padding (radius için de r kullanılır)
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16.sp),  // Responsive font size
  ),
)

// ✅ DOĞRU - Responsive spacing
SizedBox(width: 20.w, height: 20.h)
EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)
BorderRadius.circular(12.r)
```

**Kurallar**:
1. **TÜM BOYUTLAR RESPONSIVE OLMALI**: width, height, padding, margin, font size
2. **Font Size**: Mutlaka `.sp` kullanılmalı (örn: `16.sp`)
3. **Width**: `.w` kullanılmalı (örn: `100.w`)
4. **Height**: `.h` kullanılmalı (örn: `50.h`)
5. **Radius/Padding**: `.r` kullanılmalı (örn: `16.r`)
6. **Sabit değerler ASLA kullanılmamalı** (hardcoded numbers)
7. **Her widget responsive olmalı**
8. **Farklı ekran boyutları test edilmeli** (phone, tablet)

**Örnek Responsive Widget**:
```dart
class ResponsiveCard extends StatelessWidget {
  final String title;
  final String subtitle;
  
  const ResponsiveCard({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: colorScheme.surface, // Tema rengi kullan
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface, // Tema rengi kullan
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: colorScheme.onSurface.withOpacity(0.7), // Tema rengi kullan
            ),
          ),
        ],
      ),
    );
  }
}
```

### 18. Color ve Tema Kullanımı (KRİTİK - ZORUNLU)

**ÖNEMLİ**: TÜM RENKLER DARK VE LIGHT TEMA UYUMLU OLMALI!

```dart
// ❌ YANLIŞ - Sabit renkler kullanma
Container(
  color: Colors.white,
  child: Text(
    'Hello',
    style: TextStyle(color: Colors.black),
  ),
)

// ❌ YANLIŞ - Hardcoded color
Container(
  color: Color(0xFFF5F5F5),
  child: Text('Hello'),
)

// ✅ DOĞRU - Tema renkleri kullan
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  
  return Container(
    color: colorScheme.surface, // Light'ta beyaz, dark'ta koyu
    child: Text(
      'Hello',
      style: TextStyle(
        color: colorScheme.onSurface, // Light'ta siyah, dark'ta beyaz
      ),
    ),
  );
}

// ✅ DOĞRU - Brightness kontrolü
Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final backgroundColor = isDark ? Colors.grey[900]! : Colors.white;
  
  return Container(color: backgroundColor);
}

// ✅ DOĞRU - Custom renkler için AppColors
// core/theme/app_colors.dart
class AppColors {
  const AppColors._();
  
  // Light theme colors
  static const Color primaryLight = Color(0xFF2196F3);
  static const Color secondaryLight = Color(0xFF03DAC6);
  
  // Dark theme colors
  static const Color primaryDark = Color(0xFF90CAF9);
  static const Color secondaryDark = Color(0xFF03DAC6);
  
  // Tema'ya göre renk döndür
  static Color primary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? primaryDark : primaryLight;
  }
}

// Kullanım
Container(
  color: AppColors.primary(context), // Tema'ya göre otomatik renk
)
```

**Kurallar**:
1. **Sabit renkler ASLA kullanılmamalı** (`Colors.white`, `Colors.black`, `Color(0xFF...)`)
2. **Tema renkleri kullanılmalı** (`colorScheme.surface`, `colorScheme.onSurface`, vb.)
3. **Dark mode desteği zorunludur**
4. **Custom renkler AppColors sınıfında tanımlanmalı**
5. **Her renk dark ve light tema için test edilmeli**

### 19. Dependency Injection (KRİTİK - ZORUNLU)

**ÖNEMLİ**: TÜM BAĞIMLILIKLAR DI İLE YÖNETİLMELİ!

```dart
// ❌ YANLIŞ - Direkt instance oluşturma
class MedicationProvider extends ChangeNotifier {
  final repository = MedicationRepositoryImpl(); // YANLIŞ!
  
  MedicationProvider() {
    // YANLIŞ!
  }
}

// ❌ YANLIŞ - Static kullanma
class MedicationProvider extends ChangeNotifier {
  final repository = MedicationRepository.instance; // YANLIŞ!
}

// ✅ DOĞRU - DI ile inject et
class MedicationProvider extends ChangeNotifier {
  final MedicationRepository repository;
  final GetMedications getMedications;
  
  MedicationProvider({
    required this.repository,
    required this.getMedications,
  });
}

// injection_container.dart
final getIt = GetIt.instance;

Future<void> init() async {
  // Repositories
  getIt.registerLazySingleton<MedicationRepository>(
    () => MedicationRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  
  // Use Cases
  getIt.registerLazySingleton(
    () => GetMedications(getIt()),
  );
  
  // Providers
  getIt.registerFactory(
    () => MedicationProvider(
      repository: getIt(),
      getMedications: getIt(),
    ),
  );
}

// Kullanım
final provider = getIt<MedicationProvider>();
```

**Kurallar**:
1. **Hiçbir yerde `new` keyword'ü kullanılmayacak**
2. **Tüm bağımlılıklar constructor'dan inject edilecek**
3. **Static instance'lar kullanılmayacak**
4. **get_it container'ı kullanılacak**
5. **Test edilebilirlik için DI zorunludur**

## Code Review Checklist

- [ ] Kod formatlanmış mı?
- [ ] İsimlendirme kurallarına uygun mu?
- [ ] Null safety doğru kullanılmış mı?
- [ ] Error handling yapılmış mı?
- [ ] Magic numbers/strings kullanılmamış mı?
- [ ] Gereksiz yorumlar temizlenmiş mi?
- [ ] Test yazılmış mı?
- [ ] SOLID prensiplerine uygun mu?
- [ ] Build metodu küçük ve optimize edilmiş mi?
- [ ] Component'ler kullanılmış mı? (tekrar eden widget'lar)
- [ ] Logger kullanılmış mı? (hata durumlarında)
- [ ] BasePage'den miras alınmış mı? (tüm page'ler için)
- [ ] const constructor'lar kullanılmış mı?
- [ ] Consumer widget'ında child parametresi kullanılmış mı? (rebuild optimizasyonu)
- [ ] **TÜM TASARIMLAR RESPONSIVE MI?** (KRİTİK - ZORUNLU)
- [ ] Font size'lar `.sp` ile mi yazılmış?
- [ ] Width/Height değerleri `.w` ve `.h` ile mi yazılmış?
- [ ] Padding/Margin/Radius değerleri `.r` ile mi yazılmış?
- [ ] Sabit değerler (hardcoded numbers) kullanılmamış mı?
- [ ] **TÜM RENKLER TEMA UYUMLU MU?** (KRİTİK - ZORUNLU)
- [ ] Sabit renkler (`Colors.white`, `Colors.black`) kullanılmamış mı?
- [ ] Tema renkleri (`colorScheme.surface`, `colorScheme.onSurface`) kullanılmış mı?
- [ ] Dark mode desteği var mı?
- [ ] **STATIC KULLANILMAMIŞ MI?** (KRİTİK - ZORUNLU)
- [ ] Static method'lar kullanılmamış mı?
- [ ] Static field'lar sadece const değerler için mi?
- [ ] Sabitler const değişkenler olarak mı tanımlanmış?
- [ ] **DI KULLANILMIŞ MI?** (KRİTİK - ZORUNLU)
- [ ] Tüm bağımlılıklar DI ile inject edilmiş mi?
- [ ] `new` keyword'ü kullanılmamış mı?
- [ ] Static instance'lar kullanılmamış mı?


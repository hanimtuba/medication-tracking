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

### 10. Constants

```dart
// ✅ DOĞRU - Constants için ayrı dosya
// core/constants/app_constants.dart
class AppConstants {
  static const String apiBaseUrl = 'https://api.example.com';
  static const int maxRetryAttempts = 3;
  static const Duration requestTimeout = Duration(seconds: 30);
}

// Kullanım
final url = '${AppConstants.apiBaseUrl}/medications';
```

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


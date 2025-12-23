# Design Patterns ve Best Practices

## Kullanılacak Design Pattern'ler

### 1. Repository Pattern

**Amaç**: Veri kaynaklarından (local/remote) veri erişimini soyutlamak

**Kullanım**:
```dart
// Domain Layer - Interface
abstract class MedicationRepository {
  Future<Either<Failure, List<Medication>>> getMedications();
  Future<Either<Failure, Medication>> addMedication(Medication medication);
}

// Data Layer - Implementation
class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationRemoteDataSource remoteDataSource;
  final MedicationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  @override
  Future<Either<Failure, List<Medication>>> getMedications() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMedications = await remoteDataSource.getMedications();
        await localDataSource.cacheMedications(remoteMedications);
        return Right(remoteMedications);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localMedications = await localDataSource.getMedications();
        return Right(localMedications);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
```

### 2. Use Case Pattern

**Amaç**: Her iş mantığı senaryosunu tek bir sınıfta toplamak

**Kullanım**:
```dart
class GetMedications {
  final MedicationRepository repository;
  
  GetMedications(this.repository);
  
  Future<Either<Failure, List<Medication>>> call() async {
    return await repository.getMedications();
  }
}

// Kullanım
final getMedications = GetMedications(repository);
final result = await getMedications();
```

### 3. Dependency Injection Pattern

**Amaç**: Bağımlılıkları dışarıdan enjekte etmek (get_it veya Riverpod)

**Kullanım (get_it)**:
```dart
// injection_container.dart
final getIt = GetIt.instance;

Future<void> init() async {
  // Features
  getIt.registerLazySingleton(() => MedicationRepositoryImpl(
    remoteDataSource: getIt(),
    localDataSource: getIt(),
    networkInfo: getIt(),
  ));
  
  // Data sources
  getIt.registerLazySingleton<MedicationRemoteDataSource>(
    () => MedicationRemoteDataSourceImpl(client: getIt()),
  );
  
  // Use cases
  getIt.registerLazySingleton(() => GetMedications(getIt()));
}
```

### 4. Provider Pattern (State Management)

**Amaç**: State yönetimi için Provider kullanımı

**Kullanım**:
```dart
class MedicationProvider extends ChangeNotifier {
  final GetMedications getMedications;
  
  List<Medication> _medications = [];
  bool _isLoading = false;
  String? _error;
  
  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> loadMedications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final result = await getMedications();
    
    result.fold(
      (failure) => _error = failure.message,
      (medications) => _medications = medications,
    );
    
    _isLoading = false;
    notifyListeners();
  }
}
```

### 5. Factory Pattern

**Amaç**: Model'den Entity'ye dönüşüm için

**Kullanım**:
```dart
// Model
class MedicationModel extends Medication {
  MedicationModel({
    required super.id,
    required super.name,
    required super.dosage,
  });
  
  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
    };
  }
}
```

### 6. Singleton Pattern

**Amaç**: Tek bir instance gereken servisler için (NetworkInfo, Database, vb.)

**Kullanım**:
```dart
class NetworkInfo {
  static final NetworkInfo _instance = NetworkInfo._internal();
  factory NetworkInfo() => _instance;
  NetworkInfo._internal();
  
  Future<bool> get isConnected async {
    // Implementation
  }
}
```

### 7. Observer Pattern (Provider ile)

**Amaç**: State değişikliklerini dinlemek

**Kullanım**:
```dart
// Widget'ta kullanım - Optimize edilmiş
Consumer<MedicationProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) {
      return const LoadingWidget(); // const kullan
    }
    if (provider.error != null) {
      return ErrorWidget(error: provider.error!);
    }
    return MedicationList(medications: provider.medications);
  },
  child: const SomeStaticWidget(), // Rebuild edilmeyecek widget
)
```

### 8. Base Page Pattern

**Amaç**: Tüm page'lerde ortak işlevleri toplamak ve kod tekrarını önlemek

**Kullanım**:
```dart
// core/pages/base_page.dart
abstract class BasePage<T extends ChangeNotifier> extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);
}

abstract class BasePageState<T extends ChangeNotifier, P extends BasePage<T>> 
    extends State<P> {
  T get provider;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onPageReady();
    });
  }
  
  void onPageReady() {}
  
  Widget buildBody(BuildContext context);
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: provider,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: buildBody(context),
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );
  }
  
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  Widget? buildFloatingActionButton(BuildContext context) => null;
}

// Kullanım
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
  void onPageReady() {
    provider.loadMedications();
  }
  
  @override
  Widget buildBody(BuildContext context) {
    return Consumer<MedicationProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const LoadingWidget();
        }
        return MedicationListView(medications: provider.medications);
      },
    );
  }
}
```

### 9. Component Pattern (Reusable Widgets)

**Amaç**: Benzer tasarımlar için ortak component'ler oluşturmak

**Kullanım**:
```dart
// core/widgets/custom_button.dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonStyle? style;
  
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.style,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(text),
    );
  }
}

// Kullanım - const ile optimize
const CustomButton(
  text: 'Kaydet',
  onPressed: saveMedication,
)
```

### 10. Logger Pattern

**Amaç**: Hata ve bilgi loglaması için merkezi logger kullanımı

**Kullanım**:
```dart
// core/logger/app_logger.dart
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );
  
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }
  
  static void info(String message) {
    _logger.i(message);
  }
  
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }
  
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}

// Kullanım
try {
  final medications = await repository.getMedications();
} catch (e, stackTrace) {
  AppLogger.error('Failed to load medications', e, stackTrace);
  throw ServerException(e.toString());
}
```

## Error Handling Pattern

### Either Pattern (Functional Programming)

**Amaç**: Hata yönetimi için Either<Failure, Success> kullanımı

**Kullanım**:
```dart
// core/errors/failures.dart
abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure() : super('Server error occurred');
}

class CacheFailure extends Failure {
  CacheFailure() : super('Cache error occurred');
}

// dartz paketi ile Either kullanımı
import 'package:dartz/dartz.dart';

Future<Either<Failure, List<Medication>>> getMedications() async {
  try {
    final medications = await repository.getMedications();
    return Right(medications);
  } on ServerException {
    return Left(ServerFailure());
  }
}
```

## Best Practices

### 1. Separation of Concerns
- Her sınıf tek bir sorumluluğa sahip olmalı
- UI mantığı, iş mantığı ve veri erişimi ayrı tutulmalı

### 2. Single Responsibility Principle
```dart
// ❌ YANLIŞ
class MedicationManager {
  void fetchMedications() {}
  void displayMedications() {}
  void saveToDatabase() {}
}

// ✅ DOĞRU
class MedicationRepository {
  Future<List<Medication>> getMedications() {}
}

class MedicationProvider {
  void loadMedications() {}
}

class MedicationListWidget {
  Widget build(BuildContext context) {}
}
```

### 3. Open/Closed Principle
- Sınıflar genişlemeye açık, değişikliğe kapalı olmalı
- Interface'lere bağımlılık, implementasyonlara değil

### 4. Dependency Inversion Principle
```dart
// ✅ DOĞRU - Abstraction'a bağımlılık
class GetMedications {
  final MedicationRepository repository; // Interface
  GetMedications(this.repository);
}

// ❌ YANLIŞ - Concrete implementation'a bağımlılık
class GetMedications {
  final MedicationRepositoryImpl repository; // Implementation
  GetMedications(this.repository);
}
```

### 5. DRY (Don't Repeat Yourself)
- Ortak kodlar utility sınıflarına veya base sınıflara taşınmalı
- Benzer widget'lar component olarak ayrılmalı

### 6. Composition over Inheritance
- Inheritance yerine composition tercih edilmeli
- Base Page için inheritance kullanılacak (özel durum)

### 11. Build Metod Optimizasyonu

**Amaç**: Rebuild'leri minimize etmek ve performansı artırmak

**Kurallar**:
1. Build metodları mümkün olduğunca küçük tutulmalı
2. Büyük widget ağaçları küçük widget'lara bölünmeli
3. `const` constructor'lar her yerde kullanılmalı
4. `Consumer` widget'ı ile sadece gerekli kısımlar dinlenmeli
5. `child` parametresi ile static widget'lar rebuild'den korunmalı

**Örnek**:
```dart
// ❌ YANLIŞ - Büyük build metodu
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Medications')),
    body: Column(
      children: [
        // 100+ satır widget kodu
        Consumer<MedicationProvider>(
          builder: (context, provider, _) {
            return ListView.builder(
              itemCount: provider.medications.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      // Daha fazla widget...
                    ],
                  ),
                );
              },
            );
          },
        ),
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
  return const AppBar(title: Text('Medications'));
}

Widget _buildBody() {
  return Consumer<MedicationProvider>(
    builder: (context, provider, child) {
      if (provider.isLoading) {
        return const LoadingWidget();
      }
      return MedicationListView(medications: provider.medications);
    },
    child: const SomeStaticWidget(), // Rebuild edilmeyecek
  );
}

// Ayrı widget dosyası
class MedicationListView extends StatelessWidget {
  final List<Medication> medications;
  
  const MedicationListView({
    Key? key,
    required this.medications,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: medications.length,
      itemBuilder: (context, index) {
        return MedicationCard(medication: medications[index]);
      },
    );
  }
}
```

## Feature Modül Yapısı

Her feature şu yapıyı takip etmeli:

1. **Domain**: Pure Dart, bağımlılık yok
2. **Data**: Domain'e bağımlı, implementasyonlar
3. **Presentation**: Domain'e bağımlı, UI ve state management

Bu yapı sayesinde:
- Test edilebilirlik artar
- Bakım kolaylaşır
- Özellikler bağımsız geliştirilebilir
- Kod tekrarı azalır


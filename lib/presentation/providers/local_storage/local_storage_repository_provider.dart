import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniweather/domain/datasources/local_storage_datasource.dart';
import 'package:miniweather/domain/repositories/local_storage_repository.dart';
import 'package:miniweather/infrastructure/repositories/local_storage_repository_impl.dart';

import '../../../infrastructure/datasources/local_storage/sharedpreferences_datasource_impl.dart';
import 'local_storage_provider.dart';

final localStorageDatasourceProvider = Provider<LocalStorageDatasource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedpreferencesDatasourceImpl(prefs: prefs);
});

final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  final dataSource = ref.watch(localStorageDatasourceProvider);
  return LocalStorageRepositoryImpl(datasource: dataSource);
});

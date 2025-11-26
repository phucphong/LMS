// lib/src/features/auth/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';



import '../../../core/network/api_client.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'usecases/login_usecase.dart';
import 'usecases/register_trial_usecase.dart';

/// ApiClient chung cho auth
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// Remote Data Source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.read(apiClientProvider);
  return AuthRemoteDataSourceImpl(client);
});

/// AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.read(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remote);
});

/// UseCase: Login
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginUseCase(repo);
});

/// UseCase: Register Trial
final registerTrialUseCaseProvider = Provider<RegisterTrialUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return RegisterTrialUseCase(repo);
});

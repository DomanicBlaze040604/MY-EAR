import '../../presentation/bloc/sign_language_bloc.dart';
import '../../domain/repositories/sign_language_repository.dart';
import 'sign_language_repository_factory.dart';

class SignLanguageBlocFactory {
  static Future<SignLanguageBloc> create() async {
    final repository = await SignLanguageRepositoryFactory.create();
    return SignLanguageBloc(repository);
  }

  static Future<SignLanguageBloc> createWithRepository(
    SignLanguageRepository repository,
  ) async {
    return SignLanguageBloc(repository);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/sign_language/data/factories/sign_language_repository_factory.dart';
import 'features/sign_language/presentation/bloc/sign_language_bloc.dart';
import 'features/emergency/presentation/bloc/emergency_bloc.dart';
import 'features/emergency/data/repositories/emergency_repository_impl.dart';
import 'core/routes/app_router.dart';
import 'core/constants/theme_constants.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize repositories
  final signLanguageRepository = await SignLanguageRepositoryFactory.create();
  final emergencyRepository = EmergencyRepositoryImpl(prefs);

  runApp(
    MyApp(
      signLanguageRepository: signLanguageRepository,
      emergencyRepository: emergencyRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final signLanguageRepository;
  final emergencyRepository;

  const MyApp({
    Key? key,
    required this.signLanguageRepository,
    required this.emergencyRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignLanguageBloc(signLanguageRepository),
        ),
        BlocProvider(create: (context) => EmergencyBloc(emergencyRepository)),
      ],
      child: MaterialApp(
        title: 'My Ear',
        theme: ThemeConstants.lightTheme,
        darkTheme: ThemeConstants.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
        onGenerateRoute: AppRouter.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

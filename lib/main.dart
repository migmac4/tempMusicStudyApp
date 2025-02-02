import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';

import 'config/env.dart';
import 'config/supabase_config.dart';
import 'services/auth_service.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
    debug: true,
  );

  debugPrint('Supabase URL: ${Env.supabaseUrl}');
  debugPrint('Supabase initialized successfully');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Study App',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<AuthState>(
        stream: SupabaseConfig.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          // Adicionar logs para debug
          debugPrint('Auth state changed: ${snapshot.data?.event}');
          debugPrint('Has session: ${snapshot.data?.session != null}');
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint('Auth stream error: ${snapshot.error}');
            return const LoginScreen();
          }

          if (snapshot.hasData) {
            final session = snapshot.data?.session;
            if (session != null) {
              debugPrint('Valid session found, showing HomeScreen');
              return const HomeScreen();
            }
          }

          debugPrint('No valid session, showing LoginScreen');
          return const LoginScreen();
        },
      ),
    );
  }
}

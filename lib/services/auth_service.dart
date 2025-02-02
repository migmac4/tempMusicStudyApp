import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, Platform;
import 'package:url_launcher/url_launcher.dart';

import '../config/env.dart';
import '../config/supabase_config.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService {
  final Ref ref;
  final SupabaseClient supabase = SupabaseConfig.client;
  
  // Separate instances for web and iOS
  final GoogleSignIn? _googleSignIn = !kIsWeb 
      ? GoogleSignIn(
          clientId: Platform.isIOS 
              ? '852747139690-lrgjskva0mlmrfh08jka0au23a9kpt3m.apps.googleusercontent.com'
              : Platform.isAndroid
                  ? '852747139690-80fatblnm4h3lcf419iibvsrgs6eud2c.apps.googleusercontent.com'
                  : null,
          serverClientId: Platform.isIOS
              ? '852747139690-lkqp6kh53837q8a4sir4n5e6hss58c23.apps.googleusercontent.com'
              : Platform.isAndroid
                  ? '852747139690-80fatblnm4h3lcf419iibvsrgs6eud2c.apps.googleusercontent.com'
                  : null,
          scopes: ['email', 'profile'],
        )
      : null;

  AuthService(this.ref);

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw _mapAuthError(e.message);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final currentUrl = Uri.base;
        final redirectUrl = '${currentUrl.origin}/#/auth-callback';
        debugPrint('🌐 Redirect URL: $redirectUrl');
        
        await supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: redirectUrl,
        );
      } else if (Platform.isIOS) {
        final GoogleSignInAccount? googleUser = await _googleSignIn?.signIn();
        if (googleUser == null) return;
        
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: googleAuth.idToken!,
          accessToken: googleAuth.accessToken,
        );
      } else if (Platform.isAndroid) {
        debugPrint('🤖 Iniciando login no Android...');
        final GoogleSignInAccount? googleUser = await _googleSignIn?.signIn();
        if (googleUser == null) {
          debugPrint('❌ Usuário cancelou o login');
          return;
        }
        
        debugPrint('✅ Usuário selecionado: ${googleUser.email}');
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        debugPrint('🔑 Token obtido, chamando Supabase...');
        
        final response = await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: googleAuth.idToken!,
          accessToken: googleAuth.accessToken,
        );
        
        debugPrint('🎉 Login concluído: ${response.user?.email}');
      }
    } catch (error) {
      debugPrint('❌ Erro no login: $error');
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw _mapAuthError(e.message);
    }
  }

  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await _googleSignIn?.signOut();
      }
      await supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw _mapAuthError(e.message);
    }
  }

  String _mapAuthError(String message) {
    if (message.contains('Email not confirmed')) {
      return 'Por favor, confirme seu e-mail antes de fazer login';
    }
    if (message.contains('Invalid login credentials')) {
      return 'E-mail ou senha inválidos';
    }
    if (message.contains('Email already registered')) {
      return 'Este e-mail já está registrado';
    }
    if (message.contains('Password should be at least 6 characters')) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    if (message.contains('Invalid email')) {
      return 'E-mail inválido';
    }
    return message;
  }
}

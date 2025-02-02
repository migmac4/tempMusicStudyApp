import 'package:flutter/foundation.dart' show kIsWeb;

class Env {
  static String get supabaseUrl => kIsWeb
      ? const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://ewvvyjwiwwpvjztxunnt.supabase.co')
      : const String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://ewvvyjwiwwpvjztxunnt.supabase.co');

  static String get supabaseAnonKey => kIsWeb
      ? const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3dnZ5andpd3dwdmp6dHh1bm50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgzMzc4NDUsImV4cCI6MjA1MzkxMzg0NX0.U3RwLs1HfkCn-A5xxuTYg_UeZesrK873radB4O2_V-Q')
      : const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3dnZ5andpd3dwdmp6dHh1bm50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgzMzc4NDUsImV4cCI6MjA1MzkxMzg0NX0.U3RwLs1HfkCn-A5xxuTYg_UeZesrK873radB4O2_V-Q');

  static String get googleWebClientId => '852747139690-lkqp6kh53837q8a4sir4n5e6hss58c23.apps.googleusercontent.com';
  static String get googleIosClientId => '852747139690-lrgjskva0mlmrfh08jka0au23a9kpt3m.apps.googleusercontent.com';
}

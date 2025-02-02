import 'package:supabase_flutter/supabase_flutter.dart';
import 'env.dart';

class SupabaseConfig {
  static final String url = Env.supabaseUrl;
  static final String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3dnZ5andpd3dwdmp6dHh1bm50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgzMzc4NDUsImV4cCI6MjA1MzkxMzg0NX0.U3RwLs1HfkCn-A5xxuTYg_UeZesrK873radB4O2_V-Q';
  static final String serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3dnZ5andpd3dwdmp6dHh1bm50Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczODMzNzg0NSwiZXhwIjoyMDUzOTEzODQ1fQ.i1CJwGfiUXh8q3rnXw9SWNLarvdDNrA_Gv5LdSIPsD0';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: true,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}

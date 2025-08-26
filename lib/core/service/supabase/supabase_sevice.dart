import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseKeys {
  static const supabaseKey = 'SUPABASE_KEY';
  static const supabaseUrL = 'SUPABASE_URL';
}

class SupabaseService {
  static supaInit() async {
    await Supabase.initialize(
      url: dotenv.env[SupabaseKeys.supabaseUrL]!,
      anonKey: dotenv.env[SupabaseKeys.supabaseKey]!,
    );
  }
}

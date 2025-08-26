import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groceryapp/app.dart';
import 'package:groceryapp/core/service/supabase/supabase_sevice.dart';
import 'package:groceryapp/core/utils/dependancy_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SupabaseService.supaInit();
  setupLocator();
  runApp(const GroceryApp());
}

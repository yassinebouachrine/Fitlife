// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'app.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]);
//   runApp(const LifevoraApp());
// }



import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Charger le fichier .env
  await dotenv.load(fileName: ".env");

  runApp(
    const ProviderScope(
      child: LifevoraApp(),
    ),
  );
}
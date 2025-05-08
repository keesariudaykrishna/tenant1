import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import 'res/routes/routes.dart';
import 'views/splash/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Enable persistence for Firebase Realtime Database
  FirebaseDatabase.instance.setPersistenceEnabled(true);
// Get the application documents directory
  var appDocumentDir = await getApplicationDocumentsDirectory();

  // Initialize Hive with the directory path
  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(MapAdapter()); // Register any required adapters
  await Hive.openBox<Map<dynamic, dynamic>>('apartments');

  await Hive.openBox('apartmentCache');
  await Hive.openBox('localChats');

  await Hive.initFlutter(
      appDocumentDir.path); // This provides the path for storing Hive data

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(490, 800),
      minTextAdapt: true,
      builder: (context, child) {
        // Hive.box('apartmentCache').clear().then(
        //       (value) => debugPrint('delete hive'),
        //     );
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Apartment Rentals',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          getPages: AppRoutes.appRoutes(),
          home: SplashScreen(),
        );
      },
    );
  }
}

class MapAdapter extends TypeAdapter<Map<String, dynamic>> {
  @override
  final int typeId = 1;

  @override
  Map<String, dynamic> read(BinaryReader reader) {
    return Map<String, dynamic>.from(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, Map<String, dynamic> obj) {
    writer.writeMap(obj);
  }
}

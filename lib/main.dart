import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pengaduan_masyarakat/common/constant.dart';
import 'package:pengaduan_masyarakat/pages/complaint_page.dart';
import 'package:pengaduan_masyarakat/pages/sign_in_page.dart';
import 'package:pengaduan_masyarakat/providers/auth_provider.dart';
import 'package:pengaduan_masyarakat/providers/complaint_provider.dart';
import 'package:pengaduan_masyarakat/providers/user_provider.dart';
import 'package:provider/provider.dart';

AndroidOptions _getAndroidOptions() {
  return const AndroidOptions(
    encryptedSharedPreferences: true,
  );
}

final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
String token = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  token = await storage.read(
        key: "token",
        aOptions: _getAndroidOptions(),
      ) ??
      "";

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ComplaintProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pengaduan Masyarakat',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
            ),
            useMaterial3: true,
          ),
          home: token != "" ? const ComplaintPage() : const SignInPage(),
        );
      }),
    );
  }
}

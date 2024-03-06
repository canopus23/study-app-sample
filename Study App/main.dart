
import 'package:flutter/material.dart';
import 'package:app_version_update/app_version_update.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.transparent,
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _selectedIndex = 0;
  DateTime? _lastPressed;

  @override
  void initState() {
    super.initState();
    checkForAppUpdates();
  }

  // Function to check for app updates
  void checkForAppUpdates() async {
    final appleId = 'idXXXXXXXX'; // Replace with your IOS App ID
    final playStoreId = 'com.sampleapp'; // Replace with your package name
    final country = 'in'; // Replace with your desired country code

    try {
      final data = await AppVersionUpdate.checkForUpdates(
        appleId: appleId,
        playStoreId: playStoreId,
        country: country,
      );
      if (data.canUpdate!) {
        AppVersionUpdate.showAlertUpdate(
          appVersionResult: data,
          context: context,
        );
      }
    } catch (e) {
      print('Error checking for updates: $e');
    }
  }

  static const List<Widget> _widgetOptions = <Widget>[
    FeaturedScreen(),
    FeaturedScreen(),
    FeaturedScreen(),
    FeaturedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          final now = DateTime.now();
          if (_lastPressed == null || now.difference(_lastPressed!) > Duration(seconds: 2)) {
            _lastPressed = now;
            final snackBar = SnackBar(
              content: Text(
                'Press back again to exit App',
                style: TextStyle(fontSize: 16),
              ),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return false;
          }
          return true;
        },
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}

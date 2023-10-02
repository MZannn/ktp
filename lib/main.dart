import 'package:flutter/material.dart';
import 'package:ktp/env/class/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart KTP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: Env.routes,
      initialRoute: Env.initialRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

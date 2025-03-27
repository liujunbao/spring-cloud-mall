import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_app/screens/register_screen.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/pages/product_list_page.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: '微商城',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/products': (context) => const ProductListPage(),
          '/main': (context) => const MainPage(),
        },
      ),
    );
  }
}

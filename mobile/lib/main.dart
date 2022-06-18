import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mobile/providers/Category.dart';
import 'package:mobile/providers/Products.dart';
import 'package:mobile/providers/Carts.dart';
import 'screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'providers/Auth.dart';
import 'screens/AuthScreen.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

Future initialization(BuildContext? context) async {
  // Load splash
  await Future.delayed(Duration(seconds: 2));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Category(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(''),
          update: (context, data, previousMessages) => Products(data.authToken),
        ),
        ChangeNotifierProxyProvider<Products, Carts>(
          create: (ctx) => Carts(''),
          update: (context, data, previousMessages) => Carts(data.authToken),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'mobile',
          theme: ThemeData(
            // is not restarted.
            primarySwatch: Colors.blue,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: authData.isAuth
              ? HomeScreen(
                  token: authData.authToken,
                )
              : AuthScreen(),
          routes: {},
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mobile/providers/Category.dart';
import 'package:mobile/providers/Products.dart';
import 'package:mobile/providers/Carts.dart';
import 'package:mobile/screens/CartScreen.dart';
import 'package:mobile/screens/Category/CategoryScreen.dart';
import 'package:mobile/screens/MasterScreen.dart';
import 'package:mobile/screens/Product/ProductScreen.dart';
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
    final primaryColor = Color.fromRGBO(0, 54, 56, 1);
    final secondColor = Color.fromRGBO(5, 80, 82, 1);
    final thirdColor = Color.fromRGBO(83, 184, 187, 1);
    final fourthColor = Color.fromRGBO(243, 242, 201, 1);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Category>(
          create: (ctx) => Category(''),
          update: (context, data, previousData) => Category(data.authToken),
        ),
        ChangeNotifierProxyProvider<Category, Products>(
          create: (ctx) => Products('', null),
          update: (context, data, previousData) =>
              Products(data.authToken, data),
        ),
        ChangeNotifierProxyProvider<Products, Carts>(
          create: (ctx) => Carts('', []),
          update: (context, data, previousData) => Carts(
            data.authToken,
            previousData == null ? [] : previousData.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'mobile',
          theme: ThemeData(
            // is not restarted.
            primaryColor: primaryColor,
            accentColor: secondColor,
            hintColor: thirdColor,
            backgroundColor: fourthColor,

            fontFamily: 'Lato',
          ),
          home: authData.isAuth
              ? HomeScreen(
                  token: authData.authToken,
                )
              : AuthScreen(),
          routes: {
            CartScreen.routeName: (ctx) => const CartScreen(),
            MasterScreen.routeName: (ctx) => const MasterScreen(),
            CategoryScreen.routeName: (ctx) => const CategoryScreen(),
            ProductScreen.routeName: (ctx) => const ProductScreen(),
          },
        ),
      ),
    );
  }
}

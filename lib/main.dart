import 'package:flutter/material.dart';
import 'package:nike/data/favorite_manager.dart';

import 'package:nike/data/product.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/banner_repository.dart';
import 'package:nike/data/repo/product_repository.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/root.dart';

void main() async {
  FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bannerRepository.getAll().then((value) {
      debugPrint(value.toString());
    }).catchError((e) {
      debugPrint(e.toString());
    });
    productRepository.getAll(ProductSort.latest).then((value) {
      debugPrint(value.toString());
    }).catchError((e) {
      debugPrint(e.toString());
    });
    const defaultTextStyle = TextStyle(
        fontFamily: 'IranSans', color: LightThemeColors.primaryTextColor);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          hintColor: LightThemeColors.secondaryTextColor,
          elevatedButtonTheme: const ElevatedButtonThemeData(
              style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  backgroundColor:
                      WidgetStatePropertyAll(LightThemeColors.primaryColor))),
          inputDecorationTheme: InputDecorationTheme(
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          LightThemeColors.primaryTextColor.withOpacity(0.1)))),
          snackBarTheme: SnackBarThemeData(
              backgroundColor: Theme.of(context).colorScheme.primary,
              contentTextStyle: defaultTextStyle.apply(
                  color: Theme.of(context).colorScheme.onSecondary)),
          textTheme: TextTheme(
              labelSmall: defaultTextStyle,
              titleSmall: defaultTextStyle.apply(
                color: LightThemeColors.secondaryTextColor,
              ),
              titleMedium:
                  defaultTextStyle.copyWith(fontSize: 16, color: Colors.white),
              titleLarge: defaultTextStyle.copyWith(fontSize: 16),
              bodyMedium: defaultTextStyle,
              headlineSmall: defaultTextStyle.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 18),
              bodySmall: defaultTextStyle.copyWith(
                  color: LightThemeColors.secondaryTextColor, fontSize: 14)),
          colorScheme: const ColorScheme.light(
              primary: LightThemeColors.primaryColor,
              secondary: LightThemeColors.secondaryColor,
              onSecondary: Colors.white,
              surfaceContainerHighest: Color(0xffF5F5F5)),
          useMaterial3: true),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}

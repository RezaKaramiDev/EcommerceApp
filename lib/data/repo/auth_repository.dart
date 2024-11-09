import 'package:flutter/material.dart';
import 'package:nike/common/http_client.dart';
import 'package:nike/data/auth_info.dart';
import 'package:nike/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(httpClient));

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> signUp(String username, String password);
  Future<void> refreshToken();
  Future<void> sighOut();
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;
  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier(null);

  AuthRepository(this.dataSource);

  static bool isUserLoggedIn() {
    return authChangeNotifier.value != null &&
        // ignore: unnecessary_null_comparison
        authChangeNotifier.value!.accessToken != null &&
        authChangeNotifier.value!.accessToken.isNotEmpty;
  }

  // This part is the Main Function  | |
  //                                 V V

  // @override
  // Future<void> login(String username, String password) =>
  //     dataSource.login(username, password);

  // This part is for Test the App  | |
  //                                V V

  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);
    _persistAuthToken(authInfo);
    debugPrint("The Refresh Token is : ${authInfo.refreshToken}");
  }

  // This part is the Main Function  | |
  //                                 V V

  // @override
  // Future<void> signUp(String username, String password) =>
  //     dataSource.signUp(username, password);

  // This part is for Test the App  | |
  //                                V V

  @override
  Future<void> signUp(String username, String password) async {
    final AuthInfo authInfo = await dataSource.signUp(username, password);
    _persistAuthToken(authInfo);
    // debugPrint(
    //     "The real Access Token is ${authInfo.accessToken} and the Refresh Token is ${authInfo.refreshToken}");
  }

  @override
  Future<void> refreshToken() async {
    if (authChangeNotifier.value != null) {
      final AuthInfo authInfo =
          await dataSource.refreshToken(authChangeNotifier.value!.refreshToken);
      _persistAuthToken(authInfo);
      debugPrint("refresh token is: ${authInfo.refreshToken}");
    }
  }

  Future<void> _persistAuthToken(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", authInfo.accessToken);
    sharedPreferences.setString("refresh_token", authInfo.refreshToken);
    sharedPreferences.setString("email", authInfo.email);
    loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String accessToken =
        sharedPreferences.getString("access_token") ?? "";
    final String refreshToken =
        sharedPreferences.getString("refresh_token") ?? "";
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(accessToken, refreshToken,
          sharedPreferences.getString("email") ?? '');
    }
  }

  @override
  Future<void> sighOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.clear();
    authChangeNotifier.value = null;
  }
}

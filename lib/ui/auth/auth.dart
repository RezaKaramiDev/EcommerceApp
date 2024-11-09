import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const onBackground = Colors.white;
    return Theme(
      data: themeData.copyWith(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  textStyle:
                      const WidgetStatePropertyAll(TextStyle(fontSize: 18)),
                  foregroundColor:
                      WidgetStatePropertyAll(themeData.colorScheme.secondary),
                  minimumSize:
                      const WidgetStatePropertyAll(Size.fromHeight(56)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: onBackground,
                      ))))),
          textTheme: const TextTheme(bodySmall: TextStyle(color: onBackground)),
          colorScheme: themeData.colorScheme.copyWith(onSurface: onBackground),
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: const TextStyle(
                color: onBackground,
              ),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: onBackground)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: onBackground)))),
      child: BlocProvider<AuthBloc>(
        create: (context) {
          final bloc = AuthBloc(
            authRepository,
          );
          bloc.stream.forEach((state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pop();
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });
          bloc.add(AuthStarted());
          return bloc;
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: themeData.colorScheme.secondary,
            body: Padding(
              padding: const EdgeInsets.only(left: 48, right: 48),
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) {
                  return current is AuthInitial ||
                      current is AuthLoading ||
                      current is AuthError;
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/nike_logo.png',
                        color: Colors.white,
                        width: 120,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        state.isLoginMode ? 'خوش آمدید' : 'ثبت نام',
                        style:
                            const TextStyle(color: onBackground, fontSize: 22),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        state.isLoginMode
                            ? 'لطفا وارد حساب کاربری خود شوید'
                            : 'ایمیل و رمزعبور خود را تعیین کنید',
                        style:
                            const TextStyle(color: onBackground, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextField(
                        controller: usernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(label: Text('آدرس ایمیل')),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      _PasswordTextField(
                        onBackground: onBackground,
                        controller: passwordController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context).add(
                                AuthButtonIsClicked(usernameController.text,
                                    passwordController.text));
                          },
                          child: state is AuthLoading
                              ? const CircularProgressIndicator()
                              : Text(state.isLoginMode ? 'ورود' : 'ثبت نام')),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.isLoginMode
                              ? 'حساب کاربری ندارید؟'
                              : 'حساب کاربری دارید؟'),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(AuthModeChangeIsClicked());
                            },
                            child: Text(
                              state.isLoginMode ? 'ثبت نام' : 'ورود',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: themeData.colorScheme.primary),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    required this.onBackground,
    required this.controller,
  });

  final Color onBackground;
  final TextEditingController controller;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            icon: Icon(
              obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: widget.onBackground.withOpacity(0.6),
            )),
        label: const Text('رمز عبور'),
      ),
    );
  }
}

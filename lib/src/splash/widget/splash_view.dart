import 'package:flutter/material.dart';
import 'package:ktp/env/class/env.dart';
import 'package:ktp/env/extension/on_context.dart';
import 'package:ktp/src/login/state/cubit/auth_cubit.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            Future.delayed(
              const Duration(seconds: 2),
              () {
                context.toRemoveNamed(route: Routes.home.path);
              },
            );
          }
          if (state is AuthLoginFailed) {
            Future.delayed(
              const Duration(seconds: 2),
              () {
                context.toRemoveNamed(route: Routes.login.path);
              },
            );
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Image.asset("assets/images/logo.png"),
          ),
        ),
      ),
    );
  }
}

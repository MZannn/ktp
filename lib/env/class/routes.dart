part of 'env.dart';

class Routes {
  const Routes({
    required this.path,
    required this.page,
  });
  final String path;
  final Widget page;

  static Routes splash = Routes(
    path: 'splash',
    page: BlocProvider(
      create: (context) => AuthCubit()..checkToken(),
      child: const SplashView(),
    ),
  );

  static Routes login = Routes(
    path: 'login',
    page: BlocProvider(
      create: (context) => AuthCubit(),
      child: const LoginView(),
    ),
  );
  // static Routes form = Routes(
  //   path: 'form',
  //   page: MultiBlocProvider(
  //     providers: [
  //       BlocProvider(
  //         create: (context) => FormCubit()..onBloc(),
  //       ),
  //     ],
  //     child: const FormView(),
  //   ),
  // );
  static Routes home = Routes(
    path: 'home',
    page: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationCubit()..changeScreen(0),
        ),
        BlocProvider(
          create: (context) => FormCubit()..onBloc(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit()..fetchUser(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
      ],
      child: const NavigationView(),
    ),
  );
}

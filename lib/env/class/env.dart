import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ktp/env/variable/constant.dart';
import 'package:ktp/src/form/state/form_cubit.dart';
import 'package:ktp/src/login/state/cubit/auth_cubit.dart';
import 'package:ktp/src/login/widget/login_view.dart';
import 'package:ktp/src/navigation/state/navigation_cubit.dart';
import 'package:ktp/src/navigation/widget/navigation_view.dart';
import 'package:ktp/src/profile/state/profile_cubit.dart';
import 'package:ktp/src/splash/widget/splash_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'routes.dart';
part '../models/report_model.dart';
part 'asset.dart';
part 'api.dart';
part '../enum/enum.dart';

typedef Env = Environment;

class Environment {
  static Map<String, Widget Function(BuildContext)> routes = {
    for (Routes route in [
      Routes.splash,
      Routes.login,
      Routes.home,
    ])
      route.path: (BuildContext context) => route.page,
  };
  static String initialRoute = Routes.splash.path;
}

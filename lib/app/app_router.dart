import 'package:flutter/material.dart';
import 'package:object_detect/pages/home_screen.dart';
import 'package:object_detect/pages/local_screen.dart';
import 'package:object_detect/pages/splash_screen.dart';
import 'package:object_detect/services/navigation_service.dart';
import 'package:object_detect/services/tensorflow_service.dart';
import 'package:object_detect/view_models/home_view_model.dart';
import 'package:object_detect/view_models/local_view_model.dart';
import 'package:provider/provider.dart';

class AppRoute {
  static const splashScreen = '/splashScreen';
  static const homeScreen = '/homeScreen';
  static const localScreen = '/localScreen';

  static final AppRoute _instance = AppRoute._private();
  factory AppRoute() {
    return _instance;
  }
  AppRoute._private();

  static AppRoute get instance => _instance;

  static Widget createProvider<P extends ChangeNotifier>(
    P Function(BuildContext context) provider,
    Widget child,
  ) {
    return ChangeNotifierProvider<P>(
      create: provider,
      builder: (_, __) {
        return child;
      },
    );
  }

  Route<Object>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return AppPageRoute(builder: (_) => SplashScreen());
      case homeScreen:
        Duration? duration;
        if (settings.arguments != null) {
          final args = settings.arguments as Map<String, dynamic>;
          if ((args['isWithoutAnimation'] as bool)) {
            duration = Duration.zero;
          }
        }
        return AppPageRoute(
            appTransitionDuration: duration,
            appSettings: settings,
            builder: (_) => ChangeNotifierProvider(
                create: (context) => HomeViewModel(context, Provider.of<TensorFlowService>(context, listen: false)),
                builder: (_, __) => HomeScreen()));
      case localScreen:
        return AppPageRoute(
            appSettings: settings,
            builder: (_) => ChangeNotifierProvider(
                create: (context) => LocalViewModel(context, Provider.of<TensorFlowService>(context, listen: false)),
                builder: (_, __) => LocalScreen()));
      default:
        return null;
    }
  }
}

class AppPageRoute extends MaterialPageRoute<Object> {
  Duration? appTransitionDuration;

  RouteSettings? appSettings;

  AppPageRoute({required WidgetBuilder builder, this.appSettings, this.appTransitionDuration})
      : super(builder: builder);

  @override
  Duration get transitionDuration => appTransitionDuration ?? super.transitionDuration;

  @override
  RouteSettings get settings => appSettings ?? super.settings;
}

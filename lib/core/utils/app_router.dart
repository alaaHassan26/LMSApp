import 'package:go_router/go_router.dart';
import 'package:lms/features/auth/presentation/views/sign_in_view.dart';
import 'package:lms/navigation_menu.dart';

abstract class AppRouter {
  static const kNavigationMenu = '/navigationMenu';
  static final router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SignInView(),
    ),
    GoRoute(
      path: kNavigationMenu,
      builder: (context, state) => const NavigationMenu(),
    ),
  ]);
}

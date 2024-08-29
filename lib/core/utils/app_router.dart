import 'package:go_router/go_router.dart';
import 'package:lms/features/auth/presentation/views/sign_in_view.dart';

abstract class AppRouter {
  static final router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SignInView(),
    ),
  ]);
}

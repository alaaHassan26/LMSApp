import 'package:go_router/go_router.dart';
import 'package:lms/cache/cache_helper.dart';
import 'package:lms/features/auth/presentation/views/sign_in_view.dart';
import 'package:lms/features/auth/presentation/views/widget/forgot_password.dart';
import 'package:lms/features/auth/presentation/views/widget/login_code.dart';
import 'package:lms/features/home/presentation/views/widget/comment_page.dart';
import 'package:lms/features/home/presentation/views/widget/custom_pdf_page.dart';
import 'package:lms/navigation_menu.dart';

abstract class AppRouter {
  static const kNavigationMenu = '/navigationMenu';
  static const kCommentsPage = '/commentsPage';
  static const kPDFViewerPage = '/pDFViewerPage';
  static const kLogInCode = '/logInCode';
  static const kForgotPassword = '/forgotPassword';
  static final router = GoRouter(routes: [
    CacheHelper().getData(key: 'token') != null
        ? GoRoute(
            path: '/',
            builder: (context, state) => const NavigationMenu(),
          )
        : GoRoute(
            path: '/',
            builder: (context, state) => const SignInView(),
          ),
    GoRoute(
      path: kNavigationMenu,
      builder: (context, state) => const NavigationMenu(),
    ),
    GoRoute(
      path: kCommentsPage,
      builder: (context, state) => const CommentsPage(),
    ),

    GoRoute(
  path: kPDFViewerPage,
  builder: (context, state) {
    final Map<String, String> extras = state.extra as Map<String, String>;
    return PdfViewerPage(
      filePath: extras['filePath']!,
      pdfName: extras['pdfName']!, 
    );
  },
),

    GoRoute(
      path: kLogInCode,
      builder: (context, state) => const LogInCode(),
    ),
    GoRoute(
      path: kForgotPassword,
      builder: (context, state) => const ForgotPassword(),
    )
  ]);
}

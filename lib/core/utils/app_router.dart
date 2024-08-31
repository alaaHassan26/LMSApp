import 'package:go_router/go_router.dart';
import 'package:lms/features/auth/presentation/views/sign_in_view.dart';
import 'package:lms/features/home/presentation/views/widget/comment_page.dart';
import 'package:lms/features/home/presentation/views/widget/custom_pdf_page.dart';
import 'package:lms/navigation_menu.dart';

abstract class AppRouter {
  static const kNavigationMenu = '/navigationMenu';
  static const kCommentsPage = '/commentsPage';
  static const kPDFViewerPage = '/pDFViewerPage';
  static final router = GoRouter(routes: [
    GoRoute(
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
        final pdfUrl = state.extra as String;
        return PDFViewerPage(pdfUrl: pdfUrl);
      },
    ),
  ]);
}

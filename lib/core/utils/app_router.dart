import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/cache/cache_helper.dart';
import 'package:lms/features/auth/presentation/manger/auth_cubit/auth_cubit.dart';
import 'package:lms/features/auth/presentation/views/sign_in_view.dart';
import 'package:lms/features/auth/presentation/views/widget/forgot_password.dart';
import 'package:lms/features/auth/presentation/views/widget/login_code.dart';
import 'package:lms/features/courses_page/data/models/lessons_model.dart';
import 'package:lms/features/courses_page/data/models/question_model.dart';
import 'package:lms/features/courses_page/presentation/manger/course_cubit/course_cubit.dart';
import 'package:lms/features/courses_page/presentation/manger/mcq_cubit/mcq_cubit.dart';
import 'package:lms/features/courses_page/presentation/views/courses_page_view.dart';
import 'package:lms/features/courses_page/presentation/views/widget/courses_view_list/courses_body.dart';
import 'package:lms/features/courses_page/presentation/views/widget/download_video/download_video_body.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/list_lesson_body.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/video_player_body.dart';
import 'package:lms/features/courses_page/presentation/views/widget/mcq_view_list/mcq_body.dart';
import 'package:lms/features/courses_page/presentation/views/widget/mcq_view_list/custom_mcq_page.dart';
import 'package:lms/features/courses_page/presentation/views/widget/mcq_view_list/result_page.dart';
import 'package:lms/features/courses_page/presentation/views/widget/mcq_view_list/srart_mcq_page.dart';
import 'package:lms/features/home/data/model/news_model.dart';
import 'package:lms/features/home/presentation/manger/CommentManger/fetchcomment_cubit/comment_cubit.dart';
import 'package:lms/features/home/presentation/views/widget/comment_page.dart';
import 'package:lms/features/home/presentation/views/widget/custom_pdf_page.dart';
import 'package:lms/features/home/presentation/views/widget/image_view.dart';
import 'package:lms/features/user/presentation/views/usre_update_view.dart';
import 'package:lms/navigation_menu.dart';

abstract class AppRouter {
  static const kNavigationMenu = '/navigationMenu';
  static const kCommentsPage = '/commentsPage';
  static const kPDFViewerPage = '/pDFViewerPage';
  static const kLogInCode = '/logInCode';
  static const kForgotPassword = '/forgotPassword';
  static const kImageView = '/imageView';
  static const kListLessonBody = '/listLessonBody';
  static const kVideoPlayerBody = '/customVideoPlayer';
  static const kMCQBody = '/mCQBody';
  static const kMcqQuestionPage = '/mcqQuestionPage';
  static const kStartMcqPage = '/startMcqPage';
  static const kResultsPage = '/resultsPage';
  static const kCourcsesBody = '/courcsesBody';
  static const kDownloadVideoBody = '/downloadVideoBody';
  static const kCoursesPageView = '/coursesPageView';
  static const kLogIn = '/kLogIn';
  static const kUserUpdateView = '/userUpdateView';

  static final router = GoRouter(routes: [
    CacheHelper().getData(key: 'token') != null
        ? GoRoute(
            path: '/',
            builder: (context, state) => const NavigationMenu(),
          )
        : GoRoute(
            path: '/',
            builder: (context, state) => BlocProvider(
              create: (context) => LoginCubit(),
              child: const SignInView(),
            ),
          ),
    GoRoute(
      path: kNavigationMenu,
      builder: (context, state) => const NavigationMenu(),
    ),
    GoRoute(
      path: kCommentsPage,
      builder: (context, state) {
        final newsId = state.extra as String;
        return BlocProvider(
          create: (context) => NewsCommentCubit(),
          child: CommentsPage(newsId: newsId),
        );
      },
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
      builder: (context, state) => BlocProvider(
        create: (context) => LoginCubit(),
        child: const LogInCode(),
      ),
    ),
    GoRoute(
      path: kLogIn,
      builder: (context, state) => BlocProvider(
        create: (context) => LoginCubit(),
        child: const SignInView(),
      ),
    ),
    GoRoute(
      path: kCoursesPageView,
      builder: (context, state) => const CoursesPageView(),
    ),
    GoRoute(
      path: kDownloadVideoBody,
      builder: (context, state) => const DownloadVideoBody(),
    ),
    GoRoute(
      path: kCourcsesBody,
      builder: (context, state) => BlocProvider(
        create: (context) => CoursesCubit(),
        child: const CourcsesBody(),
      ),
    ),
    GoRoute(
      path: kForgotPassword,
      builder: (context, state) => const ForgotPassword(),
    ),
    GoRoute(
      path: kImageView,
      builder: (context, state) {
        final newsModel = state.extra as NewsModel;
        return ImageView(
          newsModel: newsModel,
        );
      },
    ),
    GoRoute(
      path: kListLessonBody,
      builder: (context, state) {
        final categoryId = state.extra as String;
        return ListLessonBody(categoryId: categoryId);
      },
    ),
    GoRoute(
      path: kVideoPlayerBody,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?; // توقع استقبال Map
        if (data != null) {
          final videos =
              data['videos'] as List<Lesson>; // استلام قائمة الفيديوهات
          final initialIndex =
              data['initialIndex'] as int; // استلام الفهرس الابتدائي
          return VideoPlayerBody(videos: videos, initialIndex: initialIndex);
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Error: No videos available'),
            ),
          );
        }
      },
    ),
    GoRoute(
      path: kMCQBody,
      builder: (context, state) => BlocProvider(
        create: (context) => McqCubit(),
        child: const MCQBody(),
      ),
    ),
    GoRoute(
      path: kMcqQuestionPage,
      builder: (context, state) {
        final questions = state.extra as List<McqQuestion>?;

        if (questions != null) {
          return BlocProvider(
            create: (context) => McqCubit(),
            child: McqQuestionPage(questions: questions),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Error: No questions available'),
            ),
          );
        }
      },
    ),
    GoRoute(
      path: AppRouter.kStartMcqPage,
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>;
        final questions = extraData['questions'] as String;
        final title = extraData['title'] as String;

        return BlocProvider(
          create: (context) => McqCubit(),
          child: StartMcqPage(questions: questions, title: title),
        );
      },
    ),
    GoRoute(
      path: kResultsPage,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => McqCubit(),
          child: const ResultsPage(),
        );
        // if (state.extra != null && state.extra is Map<String, dynamic>) {
        //   final extraData = state.extra as Map<String, dynamic>;
        //   final totalQuestions = extraData['totalQuestions'] as int?;
        //   final correctAnswers = extraData['correctAnswers'] as int?;
        //   final skippedQuestions = extraData['skippedQuestions'] as int?;

        //   if (totalQuestions != null &&
        //       correctAnswers != null &&
        //       skippedQuestions != null) {
        //     return ResultsPage(

        //     );
        //   }
        // }

        // return const Scaffold(
        //   body: Center(
        //     child: Text('Error: Missing data for ResultsPage'),
        //   ),
        // );
      },
    ),
    GoRoute(
      path: kUserUpdateView,
      builder: (context, state) => const UserUpdateView(),
    ),
  ]);
}

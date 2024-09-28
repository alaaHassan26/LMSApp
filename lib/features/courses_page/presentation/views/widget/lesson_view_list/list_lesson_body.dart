import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/custom_lesson_listviws.dart';
import '../../../manger/lessons_cubit/lessons_cubit.dart'; 
import '../../../manger/lessons_cubit/lessons_state.dart'; 
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/utils/appstyles.dart';

class ListLessonBody extends StatelessWidget {
  final String categoryId; 

  const ListLessonBody({super.key, required this.categoryId}); 

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LessonsCubit()..fetchLessons(categoryId), 
      child: Scaffold(
        appBar: AppBar(
          actions: const [
            Text('33'),
            SizedBox(width: 3),
            Icon(Iconsax.video),
            SizedBox(width: 12),
          ],
          title: SizedBox(
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              'أنظمة الوقت الحقيقي(RTS)',
              style: AppStyles.styleMedium24(context),
            ),
          ),
        ),
        body: BlocBuilder<LessonsCubit, LessonsState>(
          builder: (context, state) {
            if (state is LessonsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LessonsError) {
                          print(state.message);

              return Center(child: Text(state.message));
            } else if (state is LessonsLoaded) {
              return CustomLessonListView(videos: state.lessons,); // Pass lessons to the custom list view
            }
            return const SizedBox(); // Default case if no state matches
          },
        ),
      ),
    );
  }
}

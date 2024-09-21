import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/custom_item_video_accessories_listview.dart';
import 'package:lms/features/home/presentation/manger/news_cubit/news_cubit.dart';
import 'package:lms/features/home/presentation/manger/news_cubit/news_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ListViewVideoAccessories extends StatelessWidget {
  const ListViewVideoAccessories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit()..fetchNews(),
      child: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Theme.of(context).colorScheme.onPrimary,
                size: 46,
              ),
            );
          } else if (state is NewsLoaded) {
            return Expanded(
              child: ListView.builder(
                itemCount: state.news.length,
                itemBuilder: (context, index) {
                  return CustomItemVideoAccessoriesListView(
                    newsModel: state.news[index],
                  );
                },
              ),
            );
          } else if (state is NewsError) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

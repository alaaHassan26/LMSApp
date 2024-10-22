import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/Server/Api_Dio.dart';
import 'package:lms/features/courses_page/presentation/views/widget/lesson_view_list/custom_item_video_accessories_listview.dart';
import 'package:lms/features/home/data/data_sources/home_local_data_source.dart';
import 'package:lms/features/home/data/data_sources/home_remot_data_source.dart';
import 'package:lms/features/home/data/repos_impl/home_repo_impl.dart';
import 'package:lms/features/home/domain/use_cases/news_use_case.dart';
import 'package:lms/features/home/presentation/manger/facth_news_cubit/facth_news_cubit.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class ListViewVideoAccessories extends StatelessWidget {
  const ListViewVideoAccessories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FacthNewsCubit(
          FetchNewsetUseCase(HomeRepoImpl(
            homeRemotDataSource:
                HomeRemotDataSourceImpl(apiService: ApiService()),
          )),
          HomelocalDataSourceImpl()),
      child: BlocBuilder<FacthNewsCubit, FacthNewsState>(
        builder: (context, state) {
          if (state is FacthNewsLoading) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Theme.of(context).colorScheme.onPrimary,
                size: 46,
              ),
            );
          } else if (state is FacthNewsLoaded) {
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
          } else if (state is FacthNewsError) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

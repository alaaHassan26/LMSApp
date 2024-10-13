import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../manger/news_cubit/news_cubit.dart';
import '../../manger/news_cubit/news_state.dart';
import 'custom_iteam_listview_home.dart';

class ListViewHomePage extends StatefulWidget {
  const ListViewHomePage({super.key});

  @override
  _ListViewHomePageState createState() => _ListViewHomePageState();
}

class _ListViewHomePageState extends State<ListViewHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<NewsCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.fetchNews();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (cubit.hasMore && !cubit.isLoadingMore) {
          cubit.fetchNews(isLoadMore: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        if (state is NewsLoading &&
            context.read<NewsCubit>().newsList.isEmpty) {
          return Center(
            child: LoadingAnimationWidget.discreteCircle(
              color: Theme.of(context).colorScheme.onPrimary,
              size: 46,
            ),
          );
        } else if (state is NewsLoaded) {
          final newsList = state.news;
          final hasMore = context.read<NewsCubit>().hasMore;

          return ListView.builder(
            controller: _scrollController,
            itemCount: hasMore ? newsList.length + 1 : newsList.length,
            itemBuilder: (context, index) {
              if (index < newsList.length) {
                return Card(
                  color: isDarkMode ? null : whiteColor,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  elevation: 0,
                  child: CustomItemListViewNewsHome(
                    newsModel: newsList[index],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 30,
                    ),
                  ),
                );
              }
            },
          );
        } else if (state is NewsError) {
          return Center(child: Text(state.error));
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lms/core/widget/shimmer_featured.dart';
import 'package:lms/features/home/presentation/manger/facth_news_cubit/facth_news_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'custom_iteam_listview_home.dart';

class ListViewHomePage extends StatefulWidget {
  const ListViewHomePage({super.key});

  @override
  State<ListViewHomePage> createState() => _ListViewHomePageState();
}

class _ListViewHomePageState extends State<ListViewHomePage> {
  late final ScrollController _scrollController;
  var skip = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<FacthNewsCubit>().fetchNews(skip: skip, context: context);

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            0.7 * _scrollController.position.maxScrollExtent &&
        !isLoading) {
      isLoading = true;
      skip++;
      await BlocProvider.of<FacthNewsCubit>(context)
          .fetchNews(skip: skip, context: context);
      isLoading = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<FacthNewsCubit, FacthNewsState>(
      builder: (context, state) {
        final cubit = context.read<FacthNewsCubit>();
        final newsList = cubit.allNews;

        if (cubit.isInitialLoading && newsList.isEmpty) {
          return SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Card(
                color: isDarkMode ? null : Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 2),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                elevation: 0,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ShimmerNewsItem(),
                ),
              ),
              itemCount: 4,
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              skip = 0;
              await context
                  .read<FacthNewsCubit>()
                  .refreshNews(context: context);
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: newsList.length +
                  (cubit.isLoadingMore ? 1 : 0), // التحقق من isLoadingMore
              itemBuilder: (context, index) {
                if (index < newsList.length) {
                  return Card(
                    color: isDarkMode ? null : Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                    child: CustomItemListViewNewsHome(
                      newsEnity: newsList[index],
                    ),
                  );
                } else {
                  return Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 56,
                    ),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}

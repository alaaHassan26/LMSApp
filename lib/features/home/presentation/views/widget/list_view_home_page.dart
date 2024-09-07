import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../manger/news_cubit/news_cubit.dart';
import '../../manger/news_cubit/news_state.dart';
import 'custom_iteam_listview_home.dart';

class ListViewHomePage extends StatelessWidget {
  const ListViewHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit()..fetchNews(),
      child: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            return ListView.builder(
              itemCount: state.news.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  elevation: 0,
                  child: CustomItemListViewNewsHome(
                    newsModel: state.news[index],
                  ),
                );
              },
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

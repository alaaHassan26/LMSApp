import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:lms/core/functions/save_data_in_hive.dart';
import 'package:lms/core/utils/Constatns.dart';
import 'package:lms/features/home/domain/enitites/news_enity.dart';
import 'package:lms/features/home/domain/use_cases/news_use_case.dart';

part 'facth_news_state.dart';

class FacthNewsCubit extends Cubit<FacthNewsState> {
  final FetchNewsetUseCase fetchNewsetUseCase;
  List<NewsEnity> allNews = [];
  bool hasReachedEnd = false;
  bool isLoadingMore = false;

  FacthNewsCubit(this.fetchNewsetUseCase) : super(FacthNewsInitial());

  Future<void> fetchNews(
      {int skip = 0, bool isBackgroundUpdate = false}) async {
    if (!isBackgroundUpdate) {
      if (hasReachedEnd || isLoadingMore) return;

      if (skip == 0) {
        emit(FacthNewsLoading());
      } else {
        isLoadingMore = true;
        emit(FacthNewsLoaded(allNews));
      }
    }

    var result = await fetchNewsetUseCase.call(skip: skip);
    result.fold(
      (failure) {
        isLoadingMore = false;
        emit(FacthNewsError(failure.err));
      },
      (news) {
        isLoadingMore = false;
        if (news.length < 10) {
          hasReachedEnd = true;
        }

        if (!isBackgroundUpdate) {
          allNews.addAll(news);
          emit(FacthNewsLoaded(allNews));
        } else {
          saveDatainHive(news, kNewestBox);
        }
      },
    );
  }

  Future<void> updateNewsInBackground() async {
    await fetchNews(skip: 0, isBackgroundUpdate: true);
  }
}

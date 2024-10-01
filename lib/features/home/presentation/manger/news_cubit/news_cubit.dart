import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/Repo/news_repo.dart';
import '../../../data/model/news_model.dart';
import 'news_state.dart';


class NewsCubit extends Cubit<NewsState> {
  NewsRepository newsRepository = NewsRepository();
  List<NewsModel> newsList = [];
  int skip = 0;
  final int limit = 10;
  bool isLoadingMore = false;
  bool hasMore = true;  // Add a flag to track if there is more data

  NewsCubit() : super(NewsInitial());

  Future<void> fetchNews({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (isLoadingMore || !hasMore) return;  // Prevent loading more if already loading or no more data
      isLoadingMore = true;
    } else {
      emit(NewsLoading());
    }

    final eitherResponse = await newsRepository.getNews(skip: skip, limit: limit);

    eitherResponse.fold(
      (failure) => emit(NewsError(failure.err)),
      (newNewsList) {
        if (isLoadMore) {
          if (newNewsList.length < limit) {
            hasMore = false;  // No more data if the list size is smaller than the limit
          }
          newsList.addAll(newNewsList);
          skip += limit;
          isLoadingMore = false;
        } else {
          newsList = newNewsList;
          skip = limit;
          hasMore = newNewsList.length == limit;  // If new list size equals the limit, there's more data
        }
        emit(NewsLoaded(newsList));
      },
    );
  }
}

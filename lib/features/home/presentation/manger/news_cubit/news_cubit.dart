import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/Repo/news_repo.dart';
import 'news_state.dart';



class NewsCubit extends Cubit<NewsState> {
   NewsRepository newsRepository = NewsRepository();

  NewsCubit() : super(NewsInitial());

  Future<void> fetchNews() async {
    emit(NewsLoading());
    final eitherResponse = await newsRepository.getNews();

    eitherResponse.fold(
      (failure) => emit(NewsError(failure.err)),
      (newsList) => emit(NewsLoaded(newsList)),
    );
  }
}

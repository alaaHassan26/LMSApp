import '../../../data/model/news_model.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsModel> news;

  NewsLoaded(this.news);
}

class NewsError extends NewsState {
  final String error;

  NewsError(this.error);
}
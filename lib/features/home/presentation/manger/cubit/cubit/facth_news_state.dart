part of 'facth_news_cubit.dart';

@immutable
sealed class FacthNewsState {}

final class FacthNewsInitial extends FacthNewsState {}

final class FacthNewsLoading extends FacthNewsState {}

final class FacthNewsLoadingSkip extends FacthNewsState {}

final class FacthNewsLoaded extends FacthNewsState {
  final List<NewsEnity> news;

  FacthNewsLoaded(this.news);
}

final class FacthNewsError extends FacthNewsState {
  final String error;

  FacthNewsError(this.error);
}

class FacthNewsRefreshed extends FacthNewsState {}

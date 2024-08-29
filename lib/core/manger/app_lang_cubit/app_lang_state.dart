part of 'app_lang_cubit.dart';

@immutable
sealed class AppLangState {}

final class AppLangInitial extends AppLangState {}

final class AppChangeLang extends AppLangState {
  final String? languageCode;

  AppChangeLang({required this.languageCode});
}

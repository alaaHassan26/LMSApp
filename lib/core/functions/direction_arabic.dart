// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/manger/app_lang_cubit/app_lang_cubit.dart';

bool isArabic(BuildContext context) {
  final state = BlocProvider.of<AppLangCubit>(context).state;
  return state is AppChangeLang && state.languageCode == 'ar';
}

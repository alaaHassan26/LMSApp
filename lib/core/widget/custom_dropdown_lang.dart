import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/manger/app_lang_cubit/app_lang_cubit.dart';
import 'package:lms/core/models/Enums/lang_event_type.dart';
import 'package:lms/core/utils/appstyles.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<StatefulWidget> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'ar', 'name': 'عربي', 'flag': '🇮🇶'},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLangCubit, AppLangState>(
      builder: (context, state) {
        String selectedLanguageCode =
            (state is AppChangeLang && state.languageCode == 'en')
                ? 'en'
                : 'ar';

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedLanguageCode,
              onChanged: (String? newValue) {
                if (newValue == 'ar') {
                  context
                      .read<AppLangCubit>()
                      .appLang(LangEventEnums.arabicLang);
                } else {
                  context
                      .read<AppLangCubit>()
                      .appLang(LangEventEnums.englishLang);
                }
              },
              items: languages
                  .map<DropdownMenuItem<String>>((Map<String, String> lang) {
                return DropdownMenuItem<String>(
                  value: lang['code'],
                  child: Row(
                    children: [
                      Text(lang['flag'] ?? ''),
                      const SizedBox(width: 8),
                      Text(
                        lang['name'] ?? '',
                        style: AppStyles.styleMedium20(context),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

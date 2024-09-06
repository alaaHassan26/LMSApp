import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/manger/app_lang_cubit/app_theme_cubit/app_theme_cubit.dart';
import 'package:lms/core/models/Enums/theme_state.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .1,
        ),
        Switch(
          value: isDarkMode,
          onChanged: (value) {
            var themeCubit = context.read<AppThemeCubit>();
            if (value) {
              themeCubit.changeTheme(ThemeState.dark);
            } else {
              themeCubit.changeTheme(ThemeState.ligth);
            }
          },
        ),
      ],
    );
  }
}

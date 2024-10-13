import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/features/courses_page/presentation/manger/search_cubit/search_cubit.dart';

class SearchAndFilterBar extends StatelessWidget {
  const SearchAndFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        color: isDarkMode ? null : whiteColor,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  context.read<SearchCubit>().search(value);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: AppLocalizations.of(context)!.translate('search'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

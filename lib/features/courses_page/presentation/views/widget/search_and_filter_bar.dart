import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/features/courses_page/presentation/manger/search_cubit/search_cubit.dart';

class SearchAndFilterBar extends StatelessWidget {
  const SearchAndFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onTap: () {
                  // عند التركيز على مربع البحث، إخفاء الدروس
                  context.read<SearchCubit>().clearSearch();
                },
                onChanged: (value) {
                  // البحث أثناء الكتابة
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

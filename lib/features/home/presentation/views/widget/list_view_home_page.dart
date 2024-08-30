import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/features/home/data/model/home_model.dart';
import 'package:lms/features/home/presentation/views/widget/custom_iteam_listview_home.dart';

class ListViewHomePage extends StatelessWidget {
  final VoidCallback onLongPressPost;

  const ListViewHomePage({super.key, required this.onLongPressPost});

  @override
  Widget build(BuildContext context) {
    List<HomeModel> item = [
      HomeModel(
        image: null,
        title: AppLocalizations.of(context)!.translate('design'),
      ),
      HomeModel(
        image: 'assets/images/rebot.jpg',
        title: AppLocalizations.of(context)!.translate('mobile'),
      ),
      const HomeModel(image: 'assets/images/lms_test.jpg', title: null),
      HomeModel(
        image: 'assets/images/arduino.jpg',
        title: AppLocalizations.of(context)!.translate('it_is_one'),
      ),
    ];
    return ListView.builder(
        itemCount: item.length,
        itemBuilder: (context, index) {
          return CustomItemListViewNewsHome(
            homeModel: item[index],
            onLongPress: onLongPressPost,
          );
        });
  }
}

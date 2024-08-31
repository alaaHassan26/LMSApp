import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/features/home/data/model/home_model.dart';
import 'package:lms/features/home/presentation/views/widget/custom_iteam_listview_home.dart';

class ListViewHomePage extends StatelessWidget {
  const ListViewHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<HomeModel> item = [
      HomeModel(
          image: null,
          title: AppLocalizations.of(context)!.translate('design'),
          pdfUrl: 'https://www.gotronic.fr/pj2-34976-1794.pdf'),
      HomeModel(
          image: [
            'assets/images/rebot.jpg',
            'assets/images/arduino.jpg',
          ],
          title: AppLocalizations.of(context)!.translate('mobile'),
          pdfUrl:
              'https://docs.arduino.cc/resources/datasheets/A000066-datasheet.pdf'),
      const HomeModel(
          image: ['assets/images/lms_test.jpg'], title: null, pdfUrl: null),
      HomeModel(
          image: [
            'assets/images/arduino.jpg',
            'assets/images/rebot.jpg',
            'assets/images/lms_test.jpg'
          ],
          title: AppLocalizations.of(context)!.translate('it_is_one'),
          pdfUrl: null),
      const HomeModel(
          image: null,
          title: null,
          pdfUrl:
              'https://www.theseus.fi/bitstream/handle/10024/37806/Shakhatreh_Fareed.pdf'),
    ];
    return ListView.builder(
        itemCount: item.length,
        itemBuilder: (context, index) {
          return CustomItemListViewNewsHome(
            homeModel: item[index],
          );
        });
  }
}

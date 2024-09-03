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
          pdfUrl:
              'https://d1wqtxts1xzle7.cloudfront.net/70949688/pdf-libre.pdf?1633146192=&response-content-disposition=inline%3B+filename%3DRancang_Bangun_Robot_Beroda_Pemadam_Api.pdf&Expires=1725365174&Signature=KFunHInl~akHiNjw1-YcIbX99pu4fPN6sF1ztf3O6xiAgRznu-ow7GF6DuJC6nOzbBbi3HxM2Rd3oG-0~V7lno6Z9LDT9iDBeHzN6~mE66Cf2OzERrleTwNhK9KdMvSYyo1SaTcGHchQ9AKgFngQKvnEc2YSoMvqFpRmCjMkWnGjF2HdcJLqmGFHrGhufCQiUAji5X0C9jksV-3xk2589lxeuEZtuw3JsvsmIpneO47YfhJPcpOeLoqaRdb4tLd-5VT-zTp-Jk8ujuGurG3xDLmtWYGt34IVoM-regLPILlDQgURa9maLVJxQZNh2tqyZcjfI3z3XbcjdF4mc5gIfg__&Key-Pair-Id=APKAJLOHF5GGSLRBV4ZA',
          namePdf: 'Robot by Arduino'),
      HomeModel(
          image: [
            'assets/images/rebot.jpg',
            'assets/images/arduino.jpg',
          ],
          title: AppLocalizations.of(context)!.translate('mobile'),
          pdfUrl:
              'https://www.researchgate.net/profile/Asoke-Nath-4/publication/304624684_Gesture_Controlled_Robot_using_Arduino_and_Android/links/57750adb08ae1b18a7dfa026/Gesture-Controlled-Robot-using-Arduino-and-Android.pdf',
          namePdf: 'Mobile Robot'),
      const HomeModel(
          image: ['assets/images/lms_test.jpg'],
          title: null,
          pdfUrl: null,
          namePdf: null),
      HomeModel(
          image: [
            'assets/images/arduino.jpg',
            'assets/images/rebot.jpg',
            'assets/images/lms_test.jpg'
          ],
          title: AppLocalizations.of(context)!.translate('it_is_one'),
          pdfUrl: null,
          namePdf: null),
      const HomeModel(
          image: null,
          title: null,
          pdfUrl:
              'https://www.theseus.fi/bitstream/handle/10024/37806/Shakhatreh_Fareed.pdf',
          namePdf: 'Shakhatreh_Fareed.pdf'),
    ];
    return ListView.builder(
        itemCount: item.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            child: CustomItemListViewNewsHome(
              homeModel: item[index],
            ),
          );
        });
  }
}

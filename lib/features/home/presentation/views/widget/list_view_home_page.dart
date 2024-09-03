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
            'https://d1wqtxts1xzle7.cloudfront.net/64599706/IRJET-V7I5770-libre.pdf?1601893819=&response-content-disposition=inline%3B+filename%3DIRJET_VOICE_CONTROLLED_ROBOT_CAR_USING_A.pdf&Expires=1725378533&Signature=Fy7tSrBX8tqgTbMSPAA39m3uwTjAp9yIPCaVAYObjAXd3YvBnnsawTd7f6HJOIC-g72lsIfmGV9o2~Cq-XvIdV9tuN98ON9GaAvH4Mi6t-Dj1pSXknEQpO9sD9Xv~1FNvlTldswZhKzS-k6JVa1giY1yYbnXtf-4~qQXd-QnrfAtFAc9ZM9tDX0BhhH4sAKp1I4NcNwWhqi~uy7M476K6lllF0I1WCloGf0MwB8ye3QxtJ1akurocm4wBricpX90Xq-hcpcTb2Bd-oy7esM76BDLpIGpBQYZsyxYHRnqUb4uLJHG-zsfUFKszsZoWZY7nMK7i59WVwijBcwCWu9xqQ__&Key-Pair-Id=APKAJLOHF5GGSLRBV4ZA',
        namePdf: 'Robot by Arduino',
        postTitle: AppLocalizations.of(context)!.translate('post_title'),
      ),
      HomeModel(
        image: [
          'assets/images/rebot.jpg',
          'assets/images/arduino.jpg',
        ],
        title: AppLocalizations.of(context)!.translate('mobile'),
        pdfUrl:
            'https://www.researchgate.net/profile/Asoke-Nath-4/publication/304624684_Gesture_Controlled_Robot_using_Arduino_and_Android/links/57750adb08ae1b18a7dfa026/Gesture-Controlled-Robot-using-Arduino-and-Android.pdf',
        namePdf: 'Mobile Robot',
        postTitle: AppLocalizations.of(context)!.translate('post_title'),
      ),
      HomeModel(
        image: ['assets/images/lms_test.jpg'],
        title: null,
        pdfUrl: null,
        namePdf: null,
        postTitle: AppLocalizations.of(context)!.translate('post_title'),
      ),
      HomeModel(
        image: [
          'assets/images/arduino.jpg',
          'assets/images/rebot.jpg',
          'assets/images/lms_test.jpg'
        ],
        title: AppLocalizations.of(context)!.translate('it_is_one'),
        pdfUrl: null,
        namePdf: null,
        postTitle: AppLocalizations.of(context)!.translate('post_title'),
      ),
      const HomeModel(
          postTitle: null,
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
            margin: const EdgeInsets.symmetric(vertical: 3),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            elevation: 0,
            child: CustomItemListViewNewsHome(
              homeModel: item[index],
            ),
          );
        });
  }
}

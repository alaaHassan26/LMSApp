import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lms/core/utils/appstyles.dart';

class LogoAndNameSignIn extends StatelessWidget {
  const LogoAndNameSignIn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/6170426_3054594.svg',
          height: MediaQuery.of(context).size.height * .2,
          width: MediaQuery.of(context).size.width * .2,
        ),
        const SizedBox(height: 4.0),
        SizedBox(
          width: 250.0,
          child: DefaultTextStyle(
            style: AppStyles.styleSemiBold34(context).copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: 'Montserrat'),
            child: Center(
              child: AnimatedTextKit(
                totalRepeatCount: 8,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'L M S',
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

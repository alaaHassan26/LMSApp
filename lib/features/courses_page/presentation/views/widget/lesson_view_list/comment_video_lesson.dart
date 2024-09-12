import 'package:flutter/material.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/core/widget/custom_text_filed.dart';

class CommentsVideoLesson extends StatelessWidget {
  const CommentsVideoLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildComment(
                  context,
                  'Alaa Hassan',
                  'اترك البرج الناس حولت ضوئي',
                ),
                _buildComment(
                  context,
                  'Ali',
                  'لاتشغل بهالشي',
                ),
              ],
            ),
          ),
          _buildCommentInput(context),
        ],
      ),
    );
  }

  Widget _buildComment(BuildContext context, String author, String comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/alaa.jpg'),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.07),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: AppStyles.styleSemiBold20(context)),
                    const SizedBox(height: 4),
                    Text(
                      comment,
                      style: AppStyles.styleMedium18(context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('min'),
                          style: AppStyles.styleMedium16(context)
                              .copyWith(color: greyColor),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context)!.translate('like'),
                            style: AppStyles.styleBold16(context),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context)!.translate('reply'),
                            style: AppStyles.styleBold16(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
              child: CustomTextField(
            sizeTextFiled: 12,
            hintText: AppLocalizations.of(context)!.translate('wac'),
          )),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

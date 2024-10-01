import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';

class Comment {
  final String username;
  final String content;
  final String time;
  final List<Comment> replies;
  bool isExpanded;

  Comment({
    required this.username,
    required this.content,
    required this.time,
    this.replies = const [],
    this.isExpanded = false,
  });
}

class CommentsPage extends StatefulWidget {
  final String newsId;
  const CommentsPage({super.key, required this.newsId});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List<Comment> comments = [
    Comment(
      username: 'علاء حسن',
      content: 'علي عبد بروح امك اربط ال ui بالوجبك 😪',
      time: '5 دقائق',
      replies: [
        Comment(
          username: 'علي عبد الشهيد الديوث',
          content: 'تدلل ابو حسين خادم الك',
          time: '2 دقيقة',
        ),
        Comment(
          username: 'علاء حسن',
          content: 'حبيبي اخبط جيسين',
          time: '1 دقيقة',
        ),
      ],
    ),
    Comment(
      username: 'علي عبد الشهيد الديوث',
      content: 'كم حمل انشال اليه ولا مهتم بس حملج كسر ظهري حبيبتي زنوبة',
      time: '15 دقيقة',
      replies: [],
    ),
    Comment(
      username: 'ابو رقية',
      content: 'اخوان اني اخاف من ام رقية اريد نصيحة منكم',
      time: '25 دقيقة',
      replies: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التعليقات'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: Column(
            children: [
              const Divider(),
              Expanded(
                child: ListView(
                  children: List.generate(comments.length, (index) {
                    return Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: buildCommentItem(context, comments[index]),
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'اكتب تعليقًا...',
                          hintStyle: AppStyles.styleMedium20(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCommentItem(BuildContext context, Comment comment,
      {bool isReply = false}) {
    return Padding(
      padding: isArabic(context)
          ? EdgeInsets.only(
              top: 4.0,
              bottom: 4.0,
              right: isReply ? 40.0 : 0.0,
            )
          : EdgeInsets.only(
              top: 4.0,
              bottom: 4.0,
              left: isReply ? 40.0 : 0.0,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          comment.username,
                          style: AppStyles.styleMedium20(context),
                        ),
                        Text(
                          comment.time,
                          style: AppStyles.styleMedium16(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.content,
                      style: AppStyles.styleMedium18(context),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'رد',
                            style: AppStyles.styleMedium16(context),
                          ),
                        ),
                        if (comment.replies.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                comment.isExpanded = !comment.isExpanded;
                              });
                            },
                            child: Text(
                              comment.isExpanded
                                  ? 'إخفاء الردود'
                                  : 'عرض الردود',
                              style: AppStyles.styleMedium16(context),
                            ),
                          ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              _showOptionsDialog(context);
                            },
                            icon: const Icon(Iconsax.menu))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // هنا عرض الردود ابو حسين
          if (comment.isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: comment.replies
                    .map((reply) =>
                        buildCommentItem(context, reply, isReply: true))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            AppLocalizations.of(context)!.translate('options'),
            style: AppStyles.styleMedium20(context),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Iconsax.edit),
                title: Text(
                  'تعديل التعليق',
                  style: AppStyles.styleMedium16(context),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Iconsax.trash),
                title: Text(
                  'حذف التعليق',
                  style: AppStyles.styleMedium16(context),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.translate('cancel'),
                style: AppStyles.styleMedium16(context).copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

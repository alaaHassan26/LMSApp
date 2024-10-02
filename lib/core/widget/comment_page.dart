import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';

class Comment {
  final String username;
  String content;
  final String time;
  List<Comment> replies;
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
      content: 'علي عبد، بروح امك اربط ال UI بالوجبك 😪',
      time: '5 دقائق',
      replies: [
        Comment(
          username: 'علي عبد الشهيد',
          content: '@علاء حسن تدلل ابو حسين خادم الك',
          time: '2 دقيقة',
        ),
        Comment(
          username: 'علاء حسن',
          content: '@علي عبد الشهيد حبيبي اخبط جيسين',
          time: '1 دقيقة',
          replies: [
            Comment(
              username: 'علي عبد الشهيد',
              content: '@علاء حسن جاهز انت ع الطلعة؟',
              time: 'الآن',
            ),
          ],
        ),
      ],
    ),
    Comment(
      username: 'علي عبد الشهيد',
      content: 'كم حمل انشال اليه ولا مهتم بس حملج كسر ظهري حبيبتي زنوبة',
      time: '15 دقيقة',
      replies: [],
    ),
    Comment(
      username: 'ابو رقية',
      content: 'اخوان اني اخاف من ام رقية اريد نصيحة منكم',
      time: '25 دقيقة',
      replies: [
        Comment(
          username: 'علاء حسن',
          content: '@ابو رقية تدلل بس لا تخاف، احنا وياك',
          time: '20 دقيقة',
        ),
        Comment(
          username: 'علي عبد الشهيد',
          content: '@ابو رقية زين شلون ترضى تعيش وياها هههه',
          time: '15 دقيقة',
        ),
      ],
    ),
  ];

  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Comment? _editingComment;
  Comment? _replyingTo;

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التعليقات'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
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
                        focusNode: _focusNode,
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: _replyingTo == null
                              ? 'اكتب تعليقًا...'
                              : 'اكتب ردًا @${_replyingTo!.username}...',
                          hintStyle: AppStyles.styleMedium20(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_commentController.text.trim().isNotEmpty) {
                          setState(() {
                            if (_editingComment != null) {
                              // تعديل التعليق الحالي
                              _editingComment!.content =
                                  _commentController.text.trim();
                              _editingComment = null;
                            } else if (_replyingTo != null) {
                              // إضافة رد على تعليق أو رد
                              _replyingTo!.replies =
                                  List.from(_replyingTo!.replies)
                                    ..add(Comment(
                                      username: 'المستخدم الحالي',
                                      content:
                                          '@${_replyingTo!.username} ${_commentController.text.trim()}',
                                      time: 'الآن',
                                    ));
                              _replyingTo = null;
                            } else {
                              // إضافة تعليق جديد
                              comments.add(Comment(
                                username: 'المستخدم الحالي',
                                content: _commentController.text.trim(),
                                time: 'الآن',
                              ));
                            }
                            _commentController.clear();
                            _focusNode.unfocus();
                          });
                        }
                      },
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
                          onPressed: () {
                            setState(() {
                              _replyingTo = comment;
                            });
                            _focusNode.requestFocus();
                          },
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
                            _showOptionsDialog(context, comment);
                          },
                          icon: const Icon(Iconsax.menu),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  void _showOptionsDialog(BuildContext context, Comment comment) {
    FocusScope.of(context).unfocus();
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
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(context, comment);
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.trash),
                title: Text(
                  'حذف التعليق',
                  style: AppStyles.styleMedium16(context),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmationDialog(context, comment);
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
                style: AppStyles.styleMedium18(context),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Comment comment) {
    _commentController.text = comment.content;
    _editingComment = comment;
    _focusNode.requestFocus();
  }

  void _showDeleteConfirmationDialog(BuildContext context, Comment comment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'حذف التعليق',
            style: AppStyles.styleMedium20(context),
          ),
          content: Text(
            'هل أنت متأكد أنك تريد حذف هذا التعليق؟',
            style: AppStyles.styleMedium18(context),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'إلغاء',
                style: AppStyles.styleMedium16(context),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  comments.remove(comment);
                });
                Navigator.pop(context);
              },
              child: Text(
                'حذف',
                style: AppStyles.styleMedium16(context),
              ),
            ),
          ],
        );
      },
    );
  }
}

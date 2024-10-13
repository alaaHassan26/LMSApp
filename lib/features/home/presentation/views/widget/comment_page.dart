import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/direction_arabic.dart';
import 'package:lms/core/functions/format_data.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';

import '../../../data/model/news_comments_model.dart';
import '../../manger/comment_cubit/comment_cubit.dart';
import '../../manger/comment_cubit/comment_state.dart';


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
  List<Comment> comments = []; // Initially empty, filled after fetching
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Comment? _editingComment;
  Comment? _replyingTo;

  @override
  void initState() {
    super.initState();
    context.read<NewsCommentCubit>().fetchComments(widget.newsId);
  }

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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            const Divider(),
            Expanded(
              child: BlocBuilder<NewsCommentCubit, NewsCommentState>(
                builder: (context, state) {
                  if (state is NewsCommentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NewsCommentFailure) {
                    return Center(child: Text(state.error));
                  } else if (state is NewsCommentFetchSuccess) {
                    // Convert NewsCommentModel to Comment
                    comments = state.comments.map((e) => _mapNewsCommentToComment(e)).toList();
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: buildCommentItem(context, comments[index]),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No comments available.'));
                  }
                },
              ),
            ),
            _buildCommentInputField(),
          ],
        ),
      ),
    );
  }


  Comment _mapNewsCommentToComment(NewsCommentModel newsComment) {
    return Comment(
      username: newsComment.user!.name!,
      content: newsComment.content!,
      time: formatDate(  newsComment.createdAt! , context),
      replies: newsComment.children.map((child) => _mapNewsCommentToComment(child)).toList(),
    );
  }



  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _commentController,
              decoration: InputDecoration(
                hintText: _replyingTo == null ? 'اكتب تعليقًا...' : 'اكتب ردًا @${_replyingTo!.username}...',
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
                    // Edit comment in UI
                    _editingComment!.content = _commentController.text.trim();
                    _editingComment = null; // Clear editing comment
                  } else if (_replyingTo != null) {
                    // Add reply in UI
                    _replyingTo!.replies.add(Comment(
                      username: 'المستخدم الحالي',
                      content: '@${_replyingTo!.username} ${_commentController.text.trim()}',
                      time: 'الآن',
                    ));
                    _replyingTo = null; // Clear replyingTo after adding reply
                  } else {
                    // Add new comment in UI
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
    );
  }

  Widget buildCommentItem(BuildContext context, Comment comment, {bool isReply = false}) {
    return Padding(
      padding: isArabic(context)
          ? EdgeInsets.only(top: 4.0, bottom: 4.0, right: isReply ? 40.0 : 0.0)
          : EdgeInsets.only(top: 4.0, bottom: 4.0, left: isReply ? 40.0 : 0.0),
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
                              _replyingTo = comment; // Set replying to this comment
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
                                comment.isExpanded = !comment.isExpanded; // Toggle replies
                              });
                            },
                            child: Text(
                              comment.isExpanded ? 'إخفاء الردود' : 'عرض الردود',
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
                    .map((reply) => buildCommentItem(context, reply, isReply: true))
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  setState(() {
                    comments.remove(comment);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Comment comment) {
    _commentController.text = comment.content;
    _editingComment = comment; // Set editing comment
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'تعديل التعليق',
            style: AppStyles.styleMedium20(context),
          ),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'اكتب تعليقًا...',
              hintStyle: AppStyles.styleMedium20(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Save the edited comment
                  comment.content = _commentController.text.trim();
                  _editingComment = null; // Clear editing comment
                });
                _commentController.clear();
                Navigator.pop(context);
              },
              child: Text('حفظ', style: AppStyles.styleMedium16(context)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('إلغاء', style: AppStyles.styleMedium16(context)),
            ),
          ],
        );
      },
    );
  }
}

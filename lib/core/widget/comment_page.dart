import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/format_data.dart';
import 'package:lms/core/utils/Constatns.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/core/widget/custom_text_filed.dart';
import 'package:lms/core/widget/shimmer_featured.dart';
import 'package:lms/features/home/data/model/news_comments_model.dart';
import 'package:lms/features/home/presentation/manger/news_comment_cubit/news_comment_cubit.dart';
import 'package:lms/features/home/presentation/manger/news_comment_cubit/news_comment_state.dart';

class CommentsPage extends StatefulWidget {
  final String newsId;

  const CommentsPage({required this.newsId, super.key});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final Map<String, int> _repliesLimit =
      {}; // لتتبع عدد الردود المعروضة لكل تعليق

  @override
  void initState() {
    super.initState();
    context.read<CommentsCubit>().fetchComments(widget.newsId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('comments'),
          style: AppStyles.styleSemiBold24(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<CommentsCubit, CommentsState>(
                builder: (context, state) {
                  if (state is CommentsLoading) {
                    return Center(
                        child: ListView.builder(
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return const CommentsPagevShimmer();
                      },
                    ));
                  } else if (state is CommentsLoaded) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return refreshAllData(context, widget.newsId);
                      },
                      child: ListView.builder(
                        itemCount: state.commentsList.length,
                        itemBuilder: (context, index) {
                          final comment = state.commentsList[index];
                          return _buildComment(
                            context,
                            comment.user.name,
                            comment.content,
                            comment,
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(child: Text('Failed to load comments'));
                  }
                },
              ),
            ),
            _buildCommentInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildComment(BuildContext context, String author, String comment,
      NewsCommentModel commentModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: commentModel.user.image != null
                    ? CachedNetworkImageProvider(
                        '${CS.Api}${commentModel.user.image!}')
                    : null,
                radius: 20,
                child: commentModel.user.image == null
                    ? Text(commentModel.user.name.substring(0, 1))
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.07),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
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
                              formatDate(commentModel.createdAt, context),
                              style: AppStyles.styleMedium16(context)
                                  .copyWith(color: greyColor),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        _buildReplies(context, commentModel, author),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                _showReplyDialog(
                                    context, commentModel.id, author);
                              },
                              child: const Text(
                                'Reply',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReplies(BuildContext context, NewsCommentModel commentModel,
      String originalAuthor) {
    final replies = commentModel.children;
    final limit =
        _repliesLimit[commentModel.id] ?? 1; // عدد الردود المعروضة حالياً

    return Column(
      children: [
        ...replies.take(limit).map((reply) {
          return _buildReply(context, reply, originalAuthor);
        }).toList(),
        if (replies.length > limit)
          TextButton(
            onPressed: () {
              setState(() {
                _repliesLimit[commentModel.id] = limit + 5; // عرض 5 ردود إضافية
              });
            },
            child: Text('عرض المزيد (${replies.length - limit} ردود)'),
          ),
      ],
    );
  }

  Widget _buildReply(BuildContext context, NewsCommentModel replyModel,
      String originalAuthor) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: replyModel.user.image != null
                ? CachedNetworkImageProvider(
                    '${CS.Api}${replyModel.user.image!}')
                : null,
            radius: 18,
            child: replyModel.user.image == null
                ? Text(replyModel.user.name.substring(0, 1))
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.07),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(replyModel.user.name,
                      style: AppStyles.styleSemiBold18(context)),
                  const SizedBox(height: 4),
                  Text(
                    "@$originalAuthor ${replyModel.content}",
                    style: AppStyles.styleMedium16(context),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(replyModel.createdAt, context),
                    style: AppStyles.styleMedium16(context)
                        .copyWith(color: greyColor),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: const Text(
                          'Reply',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context, String parentCommentId,
      [String? repliedTo]) {
    TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a reply'),
          content: TextField(
            controller: replyController,
            decoration: InputDecoration(
              hintText: 'Reply to ${repliedTo ?? 'comment'}...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final content = replyController.text;
                if (content.isNotEmpty) {
                  context.read<CommentsCubit>().replyToComment(
                        widget.newsId,
                        content,
                        parentCommentId,
                      );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Reply'),
            ),
          ],
        );
      },
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
              controller: _commentController,
              hintText: AppLocalizations.of(context)!.translate('wac'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final content = _commentController.text;
              if (content.isNotEmpty) {
                context
                    .read<CommentsCubit>()
                    .addComment(widget.newsId, content);
                _commentController.clear(); // Clear input field
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<void> refreshAllData(context, String newsId) async {
  BlocProvider.of<CommentsCubit>(context).fetchComments(newsId);
}

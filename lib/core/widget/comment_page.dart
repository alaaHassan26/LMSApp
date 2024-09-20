import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import 'package:lms/core/widget/custom_text_filed.dart';
import '../../features/home/data/model/news_comments_model.dart';
import '../../features/home/presentation/manger/news_comment_cubit/news_comment_cubit.dart';
import '../../features/home/presentation/manger/news_comment_cubit/news_comment_state.dart';
import '../utils/app_localiizations.dart';

class CommentsPage extends StatefulWidget {
  final String newsId;

  const CommentsPage({super.key, required this.newsId});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final Map<String, bool> _expandedReplies = {};
  String? _replyToCommentId;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentsCubit()..fetchComments(widget.newsId),
      child: Scaffold(
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
                child: _buildCommentsList(widget.newsId),
              ),
              if (_replyToCommentId == null) ...[
                _buildCommentInput(context),
              ] else ...[
                _buildReplyInput(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsList(String newsId) {
    return BlocBuilder<CommentsCubit, CommentsState>(
      builder: (context, state) {
        if (state is CommentsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CommentsLoaded) {
          return ListView.builder(
            itemCount: state.commentsList.length,
            itemBuilder: (context, index) {
              final comment = state.commentsList[index];
              return _buildComment(context, comment);
            },
          );
        } else if (state is CommentsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('No comments found.'));
        }
      },
    );
  }

  Widget _buildComment(BuildContext context, NewsCommentModel comment) {
    final String commentId = comment.id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: comment.isProfessor == 0
                    ? const AssetImage('assets/images/alaa.jpg')
                    : const NetworkImage(
                        'https://images.pexels.com/photos/1450114/pexels-photo-1450114.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2') as ImageProvider,
                radius: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
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
                        Text(
                          comment.isProfessor == 1 ? 'Prof' : comment.user.name,
                          style: AppStyles.styleSemiBold20(context),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          comment.content,
                          style: AppStyles.styleMedium18(context),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _formatDate(comment.createdAt, context),
                              style: AppStyles.styleMedium16(context).copyWith(color: greyColor),
                            ),
                            if (comment.isProfessor == 1) ...[
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _replyToCommentId = commentId;
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.translate('reply'),
                                  style: AppStyles.styleBold16(context),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (comment.children != null && comment.children!.isNotEmpty) ...[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _expandedReplies[commentId] = !(_expandedReplies[commentId] ?? false);
                              });
                            },
                            child: Text(
                              _expandedReplies[commentId] ?? false
                                  ? 'اخفاء الردود'
                                  : 'أظهر ${comment.children!.length} من الردود',
                              style: AppStyles.styleBold16(context),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_expandedReplies[commentId] ?? false) ...[
            for (var child in comment.children!) ...[
              Padding(
                padding: const EdgeInsets.only(right: 60.0, top: 20), // Indent replies
                child: _buildComment(context, child),
              ),
            ],
          ],
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
              controller: _commentController,
              sizeTextFiled: 12,
              hintText: AppLocalizations.of(context)!.translate('wac'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final content = _commentController.text.trim();
              if (content.isNotEmpty) {
                context.read<CommentsCubit>().addComment(widget.newsId, content);
                _commentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: _replyController,
              sizeTextFiled: 12,
              hintText: AppLocalizations.of(context)!.translate('wac'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final content = _replyController.text.trim();
              if (content.isNotEmpty && _replyToCommentId != null) {
                context.read<CommentsCubit>().replayComment(
                      widget.newsId,
                      content,
                      _replyToCommentId!,
                    );
                _replyController.clear();
                setState(() {
                  _replyToCommentId = null;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 30) {
      return 'منذ ${difference.inDays ~/ 30} شهر';
    } else if (difference.inDays >= 7) {
      return 'منذ ${difference.inDays ~/ 7} اسبوع';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'منذ ${difference.inSeconds} ثواني';
    }
  }
}

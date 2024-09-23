import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/home/data/model/news_comments_model.dart';
import '../../features/home/presentation/manger/news_comment_cubit/comment_cubit.dart';
import '../../features/home/presentation/manger/news_comment_cubit/news_comment_cubit.dart';
import '../../features/home/presentation/manger/news_comment_cubit/news_comment_state.dart';
import '../utils/app_localiizations.dart';
import '../utils/appstyles.dart';
import 'custom_text_filed.dart';

class CommentsPage extends StatelessWidget {
  final String newsId;

  const CommentsPage({super.key, required this.newsId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CommentsCubit()..fetchComments(newsId)),
        BlocProvider(create: (context) => CommentCubit()),
      ],
      child: _CommentPage(newsId: newsId),
    );
  }
}

class _CommentPage extends StatefulWidget {
  final String newsId;

  const _CommentPage({Key? key, required this.newsId}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<_CommentPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController editCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CommentsCubit>().fetchComments(widget.newsId);
  }

  void showEditCommentSheet(BuildContext context, int index) {
final comment = (context.read<CommentsCubit>().state as CommentsLoaded).commentsList[index];
    editCommentController.text = comment.content;

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("تعديل التعليق",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: editCommentController,
              decoration: const InputDecoration(labelText: 'تعليقك...'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'لا يمكن أن يكون التعليق فارغًا';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (editCommentController.text.isNotEmpty) {
                  context
                      .read<CommentCubit>()
                      .editComment(index, editCommentController.text);
                  Navigator.pop(context); 
                }
              },
              child: const Text("حفظ"),
            ),
          ],
        ),
      ),
    );
  }

  void confirmDeleteComment(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("حذف التعليق"),
        content: const Text("هل أنت متأكد أنك تريد حذف هذا التعليق؟"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              context.read<CommentCubit>().deleteComment(index);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("حذف"),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentList(BuildContext context) {
    return BlocBuilder<CommentsCubit, CommentsState>(
      builder: (context, state) {
        if (state is CommentsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CommentsError) {
          return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)));
        } else if (state is CommentsLoaded) {
          return ListView.builder(
            itemCount: state.commentsList.length,
            itemBuilder: (context, i) {
              final item = state.commentsList[i];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(item.user.image ??
                              'https://images.pexels.com/photos/26926252/pexels-photo-26926252/free-photo-of-face-of-gorilla.jpeg'),
                          radius: 25,
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _buildCommentContent(item, i, context)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No comments found.'));
        }
      },
    );
  }

  Column _buildCommentContent(NewsCommentModel item, int index, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.user.name ?? "طالب", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(item.content, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 6),
        _buildCommentActions(index, item.createdAt.toString(), context),
      ],
    );
  }

  Row _buildCommentActions(int index, String date, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Row(
          children: [
            IconButton(
                icon: const Icon(Icons.edit, size: 16),
                onPressed: () => showEditCommentSheet(context, index)),
            IconButton(
                icon: const Icon(Icons.delete, size: 16),
                onPressed: () => confirmDeleteComment(context, index)),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Form(
        key: formKey,
        child: Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: commentController,
                sizeTextFiled: 12,
                hintText: AppLocalizations.of(context)!
                    .translate('wac'), // Adjust the hint text as needed
              ),
            ),
            IconButton(
  icon: Icon(Icons.send, color: Theme.of(context).colorScheme.secondary),
  onPressed: () {
    if (formKey.currentState!.validate()) {
      context.read<CommentsCubit>().addComment(
            widget.newsId, // Pass the actual newsId
            commentController.text, // Pass the comment content
          );
      commentController.clear();
      FocusScope.of(context).unfocus();
    }
  },
),

          ],
        ),
      ),
    );
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
      body: Column(
        children: [
          Expanded(child: _buildCommentList(context)),
          const SizedBox(height: 10),
          _buildCommentInput(context),
        ],
      ),
    );
  }
}

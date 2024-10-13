import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/format_data.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import '../../../../../cache/cache_helper.dart';
import '../../../data/model/news_comments_model.dart';
import '../../manger/comment_cubit/comment_cubit.dart';
import '../../manger/comment_cubit/comment_state.dart';

class CommentsPage extends StatefulWidget {
  final String newsId;

  const CommentsPage({super.key, required this.newsId});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<NewsCommentModel> comments = []; // Local comments list
          String id = CacheHelper().getData(key: 'user_Id');
          String name = CacheHelper().getData(key: 'user_name');

  @override
  void initState() {
    super.initState();
    // Fetch comments when the page initializes

print(id);
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
                  } else if (state is NewsCommentFetchSuccess) {
                    comments = state.comments; // Update local comments list

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
                  } else if (state is NewsCommentFailure) {
                    return Center(child: Text(state.error));
                  } else {
                    return const Center(child: Text('لا توجد تعليقات.'));
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
                hintText: 'اكتب تعليقًا...',
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
                final newComment = NewsCommentModel(user: UserModel(name: name , createdAt: DateTime.now()),
                  userId: 'current_user_id',
                  newsId: widget.newsId,
                  content: _commentController.text.trim(),
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                setState(() {
                  comments.add(newComment);
                });

                _commentController.clear();
                _focusNode.unfocus();
              }
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget buildCommentItem(BuildContext context, NewsCommentModel comment) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            CircleAvatar(
              radius: 18,
              child: comment.user?.image != null 
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: comment.user!.image!,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Text(
                        comment.user!.name != null 
                          ? comment.user!.name![0].toUpperCase() 
                          : '?', 
                        style: const TextStyle(fontSize: 16), // Adjust size as needed
                      ),
                      fit: BoxFit.cover, // Ensure the image covers the circle
                    ),
                  )
                : Text(
                    comment.user?.name != null 
                      ? comment.user!.name![0].toUpperCase() 
                      : '?', 
                    style: const TextStyle(fontSize: 16), // Adjust size as needed
                  ),
            ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                                                                                if (comment.isProfessor == 1) ...[
 


Container(
  padding: const EdgeInsets.all(6),
  decoration: BoxDecoration( 
   color: primaryColor,
    borderRadius: BorderRadius.circular(12)),
  child: Text('استاذ المادة' ,
   
    style: AppStyles.styleRegular12(context).copyWith(color: whiteColor),),) ,

    const SizedBox(width: 8,)
 
 ],
                            Text(
                              comment.user?.name ?? 'مستخدم',
                              style: AppStyles.styleMedium20(context),
                            ),
                          ],
                        ),

   
   

                        Text(
                          formatDate(comment.createdAt!, context),
                          style: AppStyles.styleMedium16(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.content ?? '',
                      style: AppStyles.styleMedium18(context),
                    ),
                  
                      Row(
                        children: [
                            if (comment.children.isNotEmpty) ...[
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
                          ),],
                          const Spacer(),


              if (comment.userId == id) 

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
          if (comment.isExpanded) // Show replies when expanded
            Padding(
              padding: const EdgeInsets.only(top: 8.0 , right: 50 , bottom: 8.0),
              child: Column(
                children: comment.children.map((reply) => buildCommentItem(context, reply)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context, NewsCommentModel comment) {
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
                  // Directly remove the comment from the list
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

  void _showEditDialog(BuildContext context, NewsCommentModel comment) {
    _commentController.text = comment.content ?? '';
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
              hintText: 'اكتب التعليق',
              hintStyle: AppStyles.styleMedium20(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _commentController.clear();
              },
              child: Text('إلغاء', style: AppStyles.styleMedium16(context)),
            ),
            TextButton(
              onPressed: () {
                if (_commentController.text.trim().isNotEmpty) {
                  setState(() {
                    comment.content = _commentController.text.trim(); // Update the comment content
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('حفظ', style: AppStyles.styleMedium16(context)),
            ),
          ],
        );
      },
    );
  }
}

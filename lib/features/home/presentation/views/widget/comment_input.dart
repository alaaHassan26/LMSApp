
import 'package:flutter/material.dart';

import 'package:lms/core/utils/appstyles.dart';
import '../../../data/model/news_comments_model.dart';


class CommentInputField extends StatefulWidget {
  final TextEditingController commentController;
  final FocusNode focusNode;
  final NewsCommentModel? replyToComment;
  final Function onSubmit;

  const CommentInputField({
    Key? key,
    required this.commentController,
    required this.focusNode,
    required this.replyToComment,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _CommentInputFieldState createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.replyToComment != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الرد على ${widget.replyToComment?.user?.name ?? ''}',
                    style: AppStyles.styleMedium18(context)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.onSubmit(); 
                  },
                ),
              ],
            ),
          ],
          Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: widget.focusNode,
                  controller: widget.commentController,
                  decoration: InputDecoration(
                    hintText: widget.replyToComment != null
                        ? 'الرد على ${widget.replyToComment!.user?.name}'
                        : 'اكتب تعليقًا...',
                    hintStyle: AppStyles.styleMedium20(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.onSubmit();
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/format_data.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import '../../../data/model/news_comments_model.dart';

class CommentItem extends StatefulWidget {
  final NewsCommentModel comment;
  final Function(NewsCommentModel) onReply;
  final Function(NewsCommentModel) onOptionsSelected;
  final String userId;

  const CommentItem({
    super.key,
    required this.comment,
    required this.onReply,
    required this.onOptionsSelected,
    required this.userId,
  });

  @override
  State<StatefulWidget> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.comment.isExpanded; // Initialize the local state
  }

  @override
  Widget build(BuildContext context) {
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
                child: widget.comment.user?.image != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: widget.comment.user!.image!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Text(
                            widget.comment.user!.name != null
                                ? widget.comment.user!.name![0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontSize: 16),
                          ),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Text(
                        widget.comment.user?.name != null
                            ? widget.comment.user!.name![0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontSize: 16),
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
                            if (widget.comment.isProfessor == 1) ...[
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  'استاذ المادة',
                                  style: AppStyles.styleRegular12(context)
                                      .copyWith(color: whiteColor),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.comment.user?.name ?? 'مستخدم',
                              style: AppStyles.styleMedium20(context),
                            ),
                          ],
                        ),
                        Text(
                          widget.comment.isProfessor == 5
                              ? 'جار الارسال'
                              : formatDate(widget.comment.createdAt!, context),
                          style: AppStyles.styleMedium16(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.comment.content ?? '',
                      style: AppStyles.styleMedium18(context),
                    ),
                    Row(
                      children: [
                        if (widget.comment.parentCommentId == null)
                          TextButton(
                            onPressed: () => widget.onReply(widget.comment),
                            child: Text(
                              'رد',
                              style: AppStyles.styleMedium16(context),
                            ),
                          ),
                        const SizedBox(width: 10),
                        if (widget.comment.children.isNotEmpty) ...[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isExpanded = !isExpanded; // Update local state
                                widget.comment.isExpanded =
                                    isExpanded; // Update the comment model
                              });
                            },
                            child: Text(
                              isExpanded ? 'اخفاء الردود' : 'عرض الردود',
                              style: AppStyles.styleMedium16(context),
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (widget.comment.userId == widget.userId)
                          IconButton(
                            onPressed: () =>
                                widget.onOptionsSelected(widget.comment),
                            icon: const Icon(Iconsax.menu),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isExpanded && widget.comment.children.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 50, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.comment.children
                    .map((reply) => CommentItem(
                          comment: reply,
                          onReply: widget.onReply,
                          onOptionsSelected: widget.onOptionsSelected,
                          userId: widget.userId,
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

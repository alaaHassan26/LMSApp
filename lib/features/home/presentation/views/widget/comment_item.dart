

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/functions/format_data.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/core/utils/colors.dart';
import '../../../data/model/news_comments_model.dart';

class CommentItem extends StatelessWidget {
  final NewsCommentModel comment;
  final Function(NewsCommentModel) onReply;
  final Function(NewsCommentModel) onOptionsSelected;
  final String userId;

  const CommentItem({
    Key? key,
    required this.comment,
    required this.onReply,
    required this.onOptionsSelected,
    required this.userId,
  }) : super(key: key);

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
                child: comment.user?.image != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: comment.user!.image!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Text(
                            comment.user!.name != null
                                ? comment.user!.name![0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontSize: 16),
                          ),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Text(
                        comment.user?.name != null
                            ? comment.user!.name![0].toUpperCase()
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
                            if (comment.isProfessor == 1) ...[
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
                              comment.user?.name ?? 'مستخدم',
                              style: AppStyles.styleMedium20(context),
                            ),
                          ],
                        ),
                        Text(
                          comment.isProfessor == 5
                              ? 'جار الارسال'
                              : formatDate(comment.createdAt!, context),
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
                        if (comment.parentCommentId == null)
                          TextButton(
                            onPressed: () => onReply(comment),
                            child: Text(
                              'رد',
                              style: AppStyles.styleMedium16(context),
                            ),
                          ),
                        const SizedBox(width: 10),
                        if (comment.children.isNotEmpty) ...[
                          TextButton(
                            onPressed: () {
                              comment.isExpanded = !comment.isExpanded;
                            },
                            child: Text(
                              comment.isExpanded
                                  ? 'اخفاء الردود'
                                  : 'عرض الردود',
                              style: AppStyles.styleMedium16(context),
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (comment.userId == userId)
                          IconButton(
                            onPressed: () => onOptionsSelected(comment),
                            icon: const Icon(Iconsax.menu),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comment.isExpanded && comment.children.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 50, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: comment.children
                    .map((reply) => CommentItem(
                          comment: reply,
                          onReply: onReply,
                          onOptionsSelected: onOptionsSelected,
                          userId: userId,
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

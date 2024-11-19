// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../cache/cache_helper.dart';
import '../../../data/model/news_comments_model.dart';
import '../../manger/CommentManger/add&replay_comment/add_comment_cubit.dart';
import '../../manger/CommentManger/add&replay_comment/add_comment_state.dart';
import '../../manger/CommentManger/edit_comment/edit_comment_cubit.dart';
import '../../manger/CommentManger/edit_comment/edit_comment_state.dart';
import '../../manger/CommentManger/fetchcomment_cubit/comment_cubit.dart';
import '../../manger/CommentManger/fetchcomment_cubit/comment_state.dart';
import '../../manger/CommentManger/delete_comment&replay/delete_comment_cubit.dart';
import '../../manger/CommentManger/delete_comment&replay/delete_comment_state.dart';
import 'comment_input.dart';
import 'comment_item.dart';

class CommentsPage extends StatefulWidget {
  final String newsId;

  const CommentsPage({super.key, required this.newsId});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  StreamSubscription? _subscription;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final ScrollController _scrollController;
  // List<NewsCommentModel> comments = [];
  final GlobalKey<LiquidPullToRefreshState> _refreshKey =
      GlobalKey<LiquidPullToRefreshState>();

  String id = CacheHelper().getData(key: 'user_Id');
  String name = CacheHelper().getData(key: 'user_name');
  NewsCommentModel? _replyToComment;
  int skip = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context
        .read<NewsCommentCubit>()
        .getComments(newsId: widget.newsId, skip: skip, context: context);
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            0.7 * _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });
      skip++;
      await BlocProvider.of<NewsCommentCubit>(context)
          .getComments(skip: skip, newsId: widget.newsId, context: context);

      // في حال وجود خطأ أثناء التمرير، إخفاء مؤشر التحميل بعد 3 ثوانٍ
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    _subscription?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  void _onClose() {
    setState(() {
      _replyToComment = null;
      _commentController.clear();
      _focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => AddCommentCubit(),
      child: Scaffold(
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
                    final cubit = context.read<NewsCommentCubit>();
                    final comments = cubit.allComments;
                    if (cubit.isInitialLoading && comments.isEmpty) {
                      return Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: isDarkMode ? Colors.white : Colors.black,
                          size: 56,
                        ),
                      );
                    } else {
                      return LiquidPullToRefresh(
                        key: _refreshKey,
                        height: 80,
                        color: const Color(0xffC0B7EF),
                        animSpeedFactor: 1,
                        showChildOpacityTransition: false,
                        onRefresh: () async {
                          skip = 0;
                          await context.read<NewsCommentCubit>().refreshNews(
                              context: context, newsId: widget.newsId);
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              comments.length + (cubit.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < comments.length) {
                              return Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  child: CommentItem(
                                    comment: comments[index],
                                    onReply: (comment) {
                                      setState(() {
                                        _replyToComment = comment;
                                      });
                                    },
                                    onOptionsSelected: (comment) {
                                      _showOptionsDialog(context, comment);
                                    },
                                    userId: id,
                                  ),
                                ),
                              );
                            } else {
                              // مؤشر التحميل في نهاية التمرير
                              return Padding(
                                padding: isLoading
                                    ? const EdgeInsets.symmetric(vertical: 20)
                                    : const EdgeInsets.symmetric(vertical: 0),
                                child: Center(
                                  child: isLoading
                                      ? LoadingAnimationWidget
                                          .staggeredDotsWave(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          size: 36,
                                        )
                                      : const SizedBox
                                          .shrink(), // إخفاء مؤشر التحميل إذا لم يكن هناك تحميل
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
              CommentInputField(
                onClose: _onClose, // Pass the onClose function

                commentController: _commentController,
                focusNode: _focusNode,
                replyToComment: _replyToComment,
                onSubmit: _submitComment,
              ),
            ],
          ),
        ),
      ),
    );
  }

//NOTE - ابو حسون هذا الدايلوغ مالت التعديل والحذف
  void _showOptionsDialog(BuildContext context, NewsCommentModel comment) {
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
                  removeComment(comment);

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

//NOTE - هذا الحذف

  void removeComment(NewsCommentModel comment) {
    final cubit = context.read<NewsCommentCubit>();
    final comments = cubit.allComments;
    setState(() {
      if (comment.parentCommentId != null) {
        context.read<DeleteCommentCubit>().deleteReplay(comment.id!);

        _subscription =
            context.read<DeleteCommentCubit>().stream.listen((state) {
          if (state is DeleteCommentLoading) {
            print('wait');
          } else if (state is DeleteCommentSuccess) {
            setState(() {
              _removeReplyFromParent(comment);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حذف الرد بنجاح!'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is DeleteCommentFailure) {
            print(state.error);
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.error),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        });
      } else {
        context.read<DeleteCommentCubit>().deleteComment(comment.id!);

        _subscription =
            context.read<DeleteCommentCubit>().stream.listen((state) {
          if (state is DeleteCommentLoading) {
            print('wait');
          } else if (state is DeleteCommentSuccess) {
            // _refreshKey.currentState?.show();
            setState(() {
              comments.remove(comment);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حذف التعليق بنجاح!'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is DeleteCommentFailure) {
            print(state.error);
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.error),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        });
      }
    });
  }

  void _removeReplyFromParent(NewsCommentModel reply) {
    final cubit = context.read<NewsCommentCubit>();
    final comments = cubit.allComments;
    for (var parentComment in comments) {
      if (_removeReplyRecursive(parentComment, reply)) {
        print(reply);

        break;
      }
    }
  }

  bool _removeReplyRecursive(NewsCommentModel parent, NewsCommentModel reply) {
    if (parent.children.contains(reply)) {
      parent.children.remove(reply);
      return true;
    }

    for (var child in parent.children) {
      if (_removeReplyRecursive(child, reply)) {
        return true;
      }
    }

    return false;
  }

  //NOTE - منا اضافة التعليق

  void _submitComment() {
    if (_commentController.text.trim().isNotEmpty) {
      final content = _commentController.text.trim();

      if (_replyToComment != null) {
        print(_replyToComment!.id!);
        context
            .read<AddCommentCubit>()
            .addReply(widget.newsId, content, _replyToComment!.id!);
      } else {
        context.read<AddCommentCubit>().addComment(widget.newsId, content);
      }

      _subscription = context.read<AddCommentCubit>().stream.listen((state) {
        if (!mounted) return;

        final newComment = NewsCommentModel(
          user: UserModel(name: name, createdAt: DateTime.now()),
          userId: id,
          newsId: widget.newsId,
          content: content,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          parentCommentId: _replyToComment?.id,
          isProfessor: 5,
        );
        // comments.add(newComment);

        _commentController.clear();
        _focusNode.unfocus();

        setState(() {
          if (_replyToComment != null) {
            _addReplyToParent(_replyToComment!, newComment);
          }
          _replyToComment = null;
        });

        if (state is AddCommentSuccess) {
          // استدعاء LiquidPullToRefresh تلقائيًا
          _refreshKey.currentState?.show();
        } else if (state is AddCommentFailure) {
          print(state.error);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(state.error),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }

  void _addReplyToParent(NewsCommentModel parent, NewsCommentModel reply) {
    if (parent.parentCommentId != null) {
      // for (var comment in comments) {
      //   if (comment.id == parent.parentCommentId) {
      //     _addReplyToParent(comment, reply);
      //     return;
      //   }
      // }
    } else {
      parent.children.add(reply);
    }
  }

//NOTE - ابو حسون هذا الدايلوغ مالت تعديل التعليق

  void _showEditDialog(BuildContext context, NewsCommentModel comment) {
    _commentController.text = comment.content ?? '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'تعديل التعليق',
            style: AppStyles.styleMedium20(context),
          ),
          content: TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              child: Text('الغاء', style: AppStyles.styleMedium16(context)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('تعديل', style: AppStyles.styleMedium16(context)),
              onPressed: () {
                context
                    .read<EditCommentCubit>()
                    .editComment(comment.id!, _commentController.text);

                _subscription =
                    context.read<EditCommentCubit>().stream.listen((state) {
                  if (!mounted) return;

                  if (state is EditCommentSuccess) {
                    setState(() {
                      comment.content = _commentController.text;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم تعديل التعليق بنجاح!'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    _commentController.clear();
                    _focusNode.unfocus();

                    Navigator.pop(context);
                  } else if (state is EditCommentFailure) {
                    print(state.error);

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text(state.error),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lms/core/utils/app_localiizations.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/appstyles.dart';
import 'package:lms/features/home/presentation/manger/pdf_cubit/pdf_cubit.dart';
import 'package:lms/features/home/presentation/manger/pdf_cubit/pdf_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DownloadPdfPage extends StatefulWidget {
  final String pdfUrl;
  final String pdfName;

  const DownloadPdfPage(
      {super.key, required this.pdfUrl, required this.pdfName});

  @override
  State<StatefulWidget> createState() => _DownloadPdfPageState();
}

class _DownloadPdfPageState extends State<DownloadPdfPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => PDFViewerCubit()..checkIfDownloaded(widget.pdfUrl),
      child: BlocBuilder<PDFViewerCubit, PDFViewerState>(
        builder: (context, state) {
          if (state is PDFProgress) {
            return ListTile(
              leading: LoadingAnimationWidget.discreteCircle(
                color: Theme.of(context).colorScheme.onPrimary,
                size: 46,
              ),
              title: Text(
                '${widget.pdfName} (${state.progress}%)',
                style: AppStyles.styleMedium20(context),
              ),
              subtitle: SizedBox(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  AppLocalizations.of(context)!.translate('download_pdf'),
                  style: AppStyles.styleMedium16(context),
                ),
              ),
            );
          } else if (state is PDFLoaded) {
            return ListTile(
              leading: SvgPicture.asset(
                'assets/images/imagpdf.svg',
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
              ),
              title: Text(
                widget.pdfName,
                style: AppStyles.styleMedium20(context),
              ),
              subtitle: Text(
                AppLocalizations.of(context)!.translate('pdf_loaded'),
                style: AppStyles.styleMedium16(context),
              ),
              onTap: () {
                GoRouter.of(context)
                    .push(AppRouter.kPDFViewerPage, extra: state.filePath);
              },
              trailing: IconButton(
                onPressed: () {
                  final pdfCubit = context.read<PDFViewerCubit>();
                  _showOptionsDialog(
                      context, pdfCubit, state.filePath, widget.pdfUrl);
                },
                icon: const Icon(Iconsax.menu),
              ),
            );
          } else if (state is PDFError) {
            return ListTile(
                leading: SvgPicture.asset(
                  'assets/images/error.svg',
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.15,
                ),
                title: Text(
                  widget.pdfName,
                  style: AppStyles.styleMedium20(context),
                ),
                subtitle: Text(
                  'Error',
                  style: AppStyles.styleMedium16(context),
                ),
                trailing: IconButton(
                    onPressed: () {
                      context
                          .read<PDFViewerCubit>()
                          .downloadAndSavePDF(widget.pdfUrl);
                    },
                    icon: const Icon(Iconsax.document_download)));
          }

          return ListTile(
              leading: GestureDetector(
                onTap: () {
                  context
                      .read<PDFViewerCubit>()
                      .downloadAndSavePDF(widget.pdfUrl);
                },
                child: SvgPicture.asset(
                  'assets/images/imagpdf.svg',
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.15,
                ),
              ),
              title: Text(
                widget.pdfName,
                style: AppStyles.styleMedium20(context),
              ),
              trailing: IconButton(
                  onPressed: () {
                    context
                        .read<PDFViewerCubit>()
                        .downloadAndSavePDF(widget.pdfUrl);
                  },
                  icon: const Icon(Iconsax.document_download)));
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _showOptionsDialog(BuildContext context, PDFViewerCubit pdfCubit,
      String filePath, String pdfUrl) {
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
                leading: const Icon(Iconsax.folder_open),
                title: Text(
                  AppLocalizations.of(context)!.translate('open_file'),
                  style: AppStyles.styleMedium16(context),
                ),
                onTap: () {
                  Navigator.pop(context);
                  GoRouter.of(context)
                      .push(AppRouter.kPDFViewerPage, extra: filePath);
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.trash),
                title: Text(
                  AppLocalizations.of(context)!.translate('delete_file'),
                  style: AppStyles.styleMedium16(context),
                ),
                onTap: () {
                  Navigator.pop(context); // إغلاق الـ Dialog
                  pdfCubit.deletePDF(pdfUrl);
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
                style: AppStyles.styleMedium16(context).copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

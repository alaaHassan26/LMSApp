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
              subtitle: Text(
                AppLocalizations.of(context)!.translate('download_pdf'),
                style: AppStyles.styleMedium16(context),
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
                    GoRouter.of(context)
                        .push(AppRouter.kPDFViewerPage, extra: state.filePath);
                  },
                  icon: const Icon(Iconsax.folder_open)),
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
                  'assets/images/downloadpdf.svg',
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
}

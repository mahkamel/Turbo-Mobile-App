import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:turbo/core/widgets/widget_with_header.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../flavors.dart';

class SelectFile extends StatefulWidget {
  final String header;
  final void Function(
    List<PlatformFile?> files,
    bool isSingleFile,
  ) onFileSelected;
  final void Function() onPrefixClicked;
  final bool isWarningToReplace;
  final bool isFromMyApplication;
  final bool isFromPending;
  final EdgeInsetsDirectional? padding;
  final double? marginBottom;
  final File? file;
  final List<PlatformFile>? files;
  final String paths;
  final bool isShowDeleteFile;
  final bool isShowReplaceWithoutBorder;
  final String prefixImgPath;
  final double? width;
  final Widget? prefixIcon;
  final int fileStatus;
  final bool isUploading;
  final bool isNullAttachment;

  const SelectFile({
    super.key,
    required this.header,
    required this.onFileSelected,
    required this.onPrefixClicked,
    this.isWarningToReplace = false,
    this.isFromMyApplication = false,
    this.isFromPending = false,
    this.isShowReplaceWithoutBorder = false,
    this.padding,
    this.marginBottom,
    this.file,
    this.width,
    this.prefixIcon,
    this.paths = "",
    this.isShowDeleteFile = false,
    this.files,
    required this.fileStatus,
    this.prefixImgPath = "assets/images/icons/pdf_file.png",
    this.isUploading = false,
    this.isNullAttachment = false,
  });

  @override
  State<SelectFile> createState() => _SelectFileState();
}

class _SelectFileState extends State<SelectFile> {
  File? _file;
  List<PlatformFile> files = [];
  String filesName = "";

  @override
  void initState() {
    if (widget.file != null) {
      setState(() {
        _file = widget.file;
      });
    }
    if (widget.files != null) {
      setState(() {
        files = widget.files!;
      });
    }
    if (widget.paths.isNotEmpty) {
      filesName = widget.header;
    }
    super.initState();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.first.path!);
        files = result.files;
        filesName = widget.header;
      });
      widget.onFileSelected(result.files, result.isSinglePick);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetWithHeader(
      width: widget.width,
      key: Key(widget.header),
      padding: widget.padding ??
          const EdgeInsetsDirectional.symmetric(horizontal: 18.0),
      header: widget.header,
      widget: InkWell(
        onTap: () {
          if (!(_file != null || widget.paths.isNotEmpty)) {
            pickFile();
          } else if ((widget.isFromMyApplication ||
              (widget.isFromPending && widget.paths.isNotEmpty))) {
            widget.onPrefixClicked();
            if (widget.paths.isNotEmpty && !widget.isWarningToReplace) {
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return DisplayDocumentsDialog(
                    paths: [widget.paths],
                  );
                },
              );
            }
          } else {
            pickFile();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: (_file != null || widget.paths.isNotEmpty)
                ? AppColors.white
                : AppColors.locationBlue,
            borderRadius: BorderRadius.circular(20),
            border: (_file != null || widget.paths.isNotEmpty)
                ? Border.all(
                    color: widget.isWarningToReplace || widget.fileStatus == 2
                        ? AppColors.errorRed
                        : widget.fileStatus == 1
                            ? AppColors.green
                            : AppColors.greyBorder)
                : null,
          ),
          height: (_file != null || widget.paths.isNotEmpty) ? 74 : 40,
          width: (_file != null || widget.paths.isNotEmpty)
              ? AppConstants.screenWidth(context)
              : 180,
          child: (_file != null || widget.paths.isNotEmpty)
              ? Row(
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    SvgPicture.asset(widget.fileStatus == 1
                        ? "assets/images/icons/approved_file.svg"
                        : widget.isWarningToReplace || widget.fileStatus == 2
                            ? "assets/images/icons/error_file.svg"
                            : "assets/images/icons/uploading_file.svg"),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        filesName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.inter15Black400,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.only(
                          right: ((widget.isFromMyApplication ||
                                          widget.isFromPending) &&
                                      widget.isWarningToReplace) ||
                                  (widget.isFromMyApplication ||
                                      (widget.isFromPending &&
                                          widget.paths.isNotEmpty))
                              ? 8
                              : 0),
                      onPressed: () async {
                        if (widget.isUploading) {
                        } else if (widget.fileStatus == 4) {
                          widget.onPrefixClicked();
                        } else if (!(widget.isFromMyApplication ||
                                (widget.isFromPending &&
                                    widget.paths.isNotEmpty)) ||
                            (widget.isShowDeleteFile)) {
                          setState(() {
                            _file = null;
                            files = [];
                            filesName = "";
                          });
                          widget.onPrefixClicked();
                        } else if (widget.isWarningToReplace ||
                            widget.isShowReplaceWithoutBorder) {
                          widget.onPrefixClicked();
                          pickFile();
                        } else if ((widget.isFromMyApplication ||
                            (widget.isFromPending &&
                                widget.paths.isNotEmpty))) {
                          widget.onPrefixClicked();
                          if (widget.paths.isNotEmpty &&
                              !widget.isWarningToReplace) {
                            showAdaptiveDialog(
                              context: context,
                              builder: (context) {
                                return DisplayDocumentsDialog(
                                  paths: [widget.paths],
                                );
                              },
                            );
                          }
                        } else {
                          widget.onPrefixClicked();
                        }
                      },
                      icon: widget.isUploading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : widget.fileStatus == 4
                              ? const Icon(
                                  Icons.upload,
                                  color: AppColors.primaryBlue,
                                )
                              : widget.prefixIcon != null
                                  ? widget.prefixIcon!
                                  : (widget.isFromMyApplication ||
                                                  widget.isFromPending) &&
                                              widget.isWarningToReplace ||
                                          widget.isShowReplaceWithoutBorder
                                      ? Icon(
                                          Icons.replay_rounded,
                                          color:
                                              widget.isShowReplaceWithoutBorder
                                                  ? AppColors.removeGrey
                                                  : AppColors.errorRed,
                                        )
                                      : (widget.isFromMyApplication ||
                                              (widget.isFromPending &&
                                                      widget
                                                          .paths.isNotEmpty) &&
                                                  !widget.isShowDeleteFile)
                                          ? const Icon(
                                              Icons.open_in_new_rounded,
                                              color: AppColors.green,
                                            )
                                          : const Icon(
                                              Icons.delete_rounded,
                                              color: AppColors.errorRed,
                                            ),
                    ),
                  ],
                )
              : Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.cloud_upload_rounded,
                      color: AppColors.white,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Upload Document ",
                      style: AppFonts.ibm14LightBlack400.copyWith(
                        color: AppColors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class DisplayDocumentsDialog extends StatelessWidget {
  const DisplayDocumentsDialog({
    super.key,
    required this.paths,
  });

  final List<String> paths;
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: AppConstants.screenWidth(context) - 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (paths.length == 1 &&
                          (paths[0].toLowerCase().endsWith(".jpg") ||
                              paths[0].toLowerCase().endsWith(".jpeg") ||
                              paths[0].toLowerCase().endsWith(".png")))
                        Image.network(
                          "${FlavorConfig.instance.filesBaseUrl}${paths[0]}",
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress != null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return child;
                            }
                          },
                        ),
                      if (paths.length == 1 &&
                          paths[0].toLowerCase().endsWith(".pdf"))
                        Expanded(
                          child: const PDF(
                            swipeHorizontal: true,
                            enableSwipe: true,
                            fitPolicy: FitPolicy.BOTH,
                          ).cachedFromUrl(
                            '${FlavorConfig.instance.filesBaseUrl}${paths[0]}',
                            placeholder: (progress) =>
                                Center(child: Text('$progress %')),
                            errorWidget: (error) {
                              return Center(child: Text(error.toString()));
                            },
                          ),
                        ),
                      if (paths.length > 1)
                        Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close,
                              ),
                            )),
                      if (paths.length > 1)
                        Expanded(
                          child: Scrollbar(
                            controller: scrollController,
                            trackVisibility: true,
                            thumbVisibility: true,
                            interactive: true,
                            thickness: 6,
                            child: ListView.separated(
                              controller: scrollController,
                              itemCount: paths.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 16,
                              ),
                              itemBuilder: (context, index) {
                                if (paths[index]
                                    .toLowerCase()
                                    .endsWith(".pdf")) {
                                  return SizedBox(
                                    height: 350,
                                    child: const PDF(
                                      swipeHorizontal: true,
                                      enableSwipe: true,
                                      fitPolicy: FitPolicy.BOTH,
                                    ).cachedFromUrl(
                                      '${FlavorConfig.instance.filesBaseUrl}${paths[0]}',
                                      placeholder: (progress) =>
                                          Center(child: Text('$progress %')),
                                      errorWidget: (error) {
                                        return Center(
                                            child: Text(error.toString()));
                                      },
                                    ),
                                  );
                                } else {
                                  return Image.network(
                                    "${FlavorConfig.instance.filesBaseUrl}${paths[index]}",
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress != null) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return child;
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<File>> convertPlatformFileList(
    List<PlatformFile?> platformFiles) async {
  List<File> files = [];
  for (PlatformFile? platformFile in platformFiles) {
    if (platformFile != null) {
      File file = File(platformFile.path!);
      files.add(file);
    }
  }
  return files;
}

Future<File?> convertPlatformFile(PlatformFile? platformFile) async {
  if (platformFile != null) {
    return File(platformFile.path!);
  }
  return null;
}

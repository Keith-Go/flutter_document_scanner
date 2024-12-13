// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: unused_element

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/app/app.dart';
import 'package:flutter_document_scanner/src/ui/widgets/button_take_photo.dart';
import 'package:flutter_document_scanner/src/utils/take_photo_document_style.dart';

/// Page to take a photo
class TakePhotoDocumentPage extends StatefulWidget {
  /// Create a page with style
  const TakePhotoDocumentPage({
    super.key,
    required this.takePhotoDocumentStyle,
    required this.initialCameraLensDirection,
    required this.resolutionCamera,
  });

  /// Style of the page
  final TakePhotoDocumentStyle takePhotoDocumentStyle;

  /// Camera library [CameraLensDirection]
  final CameraLensDirection initialCameraLensDirection;

  /// Camera library [ResolutionPreset]
  final ResolutionPreset resolutionCamera;

  @override
  State<TakePhotoDocumentPage> createState() => _TakePhotoDocumentPageState();
}

class _TakePhotoDocumentPageState extends State<TakePhotoDocumentPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppBloc>().add(
            AppCameraInitialized(
              cameraLensDirection: widget.initialCameraLensDirection,
              resolutionCamera: widget.resolutionCamera,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppBloc, AppState, AppStatus>(
      selector: (state) => state.statusCamera,
      builder: (context, state) {
        switch (state) {
          case AppStatus.initial:
            return Container();

          case AppStatus.loading:
            return widget.takePhotoDocumentStyle.onLoading;

          case AppStatus.success:
            return _CameraPreview(
              takePhotoDocumentStyle: widget.takePhotoDocumentStyle,
            );

          case AppStatus.failure:
            return Container();
        }
      },
    );
  }
}

class _CameraPreview extends StatelessWidget {
  const _CameraPreview({
    required this.takePhotoDocumentStyle,
  });

  final TakePhotoDocumentStyle takePhotoDocumentStyle;

  @override
  Widget build(BuildContext context) {
    final mediaSize = Size(
      MediaQuery.of(context).size.width -
          takePhotoDocumentStyle.left -
          takePhotoDocumentStyle.right,
      MediaQuery.of(context).size.height -
          takePhotoDocumentStyle.top -
          takePhotoDocumentStyle.bottom,
    );
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        context.read<AppBloc>().add(
              AppSizeCameraSaved(size: mediaSize),
            );
      },
      buildWhen: (previous, current) =>
          previous.cameraController != current.cameraController,
      builder: (context, state) {
        if (state.cameraController == null) {
          return const Center(
            child: Text(
              'No Camera',
            ),
          );
        }

        final deviceRatio = mediaSize.aspectRatio;
        final cameraAspectRatio = state.cameraController!.value.aspectRatio;

        final maxWidth = deviceRatio > cameraAspectRatio
            ? mediaSize.width
            : mediaSize.height * cameraAspectRatio;
        final maxHeight = deviceRatio > cameraAspectRatio
            ? mediaSize.width / cameraAspectRatio
            : mediaSize.height;

        return Stack(
          fit: StackFit.expand,
          children: [
            // * Camera
            Positioned(
              top: takePhotoDocumentStyle.top,
              bottom: takePhotoDocumentStyle.bottom,
              left: takePhotoDocumentStyle.left,
              right: takePhotoDocumentStyle.right,
              child: Center(
                child: OverflowBox(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  child: takePhotoDocumentStyle.filterWidget
                          ?.call(CameraPreview(state.cameraController!)) ??
                      CameraPreview(state.cameraController!),
                ),
              ),
            ),

            // * children
            if (takePhotoDocumentStyle.children != null)
              ...takePhotoDocumentStyle.children!,

            /// Default
            ButtonTakePhoto(
              takePhotoDocumentStyle: takePhotoDocumentStyle,
            ),
          ],
        );
      },
    );
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  const _MediaSizeClipper(this.mediaSize);
  final Size mediaSize;
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

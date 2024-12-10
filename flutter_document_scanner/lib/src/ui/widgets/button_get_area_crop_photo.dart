// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_document_scanner/src/bloc/crop/crop.dart';
import 'package:flutter_document_scanner/src/models/area.dart';

class ButtonGetAreaCropPhoto extends StatelessWidget {
  const ButtonGetAreaCropPhoto({
    super.key,
    required this.onChangeArea,
    required this.image,
    required this.model,
  });

  final GetAreaCropPhotoModel model;
  final void Function(Area area) onChangeArea;
  final File image;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Expanded(
        child: InkWell(
          onTap: () async {
            onChangeArea(
              await context.read<CropBloc>().getAreaInOriginalSize(image),
            );
            model.onPressedChild?.call();
          },
          child: model.child,
        ),
      ),
      ...model.ortherChilds,
    ];
    return Positioned(
      top: model.position.top,
      bottom: model.position.bottom,
      left: model.position.left,
      right: model.position.right,
      child: model.isRow ? Row(children: children) : Column(children: children),
    );
  }
}

class PositionModel {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  PositionModel({
    this.top,
    this.bottom,
    this.left,
    this.right,
  });
}

class GetAreaCropPhotoModel {
  final Widget child;
  final PositionModel position;
  final VoidCallback? onPressedChild;
  final bool isRow;
  final List<Widget> ortherChilds;

  GetAreaCropPhotoModel({
    required this.child,
    required this.position,
    this.onPressedChild,
    this.isRow = true,
    this.ortherChilds = const [],
  });
}

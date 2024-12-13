// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Area composed of 4 points
class Area extends Equatable {
  /// Create a new area
  const Area({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    this.height,
    this.width,
    this.dashSpace = 0,
  });

  /// The top left dot
  final Point<double> topLeft;

  /// The top right dot
  final Point<double> topRight;

  /// The bottom left dot
  final Point<double> bottomLeft;

  /// The bottom right dot
  final Point<double> bottomRight;

  /// Size of image
  final double? height;
  final double? width;

  final double dashSpace;

  @override
  List<Object?> get props => [
        topLeft,
        topRight,
        bottomLeft,
        bottomRight,
        height,
        width,
        dashSpace,
      ];

  /// Creates a copy of this Area but with the given fields replaced with
  /// the new values.
  Area copyWith({
    Point<double>? topLeft,
    Point<double>? topRight,
    Point<double>? bottomLeft,
    Point<double>? bottomRight,
    double? height,
    double? width,
    double? dashSpace,
  }) {
    return Area(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
      height: height ?? this.height,
      width: width ?? this.width,
      dashSpace: dashSpace ?? this.dashSpace,
    );
  }

  Area rescale(double newHeight, double newWidth) {
    final scaleX = newWidth / (width ?? 1);
    final scaleY = newHeight / (height ?? 1);

    double calulateSize(double scale, double size) {
      return size - (size - size * scale);
    }

    return Area(
      topLeft: Point(
        calulateSize(scaleX, topLeft.x) + dashSpace,
        calulateSize(scaleY, topLeft.y),
      ),
      topRight: Point(
        calulateSize(scaleX, topRight.x) - dashSpace,
        calulateSize(scaleY, topRight.y),
      ),
      bottomLeft: Point(
        calulateSize(scaleX, bottomLeft.x) + dashSpace,
        calulateSize(scaleY, bottomLeft.y),
      ),
      bottomRight: Point(
        calulateSize(scaleX, bottomRight.x) - dashSpace,
        calulateSize(scaleY, bottomRight.y),
      ),
      height: newHeight,
      width: newWidth,
    );
  }

  Area scaleWithCamera(
    Size mediaSize,
    double cameraAspectRatio,
    Size imageSize,
  ) {
    // return this;
    final deviceRatio = mediaSize.aspectRatio;
    final double previewWidth = deviceRatio > cameraAspectRatio
        ? 0
        : ((mediaSize.height / cameraAspectRatio) - mediaSize.width) / 2;

    final double previewHeight = deviceRatio > cameraAspectRatio
        ? ((mediaSize.width * cameraAspectRatio) - mediaSize.height) / 2
        : 0;

    final size = Size(
      deviceRatio > cameraAspectRatio
          ? mediaSize.width
          : mediaSize.height / cameraAspectRatio,
      deviceRatio > cameraAspectRatio
          ? mediaSize.width * cameraAspectRatio
          : mediaSize.height,
    );

    double calulateSize(
      double previewSize,
      double size,
    ) {
      return size + previewSize;
    }

    print(
      'previewWidth: $previewWidth - previewHeight: $previewHeight - size: $size',
    );

    return Area(
      topLeft: Point(
        topLeft.x,
        topLeft.y,
      ),
      topRight: Point(
        topRight.x,
        topRight.y,
      ),
      bottomLeft: Point(
        bottomLeft.x,
        bottomLeft.y,
      ),
      bottomRight: Point(
        bottomRight.x,
        bottomRight.y,
      ),
      // topLeft: Point(
      //   calulateSize(previewWidth, topLeft.x),
      //   calulateSize(previewHeight, topLeft.y),
      // ),
      // topRight: Point(
      //   calulateSize(-previewWidth, topRight.x),
      //   calulateSize(previewHeight, topRight.y),
      // ),
      // bottomLeft: Point(
      //   calulateSize(previewWidth, bottomLeft.x),
      //   calulateSize(-previewHeight, bottomLeft.y),
      // ),
      // bottomRight: Point(
      //   calulateSize(-previewWidth, bottomRight.x),
      //   calulateSize(-previewHeight, bottomRight.y),
      // ),
      height: height,
      width: width,
      dashSpace: previewWidth - 5,
    );
  }
}

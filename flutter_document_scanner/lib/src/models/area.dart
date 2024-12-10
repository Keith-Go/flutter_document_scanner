// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';

import 'package:equatable/equatable.dart';

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

  @override
  List<Object?> get props => [
        topLeft,
        topRight,
        bottomLeft,
        bottomRight,
        height,
        width,
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
  }) {
    return Area(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
      height: height ?? this.height,
      width: width ?? this.width,
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
        calulateSize(scaleX, topLeft.x),
        calulateSize(scaleY, topLeft.y),
      ),
      topRight: Point(
        calulateSize(scaleX, topRight.x),
        calulateSize(scaleY, topRight.y),
      ),
      bottomLeft: Point(
        calulateSize(scaleX, bottomLeft.x),
        calulateSize(scaleY, bottomLeft.y),
      ),
      bottomRight: Point(
        calulateSize(scaleX, bottomRight.x),
        calulateSize(scaleY, bottomRight.y),
      ),
      height: newHeight,
      width: newWidth,
    );
  }
}

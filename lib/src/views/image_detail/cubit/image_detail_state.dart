import 'package:equatable/equatable.dart';

/// 🖼️ **Image Detail State**
///
/// Copyright (c) 2026, MasterFabric
/// https://github.com/masterfabric-mobile/masterfabric_core
///
/// State management for Image Detail Cubit
///
/// {@category States}
/// {@subCategory ImageDetailState}

/// 🖼️ Image detail state class
class ImageDetailState extends Equatable {
  final String imageUrl;
  final String? title;

  const ImageDetailState({
    required this.imageUrl,
    this.title,
  });

  /// Create a copy of this state with some fields changed
  ImageDetailState copyWith({
    String? imageUrl,
    String? title,
  }) {
    return ImageDetailState(
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [imageUrl, title];

  @override
  String toString() {
    return 'ImageDetailState('
        'imageUrl: $imageUrl, '
        'title: $title'
        ')';
  }
}

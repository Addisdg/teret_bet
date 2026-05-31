import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoryImage extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit fit;

  const StoryImage({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, __, ___) => const _MissingImageIcon(),
      );
    }

    if (imagePath.isEmpty) {
      return const _MissingImageIcon();
    }

    return CachedNetworkImage(
      imageUrl: imagePath,
      height: height,
      width: width,
      fit: fit,
      placeholder: (_, __) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (_, __, ___) => const _MissingImageIcon(),
    );
  }
}

class _MissingImageIcon extends StatelessWidget {
  const _MissingImageIcon();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.image, size: 56),
    );
  }
}

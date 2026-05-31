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
    return LayoutBuilder(
      builder: (context, constraints) {
        final cacheWidth = _cacheWidthFor(context, constraints.maxWidth);

        return _buildImage(cacheWidth);
      },
    );
  }

  Widget _buildImage(int? cacheWidth) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        cacheWidth: cacheWidth,
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
      memCacheWidth: cacheWidth,
      placeholder: (_, __) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (_, __, ___) => const _MissingImageIcon(),
    );
  }

  int? _cacheWidthFor(BuildContext context, double maxWidth) {
    if (!maxWidth.isFinite || maxWidth <= 0) {
      return null;
    }

    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    return (maxWidth * devicePixelRatio).round();
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

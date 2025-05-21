import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homestay_app/src/themes/extensions.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        progressIndicatorBuilder: (context, url, progress) {
          return Center(
            child: CircularProgressIndicator(
              value: progress.progress,
              strokeWidth: 2,
              color: context.theme.colorScheme.secondary,
            ),
          );
        },
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.error_outline,
            size: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
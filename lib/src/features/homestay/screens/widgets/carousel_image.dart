import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarouselImage extends StatefulWidget {
  final List<String> imageUrls;
  const CarouselImage({super.key, required this.imageUrls});

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int _currentPage = 0;

  int get _imageCount => widget.imageUrls.length;

  bool get _useCollageLayout => _imageCount >= 4;

  int get _pageViewItemCount {
    if (_imageCount == 0) return 0;
    return _useCollageLayout ? (1 + _imageCount) : _imageCount;
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Widget _buildCachedNetworkImage(
    String imageUrl, {
    BoxFit fit = BoxFit.cover,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder:
          (context, url) => Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey.shade400,
            ),
          ),
      errorWidget:
          (context, url, error) => Container(
            color: Colors.grey.shade300,
            child: const Icon(Icons.error_outline, color: Colors.red),
          ),
    );
  }

  Widget _buildImagePage(String imageUrl) {
    return _buildCachedNetworkImage(imageUrl);
  }

  Widget _buildCollageView() {
    if (widget.imageUrls.length < 4) {
      // This case should ideally be prevented by _useCollageLayout check
      return const Center(child: Text("Not enough images for collage"));
    }

    const double spacing = 2.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: spacing),
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: _buildCachedNetworkImage(widget.imageUrls[0]),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: spacing),
                  child: ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: _buildCachedNetworkImage(widget.imageUrls[1]),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: spacing),
                        child: ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: _buildCachedNetworkImage(widget.imageUrls[2]),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.zero,
                        child: _buildCachedNetworkImage(widget.imageUrls[3]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageCountIndicator(BuildContext context) {
    String text;
    IconData iconData;

    if (_useCollageLayout && _currentPage == 0) {
      // Collage view is active
      iconData = Icons.photo_outlined; // Or Icons.collections
      text = "$_imageCount";
    } else {
      // Single image view is active
      iconData = Icons.photo_outlined;
      int displayedIndex;
      if (_useCollageLayout) {
        // In collage mode, page 0 is collage, page 1 is imageUrls[0]
        displayedIndex =
            _currentPage; // _currentPage is already 1-based for images after collage
      } else {
        // In normal mode, page 0 is imageUrls[0]
        displayedIndex = _currentPage + 1;
      }
      text = "$displayedIndex/$_imageCount";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).colorScheme.primary.withAlpha(120),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_imageCount == 0) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.grey[300],
          child: const Center(child: Text('No images available')),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          itemCount: _pageViewItemCount,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            if (_useCollageLayout) {
              if (index == 0) {
                return _buildCollageView();
              } else {
                final imageIndex = index - 1;
                // Ensure imageIndex is valid, though _pageViewItemCount should prevent out of bounds
                if (imageIndex < _imageCount) {
                  return _buildImagePage(widget.imageUrls[imageIndex]);
                }
                return const SizedBox.shrink(); // Should not be reached
              }
            } else {
              return _buildImagePage(widget.imageUrls[index]);
            }
          },
        ),
        // Indicator
        if (_pageViewItemCount >
            1) // Only show indicator if there's more than one page
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(_pageViewItemCount, (int index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 5.0,
                  width: (index == _currentPage) ? 10.0 : 5.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 2.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      4.0,
                    ), // Simulating context.br.c4
                    color:
                        (index == _currentPage)
                            ? Colors.yellow
                            : Colors.white.withAlpha(160),
                  ),
                );
              }),
            ),
          ),
        // Image Count Indicator
        if (_imageCount > 0)
          Positioned(
            left: 10,
            bottom: 10,
            child: _buildImageCountIndicator(context),
          ),
      ],
    );
  }
}

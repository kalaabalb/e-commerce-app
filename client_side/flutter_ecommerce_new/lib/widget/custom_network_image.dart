import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double scale;
  final double? width;
  final double? height;
  final Color? placeholderColor;
  final Widget? placeholder;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.scale = 1.0,
    this.width,
    this.height,
    this.placeholderColor,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    // Fix HTTP/HTTPS issues for local development
    String fixedUrl = _fixImageUrl(imageUrl);

    print('🟡 Loading image: $fixedUrl');

    return Image.network(
      fixedUrl,
      fit: fit,
      width: width,
      height: height,
      scale: scale,
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) return child;

            // YouTube-like loading with shimmer effect
            return _buildLoadingShimmer(loadingProgress);
          },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
            print('🔴 Image load error: $exception');
            print('🔴 Image URL: $fixedUrl');
            return _buildErrorPlaceholder();
          },
    );
  }

  String _fixImageUrl(String url) {
    // Fix localhost and IP addresses for development
    if (url.contains('localhost')) {
      return url.replaceAll('localhost:3000', '10.161.175.199:3000');
    }
    if (url.contains('10.161.170.81')) {
      return url.replaceAll('10.161.170.81:3000', '10.161.175.199:3000');
    }
    // Ensure HTTP for local development
    if (url.contains('10.161.') && url.contains('https://')) {
      return url.replaceAll('https://', 'http://');
    }
    return url;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: placeholderColor ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          placeholder ??
          Center(
            child: Icon(
              Icons.image,
              color: Colors.grey[500],
              size: _getIconSize(),
            ),
          ),
    );
  }

  Widget _buildLoadingShimmer(ImageChunkEvent loadingProgress) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Base background
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // Loading progress indicator
          if (loadingProgress.expectedTotalBytes != null)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                ),
              ),
            )
          else
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            color: Colors.grey[400],
            size: _getIconSize(),
          ),
          const SizedBox(height: 8),
          Text(
            'No Image',
            style: TextStyle(fontSize: _getTextSize(), color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  double _getIconSize() {
    if (width != null && height != null) {
      return (width! + height!) / 8;
    }
    return 40.0;
  }

  double _getTextSize() {
    if (width != null && height != null) {
      return (width! + height!) / 20;
    }
    return 12.0;
  }
}
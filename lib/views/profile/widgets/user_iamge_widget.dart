import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.imageUrl,
  });

  final dynamic imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl, // The image URL
              fit: BoxFit.cover, // Ensure the image covers the area
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ), // Show a loading indicator
              errorWidget: (context, url, error) =>
                  Icon(Icons.error), // Show an error icon if loading fails
            )
          : Icon(Icons.home,
              size: 100), // Show default icon if no URL is provided
    );
  }
}

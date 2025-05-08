// ignore_for_file: library_private_types_in_public_api

import 'package:apartment_rentals/res/colors.dart';
import 'package:apartment_rentals/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

class ImageWidget extends StatefulWidget {
  const ImageWidget({super.key, required this.mediaUrls, required this.child});

  final List<dynamic> mediaUrls;
  final Widget child;
  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  final PageController _pageController =
      PageController(); // Controller for PageView
  VideoPlayerController? _controller;
  bool _isVideoPlaying = false;
  int _currentIndex = 0; // Track the current page index

  @override
  void dispose() {
    // Dispose video controller when not needed
    if (_controller?.value.isInitialized == true) {
      _controller?.dispose();
    }
    super.dispose();
  }

  // Function to initialize video controller
  void _initializeVideoPlayer(String videoUrl) {
    if (_controller != null && _controller!.value.isInitialized) {
      return; // If already initialized, do nothing
    }

    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Rebuild once the video is initialized
        _controller?.play();
        _isVideoPlaying = true;
      }).catchError((error) {
        Utils().errorSnackBar("Error initializing video: $error");
        debugPrint("Error initializing video: $error");
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PageView for scrolling through media
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 300.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight:
                        Radius.circular(12)), // Border radius for the container
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight:
                        Radius.circular(12)), // Round corners for images/videos
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.mediaUrls.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                    // Pause video when the page changes
                    if (_controller?.value.isInitialized == true) {
                      _controller?.pause();
                    }
                  },
                  itemBuilder: (context, index) {
                    final mediaUrl = widget.mediaUrls[index];

                    // Validate the media URL before using it
                    if (mediaUrl.isEmpty || mediaUrl == 'N/A') {
                      return Icon(Icons.error,
                          size: 100); // Fallback icon for invalid URLs
                    }

                    // If it's a video, show a video player widget
                    if (mediaUrl.endsWith('.mp4') ||
                        mediaUrl.endsWith('.mov')) {
                      // Initialize the video only if it's not already initialized
                      if (_currentIndex == index) {
                        _initializeVideoPlayer(mediaUrl);
                      }

                      if (_controller?.value.isInitialized == true) {
                        return Stack(
                          children: [
                            VideoPlayer(_controller!), // Display the video
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                icon: Icon(
                                  _isVideoPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_isVideoPlaying) {
                                      _controller?.pause();
                                    } else {
                                      _controller?.play();
                                    }
                                    _isVideoPlaying = !_isVideoPlaying;
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }

                    // Image Display: No parallax effect, just standard image fitting
                    return CachedNetworkImage(
                      imageUrl: mediaUrl, // The image URL
                      fit: BoxFit
                          .cover, // Ensures the image covers the container space
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ), // Loading indicator
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error), // Error icon
                    );
                  },
                ),
              ),
            ),
            // SmoothPageIndicator for pagination
            Positioned(
              bottom: 20,
              // left: 0,
              right: 20,
              child: Align(
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                  controller: _pageController, // Page controller
                  count: widget.mediaUrls.length, // Number of pages
                  effect: ExpandingDotsEffect(
                    dotHeight: 8.h,
                    dotWidth: 8.w,
                    spacing: 6.w,
                    activeDotColor: kSecondary2, // Active dot color
                    dotColor: kSecondary3, // Inactive dot color
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                    stops: [1.1, 2.1],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

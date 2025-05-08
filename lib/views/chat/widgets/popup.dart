import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

void showUserDataDialog(BuildContext context, dynamic profilePic, name, phone) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'profileImage',
              child: ClipOval(
                child: profilePic.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 100,
                      )
                    : CachedNetworkImage(
                        imageUrl: profilePic.isNotEmpty ? profilePic : '',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person, size: 30),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Phone: $phone', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

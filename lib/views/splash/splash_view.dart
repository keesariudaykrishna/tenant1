import 'package:apartment_rentals/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../view_models/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServices splashServices = SplashServices();

  // ! Called when the SplashScreen widget is initialized
  @override
  void initState() {
    splashServices.isLogin(context); // ! Check if user is logged in
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color for the splash screen
      backgroundColor: kPrimary,
      body: Center(
        // Center the logo and text on the screen
        child: AppLogo(),
      ),
    );
  }
}

// Stateless widget that displays the app logo and name
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // Spacing between the children widgets
      spacing: 20,
      mainAxisAlignment:
          MainAxisAlignment.center, // Center the widgets vertically
      crossAxisAlignment:
          CrossAxisAlignment.center, // Center the widgets horizontally
      children: [
        // Display the logo image
        Image.asset(
          'assets/house.png', // ! Path to the logo image
          scale: 4, // Scale the image size
        ),
        // Display the app name with custom styling
        RichText(
          textAlign: TextAlign.center, // Center align the text
          text: TextSpan(
            text: 'Safe ', // Starting text
            style: TextStyle(
              color: kDark, // Set text color
              fontSize: 25.spMin, // ! Set font size based on screen size
              fontWeight: FontWeight.bold, // Bold text
              shadows: [
                // Apply shadow effect to text
                Shadow(
                  blurRadius: 30.0, // Shadow blur radius
                  color: kGray, // Shadow color
                  offset: Offset(5.0, 5.0), // Shadow offset
                ),
              ],
            ),
            children: <TextSpan>[
              // Styling for the 'H' in 'Havens'
              TextSpan(
                text: 'H',
                style: TextStyle(
                    color: Colors.deepOrangeAccent, // ! Color for 'H'
                    fontSize: 25.spMin, // Font size
                    fontWeight: FontWeight.bold), // Bold 'H'
              ),
              // Styling for the rest of 'avens'
              TextSpan(
                text: 'avens',
                style: TextStyle(
                    color: kDark, // ! Color for 'avens'
                    fontSize: 25.spMin, // Font size
                    fontWeight: FontWeight.bold), // Bold 'avens'
              ),
            ],
          ),
        ),
      ],
    );
  }
}

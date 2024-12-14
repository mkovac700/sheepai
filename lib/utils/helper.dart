import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chatgpt_test/utils/toast.dart'; // Import the ToastMessage class
import 'package:fluttertoast/fluttertoast.dart'; // Ensure the fluttertoast plugin is properly initialized

// OPEN-URL OR LAUNCH TELEPHONE APP
void launchURL(BuildContext context, String uri) async {
  try {
    Uri url = Uri.parse(uri);
    await launchUrl(url);
  } catch (e) {
    ToastMessage.show("Error: Could not launch $uri");
  }
}

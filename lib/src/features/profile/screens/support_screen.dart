import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: Column(
        children: [
          SizedBox(height: 18),
          buildContactOption(
            icon: Icons.mail,
            text: 'Email Us',
            message: "unishatamang02@gmail.com",
            context: context,
            onTap: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'unishatamang02@gmail.com',
                queryParameters: {'subject': 'App Support'},
              );

              await launchUrl(emailLaunchUri);
            },
          ),
          buildContactOption(
            icon: Icons.phone,
            text: 'Call Us',
            message: "+977-9861750763",
            context: context,
            onTap: () async {
              final Uri phoneCallUri = Uri(
                scheme: 'tel',
                path: '+977-9861750763',
              );

              await launchUrl(phoneCallUri);
            },
          ),
        ],
      ),
    );
  }

  Widget buildContactOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required String message,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: Theme.of(context).textTheme.labelSmall),
                Text(message, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

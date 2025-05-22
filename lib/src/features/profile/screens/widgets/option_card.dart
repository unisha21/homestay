import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String text;
  final String subText;
  final VoidCallback onPressed;
  final IconData iconData;
  const OptionCard(
      {super.key,
        required this.text,
        required this.subText,
        required this.onPressed,
        required this.iconData,
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(10), // Set the border radius here
        ),
        color: const Color(0xffffde8b).withOpacity(0.9),
        margin: const EdgeInsets.only(bottom: 2,),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(iconData),
              SizedBox(width: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface
                        ),
                      ),
                      Text(
                        subText,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:homestay_app/src/common/helper/time_distance_function.dart';
import 'package:homestay_app/src/features/notification/data/notification_datasource.dart';


class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({
    super.key, required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFDBDBDB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 5, right: 16, left: 2, bottom: 2),
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              color: notification.isRead ? theme.colorScheme.inverseSurface : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: theme.textTheme.labelLarge,
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  notification.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 18,
                      color: theme.colorScheme.onSurface,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      '${formatDistanceToNowStrict(notification.createdAt)} ago',
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
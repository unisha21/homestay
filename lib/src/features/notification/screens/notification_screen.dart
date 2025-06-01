import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_app/src/features/notification/data/notification_list_provider.dart';
import 'package:homestay_app/src/features/notification/screens/widgets/notification_card.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationListProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notifications'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: notifications.when(
          data: (data) {
            return data.isEmpty
                ? Center(
              child: Text(
                "No Notifications at the moment",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
                : ListView.separated(
              padding: EdgeInsets.only(top: 14),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async{
                    await ref.read(notificationDataSourceProvider).updateNotificationReadStatus(data[index].notificationId);
                  },
                  child: NotificationCard(notification: data[index]),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 14,
              ),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text('$error'),
            );
          },
          loading: () =>
          const Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }
}

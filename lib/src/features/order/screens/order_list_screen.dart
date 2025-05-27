import 'package:homestay_app/src/features/order/data/order_provider.dart';
import 'package:homestay_app/src/features/order/screens/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_app/src/themes/extensions.dart'; // For context.theme

class OrderListScreen extends ConsumerStatefulWidget {
  const OrderListScreen({super.key});

  @override
  ConsumerState<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends ConsumerState<OrderListScreen> {
  @override
  Widget build(BuildContext context) {
    final orderData = ref.watch(orderProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          elevation: 1,
          backgroundColor: context.theme.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
        ),
        body: orderData.when(
          data: (data) {
            // Filter for active orders, or display all based on requirements
            // final orderList = data.where((element) {
            //   return element.status == OrderStatus.pending || element.status == OrderStatus.accepted;
            // }).toList();
            final orderList = data;

            if (orderList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list_alt_rounded, size: 80, color: context.theme.colorScheme.secondary.withOpacity(0.7)),
                    const SizedBox(height: 20),
                    Text('No Orders Yet', style: context.theme.textTheme.headlineSmall),
                    const SizedBox(height: 10),
                    Text(
                      'You haven\'t placed any orders yet.\nStart exploring and book your next stay!',
                      style: context.theme.textTheme.bodyLarge?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12.0),
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                return OrderCard(order: orderList[index]);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
            );
          },
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Failed to load orders: \n$error',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.bodyLarge?.copyWith(color: context.theme.colorScheme.error),
              ),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}

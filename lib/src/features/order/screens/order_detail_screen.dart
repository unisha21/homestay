import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_app/src/common/widgets/build_button.dart';
import 'package:intl/intl.dart';

import '../data/order_provider.dart';
import '../domain/order_model.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _reasonController = TextEditingController();
  late String _formattedDate;

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    final format = NumberFormat.currency(locale: 'en_np', symbol: 'NPR. ');
    return format.format(price);
  }

  @override
  Widget build(BuildContext context) {
    final orderDetailAsyncValue = ref.watch(
      orderDetailProvider(widget.orderId),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Order Details'), elevation: 1),
      body: orderDetailAsyncValue.when(
        data: (orderData) {
          _notesController.text =
              orderData.orderDetail.notes ?? 'No additional notes.';
          try {
            DateTime dateTime = DateTime.parse(orderData.orderDetail.orderDate);
            _formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
          } catch (e) {
            _formattedDate =
                orderData.orderDetail.orderDate; // Fallback if parsing fails
          }

          final double pricePerNight = double.tryParse(orderData.price) ?? 0.0;
          final int numberOfGuests = orderData.orderDetail.numberOfGuests;
          final double totalPrice = pricePerNight * numberOfGuests;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderData.orderDetail.homeStayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInfoRow(
                  context,
                  label: 'Price per Night:',
                  value: _formatPrice(pricePerNight),
                  valueStyle: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                _buildInfoRow(
                  context,
                  label: 'Number of Guests:',
                  value: '${orderData.orderDetail.numberOfGuests}',
                ),
                const SizedBox(height: 8.0),
                _buildInfoRow(
                  context,
                  label: 'Number of Nights:',
                  value: '${orderData.orderDetail.numberOfNights}',
                ),
                const SizedBox(height: 8.0),
                _buildInfoRow(
                  context,
                  label: 'Check-in Date:',
                  value: _formattedDate,
                ),
                const SizedBox(height: 16.0),
                _buildInfoRow(
                  context,
                  label: 'Total Price:',
                  value: _formatPrice(totalPrice),
                  valueStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Additional Notes/Preferences',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  enabled: false,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 25.0),
                Text(
                  'Customer Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 8.0),
                _buildRichTextDetail(
                  context,
                  'Name',
                  orderData.orderDetail.customerName,
                ),
                const SizedBox(height: 4.0),
                _buildRichTextDetail(
                  context,
                  'Phone',
                  orderData.orderDetail.customerPhone,
                ),
                const SizedBox(height: 30.0),
                _displayActionButton(context, orderData),
                const SizedBox(height: 20.0),
              ],
            ),
          );
        },
        error:
            (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading order details: $error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        Text(
          value,
          style:
              valueStyle ??
              Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRichTextDetail(
    BuildContext context,
    String label,
    String value,
  ) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20.0),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleCancelOrder(
    BuildContext context,
    OrderModel orderData,
  ) async {
    final navigator = Navigator.of(context);
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog(context, 'Cancelling Order...');
      try {
        final String response = await ref.read(
          cancelOrderProvider(orderData.orderId).future,
        );

        if (response == "Order Cancelled") {
          // TODO: Uncomment and use ChatDataSource via provider when available
          /*
          if (orderData.user.metadata != null && orderData.user.metadata!['deviceToken'] != null) {
             // final chatDataSource = ref.read(chatDataSourceProvider); // Assuming chatDataSourceProvider is defined
             // await chatDataSource.sendNotification(
             //    token: orderData.user.metadata!['deviceToken'], 
             //    title: 'Order Cancelled by User',
             //    message: 'Order ID: ${orderData.orderId} has been cancelled by ${orderData.orderDetail.customerName}. Reason: ${_reasonController.text.trim()}',
             //    notificationData: {
             //      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
             //      'type': 'order_status_update',
             //      'orderId': orderData.orderId,
             //    });
          }
          */

          // Use OrderDataSource via provider to update order status with reason
          // final orderDataSource = ref.read(orderDataSourceProvider);
          // await orderDataSource.updateOrderStatus(
          //   orderId: orderData.orderId,
          //   status: OrderStatus.cancelled,
          //   cancellationReason: _reasonController.text.trim()
          // );

          if (navigator.canPop()) navigator.pop(); // Pop loading dialog
          if (navigator.canPop()) navigator.pop(); // Pop modal bottom sheet
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order cancelled successfully.')),
          );
          if (navigator.canPop()) navigator.pop(); // Pop order detail screen
        } else {
          if (navigator.canPop()) navigator.pop(); // Pop loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to cancel order: $response')),
          );
        }
      } catch (e) {
        if (navigator.canPop()) navigator.pop(); // Pop loading dialog
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error cancelling order: $e')));
      }
    }
  }

  void _buildCancelOrderModal(BuildContext context, OrderModel orderData) {
    _reasonController.clear();
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Cancel Order',
                  style: Theme.of(modalContext).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  maxLines: 3,
                  autofocus: true,
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason for Cancellation',
                    hintText: 'Please provide a reason',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason for cancellation.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(modalContext).colorScheme.error,
                    foregroundColor: Theme.of(modalContext).colorScheme.onError,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  onPressed: () => _handleCancelOrder(modalContext, orderData),
                  child: const Text('Submit Cancellation'),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _displayActionButton(BuildContext context, OrderModel data) {
    switch (data.status) {
      case OrderStatus.pending:
        return BuildButton(onPressed: () {}, buttonWidget: Text('Cancel'));
      case OrderStatus.accepted:
        return BuildButton(onPressed: () {}, buttonWidget: Text('Message'));
      case OrderStatus.completed:
        return BuildButton(onPressed: () {}, buttonWidget: Text('Give Review'));
      case OrderStatus.rejected:
        return Text(
          'This order was rejected.',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        );
      case OrderStatus.cancelled:
        return Text(
          'This order has been cancelled.',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        );
    }
  }
}

// TODO: Uncomment and use this if ReviewModal is defined elsewhere, or implement it.
/*
class ReviewModal extends StatelessWidget {
  final OrderModel orderModel;
  const ReviewModal({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Give Review'),
      content: Text('Review functionality for order ${orderModel.orderId} to be implemented here.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
*/

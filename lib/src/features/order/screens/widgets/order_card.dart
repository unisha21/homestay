import 'package:flutter/material.dart';
import 'package:homestay_app/src/features/order/domain/order_model.dart';
import 'package:homestay_app/src/themes/extensions.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.rejected:
        return 'Rejected';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _statusToColor(BuildContext context, OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.accepted:
        return Colors.green;
      case OrderStatus.rejected:
      case OrderStatus.cancelled:
        return context.theme.colorScheme.error;
      case OrderStatus.completed:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
    DateTime parsedOrderDate;
    try {
      parsedOrderDate = DateTime.parse(order.orderDetail.orderDate);
    } catch (e) {
      parsedOrderDate = DateTime.now(); // Fallback
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.orderDetail.homeStayName,
                    style: context.theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusToColor(context, order.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusToString(order.status),
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      color: _statusToColor(context, order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildDetailRow(context, 'Order ID:', order.orderId),
            _buildDetailRow(context, 'Booked By:', order.orderDetail.customerName),
            _buildDetailRow(context, 'Order Date:', dateFormat.format(parsedOrderDate)),
            _buildDetailRow(context, 'Nights:', order.orderDetail.numberOfNights.toString()),
            _buildDetailRow(context, 'Guests:', order.orderDetail.numberOfGuests.toString()),
            _buildDetailRow(context, 'Price:', NumberFormat.currency(
              locale: 'en_US',
              symbol: 'NPR ',
              decimalDigits: 2,
            ).format(double.parse(order.price))),
            _buildDetailRow(context, 'Advance Paid:', NumberFormat.currency(
              locale: 'en_US',
              symbol: 'NPR ',
              decimalDigits: 2,
            ).format(double.parse(order.advancePayment))),
            if (order.orderDetail.notes != null && order.orderDetail.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildDetailRow(context, 'Notes:', order.orderDetail.notes!),
              ),
            const SizedBox(height: 16),
            // Add action buttons if needed, e.g., Cancel, View Details
            // Example:
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     if (order.status == OrderStatus.pending)
            //       TextButton(
            //         onPressed: () {
            //           // Handle cancel order
            //         },
            //         child: const Text('Cancel Order'),
            //       ),
            //     TextButton(
            //       onPressed: () {
            //         // Navigate to order detail screen
            //       },
            //       child: const Text('View Details'),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: context.theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: context.theme.textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

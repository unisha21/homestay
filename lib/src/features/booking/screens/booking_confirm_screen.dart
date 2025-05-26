import 'package:flutter/material.dart';
import 'package:homestay_app/src/common/widgets/build_button.dart';
import 'package:homestay_app/src/features/homestay/domain/models/homestay_model.dart';
import 'package:homestay_app/src/features/order/domain/order_model.dart';
import 'package:homestay_app/src/themes/extensions.dart';
import 'package:intl/intl.dart';
import 'package:homestay_app/src/features/booking/domain/model/booking_model.dart'; // Added import
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class BookingConfirmScreen extends StatelessWidget {
  final BookingModel booking;
  final HomestayModel homestay;

  const BookingConfirmScreen({super.key, required this.booking, required this.homestay});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Your Booking'),
        elevation: 1,
        backgroundColor: context.theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // spacing: 16, // Column does not have spacing, use SizedBox or Padding
          children: <Widget>[
            Text(
              'Booking Summary',
              style: context.theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16), // Added for spacing
            _buildSummaryRow(context, 'Name:', booking.userName),
            _buildSummaryRow(context, 'Phone:', booking.userPhone),
            _buildSummaryRow(
              context,
              'Check-in Date:',
              dateFormat.format(booking.checkInDate),
            ),
            _buildSummaryRow(
              context,
              'Number of Nights:',
              '${booking.numberOfNights}',
            ),
            _buildSummaryRow(
              context,
              'Number of Guests:',
              '${booking.numberOfGuests}',
            ),
            if (booking.notes != null && booking.notes!.isNotEmpty)
              _buildSummaryRow(context, 'Additional Notes:', booking.notes!),
            const Divider(height: 32, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price:',
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'en_np',
                    symbol: 'NPR ',
                    decimalDigits: 2,
                  ).format(booking.totalPrice),
                  // '${booking.totalPrice.toStringAsFixed(2)}', // Format to 2 decimal places
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Added for spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking amount:',
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'en_np',
                    symbol: 'NPR ',
                    decimalDigits: 2,
                  ).format(booking.totalPrice * 0.3),
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Note: 30% of the total amount is needed to confirm your booking.',
              style: context.theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: context.theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            BuildButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                OrderModel order = OrderModel(
                  orderId: '',
                  orderDetail: OrderDetail(
                    customerId: booking.customerId,
                    customerName: booking.userName,
                    customerPhone: booking.userPhone,
                    orderDate: booking.checkInDate.toIso8601String(),
                    numberOfNights: booking.numberOfNights,
                    numberOfGuests: booking.numberOfGuests,
                  ),
                  advancePayment: (booking.totalPrice * 0.3).toStringAsFixed(2),
                  price: booking.pricePerNight.toStringAsFixed(2),
                  hostId: homestay.hostId,
                  status: OrderStatus.pending,
                  user: const types.User(id: ''),
                );
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Redirecting to payment gateway...'),
                //   ),
                // );
              },
              buttonWidget: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align items to start for long values
        children: [
          Text(
            label,
            style: context.theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8), // Add spacing between label and value
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.theme.textTheme.bodyLarge,
              // overflow: TextOverflow.ellipsis, // Removed to allow multi-line for notes
            ),
          ),
        ],
      ),
    );
  }
}

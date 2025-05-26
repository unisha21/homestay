import 'package:flutter/material.dart';
import 'package:homestay_app/src/common/widgets/build_button.dart';
import 'package:homestay_app/src/themes/extensions.dart';
import 'package:intl/intl.dart';
import 'package:homestay_app/src/features/booking/domain/model/booking_model.dart'; // Added import

class BookingConfirmScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingConfirmScreen({
    super.key,
    required this.booking,
  });

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
            _buildSummaryRow(context, 'Check-in Date:', dateFormat.format(booking.checkInDate)),
            _buildSummaryRow(context, 'Number of Nights:', '${booking.numberOfNights}'),
            _buildSummaryRow(context, 'Number of Guests:', '${booking.numberOfGuests}'),
            if (booking.notes != null && booking.notes!.isNotEmpty)
              _buildSummaryRow(context, 'Additional Notes:', booking.notes!),
            const Divider(height: 32, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price:',
                  style: context.theme.textTheme.titleLarge?.copyWith(
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
                  style: context.theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            BuildButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Redirecting to payment gateway...')),
                );
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
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to start for long values
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
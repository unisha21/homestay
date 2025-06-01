import 'package:flutter/material.dart';
import 'package:homestay_app/src/common/route_manager.dart';
import 'package:homestay_app/src/common/widgets/build_button.dart';
import 'package:homestay_app/src/features/auth/screens/widgets/build_dialogs.dart';
import 'package:homestay_app/src/features/chat/data/chat_datasource.dart';
import 'package:homestay_app/src/features/homestay/domain/models/homestay_model.dart';
import 'package:homestay_app/src/features/order/data/order_datasource.dart';
import 'package:homestay_app/src/features/order/domain/order_model.dart';
import 'package:homestay_app/src/features/payment/data/payment_datasource.dart';
import 'package:homestay_app/src/themes/extensions.dart';
import 'package:intl/intl.dart';
import 'package:homestay_app/src/features/booking/domain/model/booking_model.dart'; // Added import
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:khalti_flutter/khalti_flutter.dart';

class BookingConfirmScreen extends StatelessWidget {
  final BookingModel booking;
  final HomestayModel homestay;

  const BookingConfirmScreen({
    super.key,
    required this.booking,
    required this.homestay,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
    final config = PaymentConfig(
      // Todo: due to test mode, the amount is set to 199. need to change to actual amount later
      amount: 19900,
      productIdentity: booking.homestayId,
      productName: homestay.title,
      additionalData: {
        'hostId': homestay.hostId,
        'customer_id': booking.customerId,
        'product_id': booking.homestayId,
        'order_date': booking.checkInDate.toIso8601String(),
        'total_guests': booking.numberOfGuests.toString(),
      },
    );

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
                    homeStayName: homestay.title,
                  ),
                  advancePayment: (booking.totalPrice * 0.3).toStringAsFixed(2),
                  price: homestay.pricePerNight.toString(),
                  hostId: homestay.hostId,
                  homeStayId: homestay.id,
                  status: OrderStatus.pending,
                  user: const types.User(id: ''),
                );
                buildLoadingDialog(context, 'Placing Order!!');
                KhaltiScope.of(context).pay(
                  config: config,
                  onSuccess: (value) async {
                    final response = await OrderDatasource().placeOrder(order);
                    await PaymentDataSource().addPayment(
                      order,
                      value.idx,
                      value.token,
                    );
                    navigator.pop();
                    if (response == 'Order Placed Successfully') {
                      ChatDataSource().sendNotification(
                        token:
                            homestay.user.metadata!['deviceToken'],
                        title: "New Order",
                        message:
                            "You have a new order from ${booking.userName}",
                        notificationData: {
                          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                          'name': booking.userName,
                          'type': 'order',
                          'route': 'order',
                        },
                      ).catchError((error) {
                        // Handle notification sending error
                        print('Error sending notification: $error');
                      });
                      if (!context.mounted) return;
                      buildSuccessDialog(context, response, () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.homeRoute,
                          (route) => false,
                        );
                      });
                    } else {
                      if (!context.mounted) return;
                      buildErrorDialog(
                        context,
                        'Could not place order\n Try again later!',
                      );
                    }
                  },
                  onFailure: (value) {
                    navigator.pop();
                    if (!context.mounted) return;
                    buildErrorDialog(
                      context,
                      'Could not place order\n Try again later!',
                    );
                  },
                  onCancel: () {
                    navigator.pop();
                    if (!context.mounted) return;
                    buildErrorDialog(context, "You've cancelled the order!");
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Redirecting to payment gateway...'),
                  ),
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

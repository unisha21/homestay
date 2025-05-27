import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_app/src/features/payment/data/payment_provider.dart';
import 'package:homestay_app/src/features/payment/domain/payment_model.dart';
import 'package:homestay_app/src/themes/extensions.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends ConsumerWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentHistoryAsync = ref.watch(paymentHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        elevation: 1,
        backgroundColor: context.theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: paymentHistoryAsync.when(
        data: (paymentList) {
          if (paymentList.isEmpty) {
            return const Center(child: Text('No payment history found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            itemCount: paymentList.length,
            separatorBuilder:
                (context, index) =>
                    const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final payment = paymentList[index];
              return PaymentHistoryTile(payment: payment);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading payment history: $error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      ),
    );
  }
}

class PaymentHistoryTile extends StatelessWidget {
  final PaymentDetailModel payment;

  const PaymentHistoryTile({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy hh:mm a');
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(payment.createdAt);
    } catch (e) {
      // Fallback for invalid date format
      parsedDate = DateTime.now();
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Homestay: ${payment.orderInfo.homeStayName ?? 'N/A'}',
              style: context.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            _buildDetailRow(context, 'Transaction ID:', payment.idx),
            _buildDetailRow(
              context,
              'Amount Paid:',
              NumberFormat.currency(
                locale: 'en_np',
                symbol: 'NPR ',
                decimalDigits: 2,
              ).format(double.parse(payment.amount)),
            ),
            _buildDetailRow(context, 'Date:', dateFormat.format(parsedDate)),
            _buildDetailRow(
              context,
              'Booked By:',
              payment.orderInfo.customerName,
            ),
            _buildDetailRow(context, 'Contact:', payment.orderInfo.contact),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isSensitive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label ',
            style: context.theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              isSensitive ? '******' : value,
              style: context.theme.textTheme.bodyMedium,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

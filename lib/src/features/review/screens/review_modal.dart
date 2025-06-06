import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_app/src/common/widgets/build_button.dart';
import 'package:homestay_app/src/common/widgets/build_snackbar.dart';
import 'package:homestay_app/src/common/widgets/build_text_field.dart';
import 'package:homestay_app/src/features/order/domain/order_model.dart';
import 'package:homestay_app/src/features/review/data/review_datasource.dart';
import 'package:homestay_app/src/features/review/domain/review_model.dart';
import 'package:homestay_app/src/themes/export_themes.dart';

class ReviewModal extends ConsumerStatefulWidget {
  final OrderModel orderModel;

  const ReviewModal({super.key, required this.orderModel});

  @override
  ConsumerState<ReviewModal> createState() => _ReviewModalState();
}

class _ReviewModalState extends ConsumerState<ReviewModal> {
  final reviewController = TextEditingController();
  double userRating = 0;
  Icon starIcon = Icon(Icons.star, color: AppColor.containerColor, size: 26);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: EdgeInsets.only(top: 10),
      content: SizedBox(
        width: 300,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Rate", style: theme.textTheme.titleMedium),
                    SizedBox(width: 20),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      unratedColor: theme.colorScheme.onSurface,
                      itemCount: 5,
                      tapOnlyMode: false,
                      itemSize: 28,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2),
                      itemBuilder: (context, _) => starIcon,
                      onRatingUpdate: (rating) async {
                        setState(() {
                          userRating = rating;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5),
                const Divider(color: Colors.grey, thickness: 1.0),
                BuildTextField(
                  controller: reviewController,
                  hintText: 'Write a review here',
                  maxLine: 8,
                ),
                SizedBox(height: 12),
                BuildOutlinedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final scaffoldMessage = ScaffoldMessenger.of(context);
                    final review = ReviewModel(
                      review: reviewController.text.trim(),
                      rating: userRating,
                      userId: widget.orderModel.orderDetail.customerId,
                      hostId: widget.orderModel.hostId,
                      orderId: widget.orderModel.orderId,
                      homeStayId: widget.orderModel.homeStayId,
                      createdAt: DateTime.now().toString(),
                      userName:
                          widget.orderModel.user.firstName ??
                          widget.orderModel.orderDetail.customerName,
                    );
                    final response = await ReviewDataSource().addReview(review);
                    if (response == 'Review Added Successfully') {
                      scaffoldMessage.showSnackBar(
                        BuildSnackBar.buildSnackBar(response),
                      );
                      navigator.pop();
                    } else {
                      scaffoldMessage.showSnackBar(
                        BuildSnackBar.buildSnackBar(
                          "Something went wrong!",
                          color: AppColor.primaryRed,
                        ),
                      );
                    }
                  },
                  buttonWidget: const Text('Submit'),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

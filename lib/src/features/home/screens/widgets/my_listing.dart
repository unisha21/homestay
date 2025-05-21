// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:homestay_app/src/common/route_manager.dart';
// import 'package:homestay_app/src/common/widgets/cached_image.dart';
// import 'package:homestay_app/src/themes/extensions.dart';
// import 'package:intl/intl.dart';

// class ListingView extends ConsumerWidget {
//   const ListingView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final homeStayAsyncValue = ref.watch(homeStayProvider);

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'My Listings',
//             style: context.theme.textTheme.titleLarge?.copyWith(
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 16),
//           homeStayAsyncValue.when(
//             data: (homestays) {
//               if (homestays.isEmpty) {
//                 return const Center(child: Text('No listings available.'));
//               }
//               return GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   childAspectRatio: 0.75, // Adjust the height-to-width ratio
//                 ),
//                 itemCount: homestays.length,
//                 itemBuilder: (context, index) {
//                   final homestay = homestays[index];
//                   return ListingCard(homestay: homestay);
//                 },
//               );
//             },
//             loading: () => const Center(child: CircularProgressIndicator()),
//             error: (error, stackTrace) => Center(child: Text('Error: $error')),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ListingCard extends StatelessWidget {
//   final HomestayModel homestay;

//   const ListingCard({super.key, required this.homestay});

//   double get pricePerNight {
//     final price = homestay.pricePerNight;
//     return double.tryParse(price) ?? 0.0;
//   }

//     String get formattedPrice {
//     final price = double.tryParse(homestay.pricePerNight) ?? 0.0;
//     final formatter = NumberFormat.currency(
//       locale: 'en_US',
//       symbol: 'NPR ',
//       decimalDigits: 2,
//     );
//     return formatter.format(price);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: (){
//         Navigator.pushNamed(
//           context,
//           Routes.serviceDetailRoute,
//           arguments: homestay,
//         );
//       },
//       borderRadius: BorderRadius.circular(12),
//       splashColor: context.theme.splashColor,
//       child: Ink(
//         decoration: BoxDecoration(
//           color: context.theme.colorScheme.surface,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade200,
//               blurRadius: 6,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 5,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(12),
//                 ),
//                 child: CarouselSlider(
//                   options: CarouselOptions(
//                     height: double.infinity,
//                     viewportFraction: 1.0,
//                   ),
//                   items:
//                       homestay.images.map((imageUrl) {
//                         return CachedImage(imageUrl: imageUrl);
//                       }).toList(),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       homestay.title,
//                       style: context.theme.textTheme.bodyLarge?.copyWith(
//                         fontWeight: FontWeight.w500,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       homestay.location,
//                       style: context.theme.textTheme.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.w400,
//                         color: Colors.grey.shade600,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Text.rich(
//                           TextSpan(
//                             text: '$formattedPrice ',
//                             style: context.theme.textTheme.bodyMedium?.copyWith(
//                               fontWeight: FontWeight.w500,
//                             ),
//                             children: [
//                               TextSpan(
//                                 text: '/ night',
//                                 style: context.theme.textTheme.bodySmall?.copyWith(
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.grey.shade600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.star,
//                           color: context.theme.colorScheme.secondary,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                          '4.2',
//                           style: context.theme.textTheme.bodyLarge?.copyWith(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

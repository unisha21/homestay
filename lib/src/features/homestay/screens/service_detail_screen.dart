import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:homestay_app/src/common/route_manager.dart';
import 'package:homestay_app/src/common/widgets/build_button.dart';
import 'package:homestay_app/src/features/homestay/domain/models/homestay_model.dart';
import 'package:homestay_app/src/features/homestay/screens/widgets/carousel_image.dart';
import 'package:homestay_app/src/themes/extensions.dart';

class ServiceDetailScreen extends StatefulWidget {
  final HomestayModel _homestay;
  const ServiceDetailScreen(this._homestay, {super.key});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  int _personCount = 1; // Initial person count

  void _incrementCount() {
    setState(() {
      _personCount++;
      // You might want to add an upper limit to the count
    });
  }

  void _decrementCount() {
    setState(() {
      if (_personCount > 1) {
        // Prevent count from going below 1
        _personCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 16,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 11,
                    child: Stack(
                      children: [
                        CarouselImage(imageUrls: widget._homestay.images),
                        Positioned(
                          top: 50,
                          left: 12,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: context.theme.colorScheme.surface
                                    .withAlpha(200),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: context.theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget._homestay.title,
                                  style: context.theme.textTheme.titleLarge,
                                ),
                                Text(
                                  '4.2 ⭐',
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            spacing: 8,
                            children: [
                              Icon(
                                Icons.pin_drop_outlined,
                                color: context.theme.colorScheme.primary,
                                size: 16,
                              ),
                              Text(
                                widget._homestay.location,
                                style: context.theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Text(
                            widget._homestay.description,
                            style: context.theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: context.theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'What\'s included',
                            style: context.theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          _IncludedAmenities(
                            amenities: widget._homestay.amenities,
                          ),
                          const SizedBox(height: 4),
                          NearByPlaces(
                            nearBy: widget._homestay.nearByPlaces ?? [],
                          ),
                          const SizedBox(height: 4),
                          OwnerInfo(user: widget._homestay.user),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              // Changed from Center to Row
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  // Group for person count controls
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: context.theme.colorScheme.primary,
                      ),
                      onPressed: _decrementCount,
                      tooltip: 'Decrease persons',
                    ),
                    Text(
                      '$_personCount',
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: context.theme.colorScheme.primary,
                      ),
                      onPressed: _incrementCount,
                      tooltip: 'Increase persons',
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BuildButton(
                    onPressed: () {
                      // Navigate to BookingScreen
                      Navigator.pushNamed(
                        context,
                        Routes.bookingRoute,
                        arguments: {
                          "homestayId": widget._homestay.id,
                          "numberOfGuests": _personCount,
                        },
                      );
                    },

                    buttonWidget: Text('Book Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IncludedAmenities extends StatelessWidget {
  final List<String> amenities;
  const _IncludedAmenities({required this.amenities});

  Map<String, dynamic> get amenitiesMap {
    return {
      'WiFi': Icons.wifi,
      'Parking': Icons.local_parking,
      'Breakfast': Icons.free_breakfast,
      'Air Conditioning': Icons.ac_unit,
      'Swimming Pool': Icons.pool,
      'TV': Icons.tv,
      'Kitchen': Icons.kitchen,
      'Washer': Icons.local_laundry_service,
      'Pet Friendly': Icons.pets,
      'Gym': Icons.fitness_center,
      'Elevator': Icons.elevator,
      'Fireplace': Icons.fireplace,
      'Balcony': Icons.balcony,
      'Smoke Detector': Icons.smoke_free,
      // Add more mappings as needed
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: List.generate(amenities.length, (index) {
          return Text(
            "- ${amenities[index]}",
            style: context.theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          );
        }),
      ),
    );
  }
}

class NearByPlaces extends StatelessWidget {
  final List<NearByPlace> nearBy;
  const NearByPlaces({super.key, required this.nearBy});

  @override
  Widget build(BuildContext context) {
    if (nearBy.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          'Nearby Places',
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        ...List.generate(nearBy.length, (index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.pin_drop_outlined,
                color: context.theme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          nearBy[index].name,
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '(${nearBy[index].distance})',
                          style: context.theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: context.theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nearBy[index].description,
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: context.theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class OwnerInfo extends StatelessWidget {
  final types.User user;
  const OwnerInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Owner Info',
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          spacing: 2,
          children: [
            Row(
              spacing: 10,
              children: [
                Icon(
                  Icons.person,
                  color: context.theme.colorScheme.primary,
                  size: 16,
                ),
                Text(
                  user.firstName ?? 'Unknown',
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              spacing: 10,
              children: [
                Icon(
                  Icons.phone,
                  color: context.theme.colorScheme.primary,
                  size: 16,
                ),
                Text(
                  user.metadata?['phone'] ?? 'not provided',
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              spacing: 10,
              children: [
                Icon(
                  Icons.email,
                  color: context.theme.colorScheme.primary,
                  size: 16,
                ),
                Text(
                  user.metadata?['email'] ?? 'not provided',
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

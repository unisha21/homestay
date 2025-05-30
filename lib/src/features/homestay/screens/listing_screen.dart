import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homestay_app/src/common/route_manager.dart';
import 'package:homestay_app/src/features/homestay/data/home_stay_provider/home_stay_provider.dart';
import 'package:homestay_app/src/features/homestay/domain/models/homestay_model.dart';

class ListingScreen extends ConsumerWidget {
  const ListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeStayAsyncValue = ref.watch(homeStayProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: homeStayAsyncValue.when(
        data: (homestays) {
          if (homestays.isEmpty) {
            return const Center(child: Text('No listings available.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: homestays.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final homestay = homestays[index];
              return _ListingCard(
                homestay: homestay,
                onEdit: () {
                  Navigator.pushNamed(
                    context,
                    Routes.updateListingRoute,
                    arguments: homestay,
                  );
                },
                onDelete: () {
                  _showDeleteConfirmationDialog(context, homestay, ref);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    HomestayModel homestay,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Listing'),
          content: const Text('Are you sure you want to delete this listing?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _ListingCard extends StatelessWidget {
  final HomestayModel homestay;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ListingCard({
    super.key,
    required this.homestay,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First image
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
            image:
                homestay.images.isNotEmpty
                    ? DecorationImage(
                      image: NetworkImage(homestay.images.first),
                      fit: BoxFit.cover,
                    )
                    : null,
          ),
          child:
              homestay.images.isEmpty
                  ? const Icon(Icons.broken_image, color: Colors.grey)
                  : null,
        ),
        const SizedBox(width: 12),
        // Name and address
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                homestay.title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                homestay.location,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Popup menu button
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
        ),
      ],
    );
  }
}

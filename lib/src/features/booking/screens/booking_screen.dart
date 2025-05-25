import 'package:flutter/material.dart';
import 'package:homestay_app/src/common/widgets/build_button.dart';
import 'package:homestay_app/src/themes/extensions.dart';

class BookingScreen extends StatefulWidget {
  final String homestayId;
  final int numberOfGuests;

  const BookingScreen({
    super.key,
    required this.homestayId,
    required this.numberOfGuests,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nightsController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nightsController.text = '1'; // Default to 1 night
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nightsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      // Process booking
      // For now, just print the details
      print('Booking Details:');
      print('Homestay ID: ${widget.homestayId}');
      print('Name: ${_nameController.text}');
      print('Phone: ${_phoneController.text}');
      print('Guests: ${widget.numberOfGuests}');
      print('Nights: ${_nightsController.text}');
      print('Notes: ${_notesController.text}');

      // Navigate to payment or confirmation screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proceeding to payment...')), // Placeholder
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Stay'),
        elevation: 1,
        backgroundColor: context.theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: <Widget>[
              Text(
                'Confirm your details and book',
                style: context.theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  // Add more sophisticated phone validation if needed
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.numberOfGuests.toString(),
                decoration: const InputDecoration(
                  labelText: 'Total Guests',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group_outlined),
                ),
                readOnly: true, // Pre-filled from detail screen
              ),
              TextFormField(
                controller: _nightsController,
                decoration: const InputDecoration(
                  labelText: 'Total Nights Stay',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.night_shelter_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of nights';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of nights';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note_alt_outlined),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              BuildButton(
                onPressed: _submitBooking,
                buttonWidget: const Text('Confirm and Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

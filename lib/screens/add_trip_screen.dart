import 'package:flutter/material.dart';

class AddTripScreen extends StatefulWidget {
  static const String routeName = '/add-trip';

  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _tripNameController = TextEditingController();
  // Placeholder for image path, if any
  String? _imagePath;

  @override
  void dispose() {
    _tripNameController.dispose();
    super.dispose();
  }

  void _addPhoto() {
    // TODO: Implement image picking logic
    print('Add photo tapped');
  }

  void _continue() {
    // TODO: Implement continue logic (e.g., save trip name and photo, navigate next)
    print(
      'Continue tapped. Trip Name: ${_tripNameController.text}, Image Path: $_imagePath',
    );
    Navigator.of(context).pop(); // For now, just pop back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                const BackButton(),
                Text(
                  'Add New Trip',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Choose a Name',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20), // Consistent spacing
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: _tripNameController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., "Japan" or "European Adventure"',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Consistent spacing
                  InkWell(
                    onTap: _addPhoto,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 180,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.5),
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      ),
                      child: _imagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                _imagePath!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 60,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.7),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add Photo (Optional)',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.7),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ), // Increased spacing before the button
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      onPressed: _continue,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

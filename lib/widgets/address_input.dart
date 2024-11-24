import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class AddressInputWidget extends StatefulWidget {
  final String apiKey;

  const AddressInputWidget({Key? key, required this.apiKey}) : super(key: key);

  @override
  _AddressInputWidgetState createState() => _AddressInputWidgetState();
}

class _AddressInputWidgetState extends State<AddressInputWidget> {
  late FlutterGooglePlacesSdk _places;

  // Controllers for input fields
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  List<AutocompletePrediction> _suggestions = [];
  bool _isAutoFilling = false;

  @override
  void initState() {
    super.initState();
    _places = FlutterGooglePlacesSdk(widget.apiKey);
  }

  /// Fetch detailed place information using Place ID
  Future<void> _fetchPlaceDetails(String placeId) async {
    try {
      setState(() {
        _isAutoFilling = true; // Disable editing during auto-fill
        _suggestions = []; // Clear suggestions
      });

      final response = await _places.fetchPlace(
        placeId,
        fields: [
          PlaceField.AddressComponents,
          PlaceField.Name,
        ],
      );

      if (response.place != null) {
        final place = response.place!;
        final components = place.addressComponents ?? [];

        // Construct the full address
        String fullAddress = components.map((e) => e.name).join(', ');

        setState(() {
          _addressController.text = fullAddress;

          // Extract specific address components
          for (var component in components) {
            if (component.types.contains('locality')) {
              _cityController.text = component.name;
            } else if (component.types
                .contains('administrative_area_level_1')) {
              _stateController.text = component.shortName ?? component.name;
            } else if (component.types.contains('postal_code')) {
              _zipCodeController.text = component.name;
            }
          }
        });
      } else {
        print('No place details found.');
      }
    } catch (e) {
      print('Error fetching place details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not fetch place details')),
      );
    } finally {
      setState(() {
        _isAutoFilling = false; // Re-enable editing
      });
    }
  }

  /// Handle address input and fetch suggestions
  Future<void> _handleAddressInput(String input) async {
    if (input.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    try {
      final predictions = await _places.findAutocompletePredictions(
        input,
        countries: ['US'], // Restrict to US addresses
      );

      print(
          'Predictions: ${predictions.predictions.map((e) => e.fullText).toList()}'); // Debugging

      setState(() {
        _suggestions = predictions.predictions;
      });
    } catch (e) {
      print('Error fetching address suggestions: $e');
    }
  }

  /// Build the suggestion dropdown
  Widget _buildSuggestionsDropdown() {
    if (_suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Text(suggestion.fullText ?? ''),
            onTap: () {
              _fetchPlaceDetails(suggestion.placeId);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            // Address Field
            TextFormField(
              controller: _addressController,
              enabled: !_isAutoFilling,
              decoration: InputDecoration(
                labelText: 'Address',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                if (!_isAutoFilling) {
                  _handleAddressInput(value);
                }
              },
            ),

            // Dropdown for Suggestions
            Positioned.fill(
              top: 48.0,
              child: _buildSuggestionsDropdown(),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // City Field (Editable)
        TextFormField(
          controller: _cityController,
          decoration: InputDecoration(
            labelText: 'City',
            prefixIcon: const Icon(Icons.location_city),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // State Field (Editable)
        TextFormField(
          controller: _stateController,
          decoration: InputDecoration(
            labelText: 'State',
            prefixIcon: const Icon(Icons.map),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ZIP Code Field (Editable)
        TextFormField(
          controller: _zipCodeController,
          decoration: InputDecoration(
            labelText: 'ZIP Code',
            prefixIcon: const Icon(Icons.local_post_office),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}

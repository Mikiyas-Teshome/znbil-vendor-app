import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomEinInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? Function(String?)? validator;

  const CustomEinInputField({
    Key? key,
    this.controller,
    this.labelText = 'EIN',
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
        LengthLimitingTextInputFormatter(9), // Limit to 9 digits
        _EINInputFormatter(), // Format as XX-XXXXXXX
      ],
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon:
            Icon(Icons.business, color: Theme.of(context).iconTheme.color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: theme.dividerColor,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: theme.dividerColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.amber,
            width: 1.50,
          ),
        ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'EIN is required';
            }
            final einRegex = RegExp(r'^\d{2}-\d{7}$');
            if (!einRegex.hasMatch(value)) {
              return 'Enter a valid EIN (XX-XXXXXXX)';
            }
            return null;
          },
    );
  }
}

class _EINInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('-', ''); // Remove existing hyphen
    if (text.length <= 2) {
      return newValue.copyWith(text: text);
    } else if (text.length <= 9) {
      final formattedText = '${text.substring(0, 2)}-${text.substring(2)}';
      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
    return oldValue;
  }
}

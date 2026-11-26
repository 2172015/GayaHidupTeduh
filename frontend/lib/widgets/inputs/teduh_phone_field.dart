import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/form_validator.dart';
import 'teduh_text_field.dart';

class TeduhPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onCountryCodeChanged;
  final String initialCountryCode;

  const TeduhPhoneField({
    super.key,
    required this.controller,
    required this.onCountryCodeChanged,
    this.initialCountryCode = 'ID',
  });

  /// Menggabungkan dial code + nomor HP tanpa angka '0' berlebih di depan
  static String formatPhoneNumber(String dialCode, String rawPhone) {
    var cleaned = rawPhone.trim();
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }
    return '$dialCode$cleaned';
  }

  @override
  Widget build(BuildContext context) {
    return TeduhTextField(
      controller: controller,
      hintText: '81234567890',
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: FormValidator.validatePhone,
      prefixIcon: CountryCodePicker(
        onChanged: (country) {
          onCountryCodeChanged(country.dialCode ?? '+62');
        },
        initialSelection: initialCountryCode,
        favorite: const ['+62', 'ID'],
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
        alignLeft: false,
        padding: const EdgeInsets.only(left: 6),
        flagWidth: 22,
        textStyle: const TextStyle(
          color: AppColors.forestGreen,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        dialogTextStyle: const TextStyle(
          color: Color(0xFF383329),
        ),
        searchDecoration: const InputDecoration(
          hintText: 'Cari negara atau kode...',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
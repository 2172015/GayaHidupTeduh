class FormValidator {
  static String? validateName(String? value, {String fieldName = 'Nama'}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$fieldName wajib diisi.';
    if (text.length < 2) return '$fieldName minimal 2 karakter.';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(text)) {
      return '$fieldName hanya boleh berisi huruf.';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Username wajib diisi.';
    if (text.length < 4) return 'Username minimal 4 karakter.';
    if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(text)) {
      return 'Hanya huruf, angka, titik (.), dan underscore (_).';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email wajib diisi.';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(text)) return 'Format email tidak valid.';
    return null;
  }

  static String? validatePhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Nomor telepon wajib diisi.';
    if (text.length < 9 || text.length > 13) {
      return 'Nomor telepon harus 9–13 digit.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Password wajib diisi.';
    if (text.length < 8) return 'Password minimal 8 karakter.';
    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return 'Password harus mengandung minimal 1 huruf kapital.';
    }
    if (!RegExp(r'[0-9]').hasMatch(text)) {
      return 'Password harus mengandung minimal 1 angka.';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]').hasMatch(text)) {
      return 'Password harus mengandung minimal 1 simbol (contoh: @, #, !).';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Konfirmasi password wajib diisi.';
    if (value != password) return 'Konfirmasi password tidak cocok.';
    return null;
  }
}
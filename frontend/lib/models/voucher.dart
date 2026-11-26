import 'counselor.dart';

enum VoucherDiscountType { percentage, fixedAmount }

class Voucher {
  final String id;
  final String code;
  final String title;
  final String description;
  final VoucherDiscountType discountType;
  final int
  discountValue; // Persen (misal 30) atau nominal rupiah (misal 15000)
  final int? maxDiscountAmount;
  final int minTransaction;
  final DateTime expiryDate;
  final bool isUsed;

  const Voucher({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.maxDiscountAmount,
    this.minTransaction = 0,
    required this.expiryDate,
    this.isUsed = false,
  });

  bool get isExpired => !isUsed && DateTime.now().isAfter(expiryDate);
  bool get isAvailable => !isUsed && !isExpired;

  String get formattedExpiry {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return 'Berlaku hingga ${expiryDate.day} ${months[expiryDate.month - 1]} ${expiryDate.year}';
  }

  int calculateDiscount(int subtotal) {
    if (!isAvailable || subtotal < minTransaction) return 0;

    if (discountType == VoucherDiscountType.fixedAmount) {
      return discountValue > subtotal ? subtotal : discountValue;
    }

    final rawDiscount = (subtotal * discountValue / 100).round();
    final capped = maxDiscountAmount != null && rawDiscount > maxDiscountAmount!
        ? maxDiscountAmount!
        : rawDiscount;
    return capped > subtotal ? subtotal : capped;
  }

  String get formattedDiscountBadge {
    if (discountType == VoucherDiscountType.percentage) {
      return '$discountValue%';
    }
    return Counselor.formatRupiah(discountValue);
  }

  Voucher copyWith({bool? isUsed}) {
    return Voucher(
      id: id,
      code: code,
      title: title,
      description: description,
      discountType: discountType,
      discountValue: discountValue,
      maxDiscountAmount: maxDiscountAmount,
      minTransaction: minTransaction,
      expiryDate: expiryDate,
      isUsed: isUsed ?? this.isUsed,
    );
  }
}

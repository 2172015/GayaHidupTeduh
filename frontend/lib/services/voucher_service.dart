import '../models/voucher.dart';

abstract class VoucherService {
  Future<List<Voucher>> getUserVouchers(String userId);
  Voucher? getSelectedVoucher();
  void selectVoucherForBooking(Voucher? voucher);
  Future<void> markVoucherAsUsed(String voucherId);
}

class MockVoucherService implements VoucherService {
  static final List<Voucher> _vouchers = [
    Voucher(
      id: 'v1',
      code: 'TEDUHSTREAK30',
      title: 'Voucher Diskon Konseling 30%',
      description: 'Potongan biaya sesi konseling hingga Rp 25.000',
      discountType: VoucherDiscountType.percentage,
      discountValue: 30,
      maxDiscountAmount: 25000,
      minTransaction: 100000,
      expiryDate: DateTime(2026, 12, 31),
      isUsed: false,
    ),
    Voucher(
      id: 'v2',
      code: 'TEDUHBERSAMA15',
      title: 'Voucher Diskon Rp 15.000',
      description: 'Potongan langsung untuk semua jadwal konseling',
      discountType: VoucherDiscountType.fixedAmount,
      discountValue: 15000,
      minTransaction: 100000,
      expiryDate: DateTime(2026, 12, 31),
      isUsed: false,
    ),
    Voucher(
      id: 'v3',
      code: 'LANGKAHPERTAMA',
      title: 'Voucher Pengguna Baru Rp 20.000',
      description: 'Potongan sesi konseling pertama di Gaya Hidup Teduh',
      discountType: VoucherDiscountType.fixedAmount,
      discountValue: 20000,
      minTransaction: 100000,
      expiryDate: DateTime(2026, 11, 10),
      isUsed: true,
    ),
  ];

  static Voucher? _selectedVoucher;

  @override
  Future<List<Voucher>> getUserVouchers(String userId) async {
    await Future.delayed(const Duration(milliseconds: 220));
    return List.unmodifiable(_vouchers);
  }

  @override
  Voucher? getSelectedVoucher() => _selectedVoucher;

  @override
  void selectVoucherForBooking(Voucher? voucher) {
    _selectedVoucher = voucher;
  }

  @override
  Future<void> markVoucherAsUsed(String voucherId) async {
    final idx = _vouchers.indexWhere((v) => v.id == voucherId);
    if (idx != -1) {
      _vouchers[idx] = _vouchers[idx].copyWith(isUsed: true);
    }
    if (_selectedVoucher?.id == voucherId) {
      _selectedVoucher = null;
    }
  }
}

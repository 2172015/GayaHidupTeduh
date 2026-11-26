import '../models/booking_slot_item.dart';
import '../models/counseling_booking.dart';
import '../models/counseling_session_status.dart';
import '../models/counselor.dart';
import '../models/counselor_review.dart';
import '../models/payment_method_type.dart';
import '../models/counselor_note.dart';

abstract class CounselingService {
  Future<CounselingBooking> cancelBooking(String sessionId);
  List<Counselor> getCounselors();
  List<BookingSlotItem> getCartItems();
  void toggleCartSlot({
    required Counselor counselor,
    required DateTime date,
    required String timeSlot,
  });
  void removeCartSlot(String slotItemId);
  void loadBookingIntoCart(CounselingBooking booking);
  void clearCart();

  Future<List<CounselingBooking>> getUserBookings(String userId);
  Future<CounselingBooking> createPendingBooking({
    required String userId,
    required List<BookingSlotItem> items,
    required Map<String, String> messages,
    required PaymentMethodType paymentMethod,
    String? existingPendingSessionId,
  });
  Future<void> confirmPayment(String sessionId);
  Future<CounselingBooking> submitSessionReview({
    required String sessionId,
    required int rating,
    required String reviewText,
  });
}

class MockCounselingService implements CounselingService {
  static final List<Counselor> _counselors = [
    Counselor(
      id: 'c1',
      name: 'Mark Skinson',
      role: 'Counselor',
      specialty: 'Spesialis Stress & Kecemasan',
      bio: 'Helping you navigate stress, anxiety, and life transitions through mindful and cognitive behavioral therapy.',
      avatarAsset: 'assets/images/profilepicture/pp1.png',
      rating: 4.9,
      reviewCount: 120,
      feePerSession: 152500,
      bookedSlots: const ['15:00 PM'],
      reviews: [
        CounselorReview(
          id: 'r1',
          reviewerName: 'Dave Andrew',
          rating: 5,
          comment:
              'Sangat membantu dan menenangkan saat konsultasi. Best Counselor',
          createdAt: DateTime(2026, 11, 10),
        ),
        CounselorReview(
          id: 'r2',
          reviewerName: 'Yanes Manukilej',
          rating: 4,
          comment:
              'Counselor yang baik, sedikit terlambat saat pertemuan pertama',
          createdAt: DateTime(2026, 11, 12),
        ),
      ],
    ),
    Counselor(
      id: 'c2',
      name: 'Clara Elson, Psikolog',
      role: 'Psikolog',
      specialty: 'Mindfulness Specialist',
      bio: 'Pendekatan empatik berbasis mindfulness dan regulasi emosi untuk membantumu menemukan kembali keseimbangan diri.',
      avatarAsset: 'assets/images/profilepicture/pp2.png',
      rating: 4.7,
      reviewCount: 94,
      feePerSession: 250500,
      bookedSlots: const ['10:00 AM', '15:00 PM'],
      reviews: [
        CounselorReview(
          id: 'r3',
          reviewerName: 'Dave Andrew',
          rating: 5,
          comment: 'Pendengar yang sangat sabar dan memberikan latihan pernapasan yang mudah diterapkan.',
          createdAt: DateTime(2026, 11, 8),
        ),
      ],
    ),
    Counselor(
      id: 'c3',
      name: 'Reynaldi',
      role: 'Therapist',
      specialty: 'Spesialis Keluarga',
      bio: 'Mendampingi pemulihan komunikasi keluarga, relasi interpersonal, dan pengelolaan burnout akademik maupun pekerjaan.',
      avatarAsset: 'assets/images/profilepicture/pp3.png',
      rating: 4.9,
      reviewCount: 86,
      feePerSession: 120000,
      bookedSlots: const ['12:00 AM', '15:00 PM'],
      reviews: [
        CounselorReview(
          id: 'r4',
          reviewerName: 'Yanes Manukilej',
          rating: 5,
          comment: 'Sesi terasa hangat, terarah, dan sangat solutif.',
          createdAt: DateTime(2026, 11, 5),
        ),
      ],
    ),
  ];

  static final List<BookingSlotItem> _cart = [];

  static final List<CounselingBooking> _bookings = [
    CounselingBooking(
      sessionId: '#CS-2089202611',
      userId: '278392',
      items: [
        BookingSlotItem(
          id: 'init-1',
          counselor: _counselors[0],
          date: DateTime(2026, 11, 29),
          timeSlot: '08:00 AM',
        ),
      ],
      status: CounselingSessionStatus.pendingPayment,
      paymentMethod: PaymentMethodType.bcaVirtualAccount,
      createdAt: DateTime(2026, 11, 25, 10, 0),
    ),
    CounselingBooking(
      sessionId: '#CS-2089202612',
      userId: '278392',
      items: [
        BookingSlotItem(
          id: 'init-2',
          counselor: _counselors[1],
          date: DateTime(2026, 11, 26),
          timeSlot: '10:00 AM',
        ),
      ],
      status: CounselingSessionStatus.scheduled,
      notes: [
        CounselorNote(
          id: 'n1',
          date: DateTime(2026, 11, 19),
          content: 'The patient is very good at handling his own emotions, but need to be open to others about his feelings',
        ),
        CounselorNote(
          id: 'n2',
          date: DateTime(2026, 11, 23),
          content: 'Great improvement, the patient has a better understanding of his emotion, and has opened up his feelings',
        ),
      ],
      createdAt: DateTime(2026, 11, 20, 14, 0),
    ),
    CounselingBooking(
      sessionId: '#CS-2089202609',
      userId: '278392',
      items: [
        BookingSlotItem(
          id: 'init-3',
          counselor: _counselors[2],
          date: DateTime(2026, 8, 17),
          timeSlot: '08:00 AM',
        ),
      ],
      status: CounselingSessionStatus.cancelled,
      createdAt: DateTime(2026, 8, 15, 9, 0),
    ),
    CounselingBooking(
      sessionId: '#CS-2089202610',
      userId: '278392',
      items: [
        BookingSlotItem(
          id: 'init-4',
          counselor: _counselors[1],
          date: DateTime(2026, 11, 18),
          timeSlot: '10:00 AM',
        ),
      ],
      status: CounselingSessionStatus.completed,
      notes: [
        CounselorNote(
          id: 'n1',
          date: DateTime(2026, 11, 19),
          content: 'The patient is very good at handling his own emotions, but need to be open to others about his feelings',
        ),
        CounselorNote(
          id: 'n2',
          date: DateTime(2026, 11, 23),
          content: 'Great improvement, the patient has a better understanding of his emotion, and has opened up his feelings',
        ),
      ],
      createdAt: DateTime(2026, 11, 16, 11, 0),
    ),
  ];

  @override
  List<Counselor> getCounselors() => _counselors;

  @override
  List<BookingSlotItem> getCartItems() => List.unmodifiable(_cart);

  String _buildSlotId(String counselorId, DateTime date, String timeSlot) {
    final dateKey = '${date.year}${date.month}${date.day}';
    return '$counselorId-$dateKey-$timeSlot';
  }

  @override
  void toggleCartSlot({
    required Counselor counselor,
    required DateTime date,
    required String timeSlot,
  }) {
    if (counselor.isSlotBooked(timeSlot)) return;

    final id = _buildSlotId(counselor.id, date, timeSlot);
    final existingIdx = _cart.indexWhere((item) => item.id == id);

    if (existingIdx != -1) {
      _cart.removeAt(existingIdx);
    } else {
      _cart.add(
        BookingSlotItem(
          id: id,
          counselor: counselor,
          date: DateTime(date.year, date.month, date.day),
          timeSlot: timeSlot,
        ),
      );
    }
  }

  @override
  void removeCartSlot(String slotItemId) {
    _cart.removeWhere((item) => item.id == slotItemId);
  }

  @override
  void loadBookingIntoCart(CounselingBooking booking) {
    _cart
      ..clear()
      ..addAll(booking.items);
  }

  @override
  void clearCart() => _cart.clear();

  @override
  Future<List<CounselingBooking>> getUserBookings(String userId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _bookings.where((b) => b.userId == userId).toList();
  }

  @override
  Future<CounselingBooking> createPendingBooking({
    required String userId,
    required List<BookingSlotItem> items,
    required Map<String, String> messages,
    required PaymentMethodType paymentMethod,
    String? existingPendingSessionId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (existingPendingSessionId != null) {
      final idx = _bookings.indexWhere(
        (b) => b.sessionId == existingPendingSessionId,
      );
      if (idx != -1) {
        final updated = _bookings[idx].copyWith(
          items: List<BookingSlotItem>.from(items),
          counselorMessages: Map<String, String>.from(messages),
          paymentMethod: paymentMethod,
          status: CounselingSessionStatus.pendingPayment,
        );
        _bookings[idx] = updated;
        clearCart();
        return updated;
      }
    }

    final newSessionId =
        '#CS-${DateTime.now().millisecondsSinceEpoch.toString().substring(3)}';
    final created = CounselingBooking(
      sessionId: newSessionId,
      userId: userId,
      items: List<BookingSlotItem>.from(items),
      counselorMessages: Map<String, String>.from(messages),
      paymentMethod: paymentMethod,
      status: CounselingSessionStatus.pendingPayment,
      createdAt: DateTime.now(),
    );

    _bookings.insert(0, created);
    clearCart();
    return created;
  }

  @override
  Future<void> confirmPayment(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final idx = _bookings.indexWhere((b) => b.sessionId == sessionId);
    if (idx == -1) return;

    final pendingOrder = _bookings[idx];
    _bookings.removeAt(idx);

    // Setiap slot yang dibayar menjadi sesi Scheduled individual
    for (int i = 0; i < pendingOrder.items.length; i++) {
      final slot = pendingOrder.items[i];
      final individualId = pendingOrder.items.length == 1
          ? pendingOrder.sessionId
          : '${pendingOrder.sessionId}-${i + 1}';

      _bookings.insert(
        0,
        CounselingBooking(
          sessionId: individualId,
          userId: pendingOrder.userId,
          items: [slot],
          counselorMessages: pendingOrder.counselorMessages,
          paymentMethod: pendingOrder.paymentMethod,
          status: CounselingSessionStatus.scheduled,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<CounselingBooking> submitSessionReview({
    required String sessionId,
    required int rating,
    required String reviewText,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _bookings.indexWhere((b) => b.sessionId == sessionId);
    final updated = _bookings[idx].copyWith(
      userRating: rating,
      userReview: reviewText.trim(),
    );
    _bookings[idx] = updated;
    return updated;
  }

  @override
  Future<CounselingBooking> cancelBooking(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final idx = _bookings.indexWhere((b) => b.sessionId == sessionId);
    final updated = _bookings[idx].copyWith(
      status: CounselingSessionStatus.cancelled,
    );
    _bookings[idx] = updated;
    return updated;
  }
}

import 'booking_slot_item.dart';
import 'counseling_session_status.dart';
import 'counselor_note.dart';
import 'payment_method_type.dart';

class CounselingBooking {
  final String sessionId;
  final String userId;
  final List<BookingSlotItem> items;
  final Map<String, String> counselorMessages;
  final PaymentMethodType paymentMethod;
  final CounselingSessionStatus status;
  final String meetLink;
  final List<CounselorNote> notes;
  final int? userRating;
  final String? userReview;
  final DateTime createdAt;

  const CounselingBooking({
    required this.sessionId,
    required this.userId,
    required this.items,
    this.counselorMessages = const {},
    this.paymentMethod = PaymentMethodType.bcaVirtualAccount,
    this.status = CounselingSessionStatus.pendingPayment,
    this.meetLink = 'https://meet.google.com/teduh-cs-2089',
    this.notes = const [],
    this.userRating,
    this.userReview,
    required this.createdAt,
  });

  bool get isMultiSession => items.length > 1;
  bool get hasSubmittedReview =>
      userRating != null && userReview != null && userReview!.trim().isNotEmpty;

  BookingSlotItem get primaryItem => items.first;

  int get totalAmount => items.fold<int>(0, (sum, item) => sum + item.fee);

  CounselingBooking copyWith({
    String? sessionId,
    String? userId,
    List<BookingSlotItem>? items,
    Map<String, String>? counselorMessages,
    PaymentMethodType? paymentMethod,
    CounselingSessionStatus? status,
    String? meetLink,
    List<CounselorNote>? notes,
    int? userRating,
    String? userReview,
    DateTime? createdAt,
  }) {
    return CounselingBooking(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      counselorMessages: counselorMessages ?? this.counselorMessages,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      meetLink: meetLink ?? this.meetLink,
      notes: notes ?? this.notes,
      userRating: userRating ?? this.userRating,
      userReview: userReview ?? this.userReview,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

import 'counselor_review.dart';

class Counselor {
  final String id;
  final String name;
  final String role;
  final String specialty;
  final String bio;
  final String avatarAsset;
  final double rating;
  final int reviewCount;
  final int feePerSession;
  final List<String> dailyTimeSlots;
  final List<String> bookedSlots;
  final List<CounselorReview> reviews;

  const Counselor({
    required this.id,
    required this.name,
    required this.role,
    required this.specialty,
    required this.bio,
    required this.avatarAsset,
    required this.rating,
    required this.reviewCount,
    required this.feePerSession,
    this.dailyTimeSlots = const [
      '10:00 AM',
      '12:00 AM',
      '15:00 PM',
      '17:00 PM',
      '19:00 PM',
    ],
    this.bookedSlots = const [],
    this.reviews = const [],
  });

  bool isSlotBooked(String timeSlot) => bookedSlots.contains(timeSlot);

  String get formattedFeePerSession =>
      '${formatRupiah(feePerSession)} / session';

  static String formatRupiah(int amount) {
    final raw = amount.abs().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      if (i > 0 && (raw.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(raw[i]);
    }
    return 'Rp ${buffer.toString()}';
  }
}

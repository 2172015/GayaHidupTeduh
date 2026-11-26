enum DiaryAspect {
  god(
    shortLabel: 'God',
    numberedTitle: '1. Me & My God',
    question: 'Apakah hari ini kau sudah bercakap-cakap dengan Tuhan?',
    placeholder:
        'Sikap hatimu untuk menyapa Tuhan dengan penuh cinta hari ini. Pesan yang kau dapatkan pada waktu kau datang pada Tuhan dan berdoa. Peristiwa yang membuatmu merasa Tuhan sungguh hadir sangat dekat di hidupmu...',
  ),
  beloved(
    shortLabel: 'Beloved',
    numberedTitle: '2. Me & My Beloved',
    question: 'Apakah hari ini kau digerakkan Tuhan melakukan sesuatu untuk seseorang?',
    placeholder:
        'Hal-hal yang kau lakukan untuk menunjukkan kasih dan perhatian kepada orang-orang di sekitarmu. Kegiatan yang kau lakukan untuk membangun waktu yang berkualitas bersama keluarga...',
  ),
  feeling(
    shortLabel: 'Feeling',
    numberedTitle: '3. Me & My Feeling',
    question: 'Perasaan apa yang paling dominan hadir di hatimu hari ini?',
    placeholder:
        'Ceritakan emosi yang kamu rasakan hari ini, apa yang memicunya, dan bagaimana kamu merespons perasaan tersebut dengan jujur...',
  ),
  lifestyle(
    shortLabel: 'Lifestyle',
    numberedTitle: '4. Me & My Lifestyle',
    question: 'Bagaimana kamu menjaga ritme tubuh dan keseharianmu hari ini?',
    placeholder:
        'Kebiasaan baik, pola istirahat, olahraga, atau langkah kecil menjaga kesehatan fisik dan mental yang kamu lakukan hari ini...',
  ),
  passion(
    shortLabel: 'Passion',
    numberedTitle: '5. Me & My Passion',
    question: 'Hal bermakna apa yang kamu kerjakan atau pelajari hari ini?',
    placeholder:
        'Progres studi, karya, hobi, atau hal yang membuatmu bersemangat dan bertumbuh hari ini...',
  );

  final String shortLabel;
  final String numberedTitle;
  final String question;
  final String placeholder;

  const DiaryAspect({
    required this.shortLabel,
    required this.numberedTitle,
    required this.question,
    required this.placeholder,
  });
}
enum PaymentMethodType {
  qris(
    title: 'QRIS',
    subtitle: 'GoPay, OVO, Dana, Mobile Banking',
    logoAsset: 'assets/images/payment/Logo QRIS.png',
  ),
  bcaVirtualAccount(
    title: 'Bank Transfer',
    subtitle: 'Bank BCA',
    logoAsset: 'assets/images/payment/Logo BCA.png',
  );

  final String title;
  final String subtitle;
  final String logoAsset;

  const PaymentMethodType({
    required this.title,
    required this.subtitle,
    required this.logoAsset,
  });
}

enum UserGender {
  male(label: 'Laki-laki'),
  female(label: 'Perempuan'),
  preferNotToSay(label: 'Tidak ingin mencantumkan');

  final String label;

  const UserGender({required this.label});
}

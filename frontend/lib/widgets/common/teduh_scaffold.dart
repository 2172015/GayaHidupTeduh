import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/teduh_theme_extension.dart';

/// Kerangka dasar layar standar untuk **Gaya Hidup Teduh**.
///
/// Otomatis mengatur:
/// - Latar belakang gradasi (`useGradient: true`) atau polos *off-white* (`useGradient: false`).
/// - Header [AppBar] transparan dengan tombol kembali jika [title] diisi.
/// - Penempatan [bottomActionBar] yang menempel penuh hingga tepi bawah layar.
///
/// Contoh penggunaan:
/// ```dart
/// TeduhScaffold(
///   title: 'Edit Profile',
///   bottomActionBar: TeduhBottomActionBar.primary(
///     label: 'Save Changes',
///     onPressed: _save,
///   ),
///   body: SingleChildScrollView(...),
/// )
/// ```
class TeduhScaffold extends StatelessWidget {
  /// Konten utama di dalam layar.
  final Widget body;

  /// Judul halaman yang ditampilkan di tengah [AppBar].
  /// Jika `null`, [AppBar] tidak akan ditampilkan (cocok untuk halaman tab utama).
  final String? title;

  /// Mengganti [AppBar] bawaan dengan widget [PreferredSizeWidget] kustom.
  final PreferredSizeWidget? appBar;

  /// Daftar tombol aksi di sisi kanan [AppBar] (misalnya ikon hapus).
  final List<Widget>? appBarActions;

  /// Menentukan apakah tombol kembali (`<`) ditampilkan.
  /// Jika `null`, otomatis mengikuti `Navigator.canPop(context)`.
  final bool? showBackButton;

  /// Aksi kustom saat tombol kembali ditekan.
  final VoidCallback? onBackPressed;

  /// Jika `true` (default), layar memakai gradasi [TeduhThemeExtension.backgroundGradient].
  /// Jika `false`, layar memakai latar polos [AppColors.offWhite].
  final bool useGradient;

  /// Navigasi bawah utama ([TeduhBottomNav]) khusus untuk halaman tab.
  final Widget? bottomNavigationBar;

  /// Tombol aksi bawah (*sticky bar* seperti [TeduhBottomActionBar]) yang menempel ke dasar layar.
  final Widget? bottomActionBar;

  /// Tombol aksi mengambang ([FloatingActionButton]).
  final Widget? floatingActionButton;

  /// Mengaktifkan area aman (*SafeArea*) di sisi atas layar.
  final bool safeAreaTop;

  /// Mengaktifkan area aman (*SafeArea*) di sisi bawah layar.
  /// Otomatis menjadi `false` jika [bottomActionBar] digunakan.
  final bool safeAreaBottom;

  const TeduhScaffold({
    super.key,
    required this.body,
    this.title,
    this.appBar,
    this.appBarActions,
    this.showBackButton,
    this.onBackPressed,
    this.useGradient = true,
    this.bottomNavigationBar,
    this.bottomActionBar,
    this.floatingActionButton,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
  });

  PreferredSizeWidget? _buildResolvedAppBar(BuildContext context) {
    if (appBar != null) return appBar;
    if (title == null) return null;

    final canPop = showBackButton ?? Navigator.canPop(context);

    return AppBar(
      automaticallyImplyLeading: false,
      leading: canPop
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.forestGreen,
                size: 20,
              ),
              onPressed: onBackPressed ?? () => Navigator.maybePop(context),
            )
          : null,
      title: Text(title!),
      actions: appBarActions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final teduhTheme = TeduhThemeExtension.of(context);
    final resolvedAppBar = _buildResolvedAppBar(context);
    final effectiveSafeAreaBottom = bottomActionBar != null
        ? false
        : safeAreaBottom;

    return Scaffold(
      extendBodyBehindAppBar: resolvedAppBar != null,
      backgroundColor: teduhTheme.flatBackgroundColor,
      appBar: resolvedAppBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: useGradient
            ? BoxDecoration(gradient: teduhTheme.backgroundGradient)
            : BoxDecoration(color: teduhTheme.flatBackgroundColor),
        child: SafeArea(
          top: safeAreaTop,
          bottom: effectiveSafeAreaBottom,
          child: bottomActionBar == null
              ? body
              : Column(
                  children: [
                    Expanded(child: body),
                    bottomActionBar!,
                  ],
                ),
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

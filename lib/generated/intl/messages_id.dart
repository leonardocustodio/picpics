// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a id locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'id';

  static m0(howMany) => "${Intl.plural(howMany, zero: 'Tidak ada foto yang dipilih', one: '1 foto dipilih', other: '${howMany} foto dipilih')}";

  static m1(number) => "Anda menyelesaikan ${number} foto harian gratis Anda, apakah Anda ingin melanjutkan?";

  static m2(url) => "Untuk mengatur semua foto Anda, buka ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add_tag" : MessageLookupByLibrary.simpleMessage("Tambahkan tag"),
    "add_tags" : MessageLookupByLibrary.simpleMessage("Tambahkan tag"),
    "all_search_tags" : MessageLookupByLibrary.simpleMessage("Semua Tag Pencarian"),
    "auto_renewable_first_part" : MessageLookupByLibrary.simpleMessage("Berlangganan ini "),
    "auto_renewable_second_part" : MessageLookupByLibrary.simpleMessage("diperpanjang secara otomatis."),
    "cancel" : MessageLookupByLibrary.simpleMessage("Batal"),
    "cancel_anytime" : MessageLookupByLibrary.simpleMessage("Batalkan kapan saja"),
    "close" : MessageLookupByLibrary.simpleMessage("Tutup"),
    "continue_string" : MessageLookupByLibrary.simpleMessage("Lanjutkan"),
    "country" : MessageLookupByLibrary.simpleMessage("negara"),
    "daily_challenge" : MessageLookupByLibrary.simpleMessage("Tantangan harian"),
    "daily_challenge_permission_description" : MessageLookupByLibrary.simpleMessage("Agar kami dapat mengirimkan tantangan harian, kami memerlukan izin untuk mengirim notifikasi. Karena itu, Anda harus mengizinkan notifikasi pada opsi ponsel Anda."),
    "daily_goal" : MessageLookupByLibrary.simpleMessage("Misi harian"),
    "delete" : MessageLookupByLibrary.simpleMessage("Hapus"),
    "device_has_no_pics" : MessageLookupByLibrary.simpleMessage("Perangkat ini tidak memiliki foto di galeri, jadi tidak ada foto yang dapat diberi tag."),
    "edit_tag" : MessageLookupByLibrary.simpleMessage("Edit tag"),
    "export_all_gallery" : MessageLookupByLibrary.simpleMessage("Ekspor semua galeri"),
    "export_library" : MessageLookupByLibrary.simpleMessage("Ekspor Koleksi"),
    "family_tag" : MessageLookupByLibrary.simpleMessage("Keluarga"),
    "foods_tag" : MessageLookupByLibrary.simpleMessage("Makanan"),
    "full_screen" : MessageLookupByLibrary.simpleMessage("Layar penuh"),
    "gallery_access_permission" : MessageLookupByLibrary.simpleMessage("Izin akses"),
    "gallery_access_permission_description" : MessageLookupByLibrary.simpleMessage("Untuk mulai mengatur foto Anda, kami butuh izin untuk mengaksesnya"),
    "gallery_access_reason" : MessageLookupByLibrary.simpleMessage("Untuk mengatur foto, kami memerlukan akses ke galeri foto Anda"),
    "get_premium_description" : MessageLookupByLibrary.simpleMessage("UNTUK MEMILIKI SEMUA FITUR INI"),
    "get_premium_now" : MessageLookupByLibrary.simpleMessage("Berlangganan premium sekarang!"),
    "get_premium_title" : MessageLookupByLibrary.simpleMessage("BERLANGGANAN PREMIUM"),
    "home_tag" : MessageLookupByLibrary.simpleMessage("Rumah"),
    "how_many_pics" : MessageLookupByLibrary.simpleMessage("Berapa banyak foto"),
    "infinite_tags" : MessageLookupByLibrary.simpleMessage("Tag tanpa batas"),
    "language" : MessageLookupByLibrary.simpleMessage("Bahasa"),
    "month" : MessageLookupByLibrary.simpleMessage("bulan"),
    "next" : MessageLookupByLibrary.simpleMessage("Berikutnya"),
    "no_ads" : MessageLookupByLibrary.simpleMessage("Tanpa iklan"),
    "no_previous_purchase" : MessageLookupByLibrary.simpleMessage("Tidak Ada Pembelian Sebelumnya"),
    "no_tagged_photos" : MessageLookupByLibrary.simpleMessage("Anda belum memiliki foto yang diberi tag"),
    "no_tags_found" : MessageLookupByLibrary.simpleMessage("Tidak ada tag yang ditemukan"),
    "no_valid_subscription" : MessageLookupByLibrary.simpleMessage("Tidak dapat menemukan pembelian berlangganan yang valid."),
    "notification_time" : MessageLookupByLibrary.simpleMessage("Waktu notifikasi"),
    "notifications" : MessageLookupByLibrary.simpleMessage("Notifikasi"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "open_gallery" : MessageLookupByLibrary.simpleMessage("Buka galeri"),
    "organized_photos_description" : MessageLookupByLibrary.simpleMessage("Foto yang telah diberi tag"),
    "organized_photos_title" : MessageLookupByLibrary.simpleMessage("Foto yang Diatur"),
    "parties_tag" : MessageLookupByLibrary.simpleMessage("Pesta"),
    "pets_tag" : MessageLookupByLibrary.simpleMessage("Hewan peliharaan"),
    "photo_gallery_count" : m0,
    "photo_gallery_description" : MessageLookupByLibrary.simpleMessage("Foto belum diatur"),
    "photo_gallery_title" : MessageLookupByLibrary.simpleMessage("Galeri foto"),
    "photo_location" : MessageLookupByLibrary.simpleMessage("Lokasi foto"),
    "photos_always_organized" : MessageLookupByLibrary.simpleMessage("Kini, foto Anda akan selalu teratur"),
    "premium_modal_description" : m1,
    "premium_modal_get_premium_description" : MessageLookupByLibrary.simpleMessage("SEMUA FITUR TANPA IKLAN"),
    "premium_modal_get_premium_title" : MessageLookupByLibrary.simpleMessage("Dapatkan Akun Premium"),
    "premium_modal_watch_ad" : MessageLookupByLibrary.simpleMessage("Tonton iklan video untuk melanjutkan"),
    "privacy_policy" : MessageLookupByLibrary.simpleMessage("Kebijakan Privasi"),
    "rate_this_app" : MessageLookupByLibrary.simpleMessage("Beri peringkat aplikasi ini"),
    "restore_purchase" : MessageLookupByLibrary.simpleMessage("Pulihkan pembelian"),
    "save" : MessageLookupByLibrary.simpleMessage("simpan"),
    "save_location" : MessageLookupByLibrary.simpleMessage("Lokasi penyimpanan"),
    "screenshots_tag" : MessageLookupByLibrary.simpleMessage("Tangkapan layar"),
    "search" : MessageLookupByLibrary.simpleMessage("Cari..."),
    "search_all_tags_not_found" : MessageLookupByLibrary.simpleMessage("Tidak ada gambar yang ditemukan dengan semua tag di dalamnya."),
    "search_results" : MessageLookupByLibrary.simpleMessage("Hasil pencarian"),
    "selfies_tag" : MessageLookupByLibrary.simpleMessage("Selfie"),
    "settings" : MessageLookupByLibrary.simpleMessage("Pengaturan"),
    "share_with_friends" : MessageLookupByLibrary.simpleMessage("Bagikan dengan teman"),
    "sign" : MessageLookupByLibrary.simpleMessage("Tanda"),
    "sports_tag" : MessageLookupByLibrary.simpleMessage("Olah raga"),
    "start" : MessageLookupByLibrary.simpleMessage("Mulai"),
    "start_tagging" : MessageLookupByLibrary.simpleMessage("Mulai beri tag"),
    "suggestions" : MessageLookupByLibrary.simpleMessage("Saran"),
    "tag_multiple_photos_at_once" : MessageLookupByLibrary.simpleMessage("Beri tag banyak foto sekaligus"),
    "take_a_look" : MessageLookupByLibrary.simpleMessage("Lihatlah aplikasi ini!"),
    "take_a_look_description" : m2,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Ketentuan Penggunaan"),
    "time" : MessageLookupByLibrary.simpleMessage("Waktu"),
    "travel_tag" : MessageLookupByLibrary.simpleMessage("Perjalanan"),
    "tutorial_daily_package" : MessageLookupByLibrary.simpleMessage("Kami membawa paket harian untuk Anda untuk mengatur koleksi Anda secara berkala."),
    "tutorial_however_you_want" : MessageLookupByLibrary.simpleMessage("Atur foto Anda dengan menambahkan tag, seperti \'keluarga\', \'hewan peliharaan\', atau apa pun yang Anda inginkan."),
    "tutorial_just_swipe" : MessageLookupByLibrary.simpleMessage("Setelah menambahkan tag ke foto Anda, cukup geser untuk membuka yang berikutnya."),
    "welcome" : MessageLookupByLibrary.simpleMessage("Selamat datang!"),
    "work_tag" : MessageLookupByLibrary.simpleMessage("Kerja"),
    "year" : MessageLookupByLibrary.simpleMessage("tahun"),
    "you_are_premium" : MessageLookupByLibrary.simpleMessage("Anda adalah pengguna premium!")
  };
}

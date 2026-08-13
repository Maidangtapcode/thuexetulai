import 'package:intl/intl.dart';

/// Hàm format tiền: 720000 → 720K, 1500 → 1.5K, etc.
String formatPrice(double price) {
  if (price >= 1000000) {
    return '${(price / 1000000).toStringAsFixed(price % 1000000 == 0 ? 0 : 1)}M';
  } else if (price >= 1000) {
    return '${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}K';
  }
  return price.toStringAsFixed(0);
}

/// Hàm format tiền với dấu ngăn cách: 720000 → 720.000
String formatPriceWithSeparator(double price) {
  final formatter = NumberFormat('#,##0', 'vi_VN');
  return formatter.format(price);
}

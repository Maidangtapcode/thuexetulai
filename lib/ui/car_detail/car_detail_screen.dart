import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widget/searchmanager.dart';
import '../car_home/widget/cars_manager.dart';
import '../car_detail/widget/bao_hiem_bottom_sheet.dart';
import '../car_detail/widget/bao_hiem_chi_tiet_bottom_sheet.dart';
import '../car_detail/widget/report_car_screen.dart';
import '../car_detail/widget/cancel_policy_screen.dart';
import '../car_detail/widget/extra_fee_bottom_sheet.dart';
import '../car_detail/widget/rental_documents_bottom_sheet.dart';
import '../car_detail/widget/collateral_bottom_sheet.dart';
import '../car_detail/widget/dieu_khoan_section.dart';
import '../car_detail/widget/mo_ta_section.dart';
import '../car_detail/widget/reviews_screen.dart';
import '../car_detail/widget/owner_detail_screen.dart';
import '../../ui/widget/responsive_layout.dart';
import '../../models/car.dart';
import '../../utils/format_helper.dart';

class CarDetailScreen extends StatefulWidget {
  final String carId;
  const CarDetailScreen({super.key, required this.carId});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final car = context.read<CarsManager>().findById(widget.carId);
    if (car == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Lỗi"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: Text("Không tìm thấy xe. Vui lòng thử lại.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chi tiết xe",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),

      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context, car),
        tablet: _buildMobileLayout(context, car),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: _buildMobileLayout(context, car),
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomBar(context, car),
    );
  }

  Widget _buildMobileLayout(BuildContext context, Car car) {
    final List<String> carImagesToShow = car.imageUrls;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                if (carImagesToShow.isEmpty)
                  Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.directions_car,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemCount: carImagesToShow.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        carImagesToShow[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.error_outline,
                              size: 100,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      carImagesToShow.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 10 : 6,
                        height: _currentPage == index ? 10 : 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.teal
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      car.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.verified_user_outlined,
                      color: Colors.green,
                      size: 26,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      car.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.luggage, color: Colors.green, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${car.trips} chuyến',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/shield.svg',
                            width: 22,
                            height: 22,
                            colorFilter: const ColorFilter.mode(
                              Colors.green,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "Bảo hiểm thuê xe",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Chuyến đi có mua bảo hiểm. Khách thuê bồi thường tối đa 2.000.000 VNĐ trong trường hợp có sự cố ngoài ý muốn.",
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const BaoHiemBottomSheet(),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 20),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Xem thêm",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // BẢO HIỂM BỔ SUNG
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(value: false, onChanged: (val) {}),
                          const Text(
                            "Bảo hiểm người trên xe",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "Mới",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            "50.000đ/ngày",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Trường hợp xảy ra sự cố ngoài ý muốn, tài xế & người ngồi trên xe được bảo hiểm với giá trị tối đa 300.000.000 VNĐ/người.",
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) =>
                                const BaoHiemChiTietBottomSheet(),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 20),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Xem thêm",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                // ĐẶC ĐIỂM XE
                const SizedBox(height: 20),
                const Text(
                  "Đặc điểm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _CarStatItem(
                      iconPath: 'assets/images/icons/transmission.svg',
                      label: 'Truyền động',
                      value: car.gearbox,
                    ),
                    _CarStatItem(
                      iconPath: 'assets/images/icons/chair.svg',
                      label: 'Số ghế',
                      value: '${car.seats} chỗ',
                    ),
                    _CarStatItem(
                      iconPath: 'assets/images/icons/fuel.svg',
                      label: 'Nhiên liệu',
                      value: car.fuel,
                    ),
                    _CarStatItem(
                      iconPath: 'assets/images/icons/engine.svg',
                      label: 'Tiêu hao',
                      value: '7L/100km',
                    ),
                  ],
                ),
                const MoTaSection(),
                const SizedBox(height: 24),
                const Text(
                  "Các tiện nghi trên xe",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 4,
                  children: const [
                    _CarFeatureItem(icon: Icons.map, label: "Bản đồ"),
                    _CarFeatureItem(icon: Icons.bluetooth, label: "Bluetooth"),
                    _CarFeatureItem(icon: Icons.camera, label: "Camera 360"),
                    _CarFeatureItem(
                      icon: Icons.camera_rear,
                      label: "Camera lùi",
                    ),
                    _CarFeatureItem(
                      icon: Icons.location_pin,
                      label: "Định vị GPS",
                    ),
                    _CarFeatureItem(icon: Icons.usb, label: "Khe cắm USB"),
                    _CarFeatureItem(icon: Icons.album, label: "Lốp dự phòng"),
                    _CarFeatureItem(
                      icon: Icons.smart_display,
                      label: "Màn hình DVD",
                    ),
                    _CarFeatureItem(
                      icon: Icons.local_gas_station,
                      label: "ETC",
                    ),
                    _CarFeatureItem(
                      icon: Icons.safety_check,
                      label: "Túi khí an toàn",
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  "Chủ xe",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OwnerDetailScreen(
                                ownerName: "MICARRO Thủ Đức",
                                ownerAvatar: "assets/images/users/user.jpg",
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 28,
                              backgroundImage: AssetImage(
                                "assets/images/users/user.jpg",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "MICARRO Thủ Đức",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    SizedBox(width: 4),
                                    Text("5.0"),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.luggage,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                                    SizedBox(width: 4),
                                    Text("100+ chuyến"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Chủ xe 5★ có thời gian phản hồi nhanh chóng, tỉ lệ đồng ý cao, mức giá cạnh tranh & dịch vụ nhận được nhiều đánh giá tốt từ khách hàng.",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          _OwnerStatItem(
                            label: "Tỉ lệ phản hồi",
                            value: "100%",
                          ),
                          _OwnerStatItem(
                            label: "Phản hồi trong",
                            value: "5 phút",
                          ),
                          _OwnerStatItem(label: "Tỉ lệ đồng ý", value: "100%"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Đánh giá",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Column(
                  children: const [
                    _ReviewItem(
                      avatar: "assets/images/users/ro.jpg",
                      name: "NGUYỄN THÀNH SƠN",
                      date: "09/10/2025",
                      rating: 5,
                    ),
                    _ReviewItem(
                      avatar: "assets/images/users/user1.jpg",
                      name: "Thanh",
                      date: "09/10/2025",
                      rating: 5,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black, width: 2),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReviewsScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Xem thêm",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ====== GIẤY TỜ THUÊ XE ======
                Row(
                  children: [
                    const Text(
                      "Giấy tờ thuê xe",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const RentalDocumentsBottomSheet(),
                        );
                      },
                      child: const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "Chọn 1 trong 2 hình thức:",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/icons/id-card.svg',
                          width: 30,
                          height: 30,
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "GPLX (đối chiếu) & CCCD (đối chiếu VNeID)",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/icons/passport.svg',
                          width: 30,
                          height: 30,
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "GPLX (đối chiếu) & Passport (giữ lại)",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    const Text(
                      "Tài sản thế chấp",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const CollateralBottomSheet(),
                        );
                      },
                      child: const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "Không yêu cầu khách thuê thế chấp Tiền mặt hoặc Xe máy",
                  style: TextStyle(color: Colors.black87),
                ),
                const Divider(height: 32),

                //ĐIỀU KHOẢN
                const DieuKhoanSection(),
                const Divider(height: 32),
                const SizedBox(height: 16),
                const Text(
                  "Phụ phí có thể phát sinh",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _RowExtraFee(
                  title: "Phí vượt giới hạn",
                  detail:
                      "Phụ phí phát sinh nếu lộ trình di chuyển vượt quá 350km khi thuê xe 1 ngày",
                  value: "3.000đ /km",
                ),
                _RowExtraFee(
                  title: "Phí quá giờ",
                  detail:
                      "Phụ phí phát sinh nếu hoàn trả xe trễ giờ. Trường hợp trễ quá 5 giờ, phụ phí thêm 1 ngày thuê",
                  value: "70.000đ /giờ",
                ),
                _RowExtraFee(
                  title: "Phụ phí khác",
                  detail:
                      "Phụ phí phát sinh nếu trả xe không đảm bảo vệ sinh hoặc bị ám mùi",
                  value: "",
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const ExtraFeeBottomSheet(),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Xem thêm",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 1, color: Colors.grey),

                //Chính sách huỷ chuyến
                const SizedBox(height: 12),
                const Text(
                  "Chính sách huỷ chuyến",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "An tâm thuê xe, không lo bị huỷ chuyến với chính sách huỷ chuyến của Mioto!",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CancelPolicyScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Xem thêm ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Icon(Icons.chevron_right, size: 20, color: Colors.black),
                    ],
                  ),
                ),
                const Divider(thickness: 1, color: Colors.grey),

                //Báo cáo xe này
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReportCarScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: const [
                        Icon(Icons.flag_outlined, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          "Báo cáo xe này",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                            decorationThickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildBottomBar(BuildContext context, Car car) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Tổng tiền dự kiến",
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatPrice(car.oldPrice),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formatPrice(car.newPrice),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_offer,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            final searchManager = context.read<SearchManager>();
            if (searchManager.startDate == null ||
                searchManager.endDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Vui lòng quay lại Trang chủ để chọn ngày!"),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            context.push('/booking/${car.id}');
          },
          child: const Text(
            "Chọn thuê",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

class _CarFeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CarFeatureItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black87, size: 22),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}

class _CarStatItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;
  const _CarStatItem({
    required this.iconPath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 30,
          height: 30,
          colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _OwnerStatItem extends StatelessWidget {
  final String label;
  final String value;
  const _OwnerStatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String avatar;
  final String name;
  final String date;
  final int rating;

  const _ReviewItem({
    required this.avatar,
    required this.name,
    required this.date,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage(avatar)),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(date, style: const TextStyle(color: Colors.grey)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              rating.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowExtraFee extends StatelessWidget {
  final String title;
  final String detail;
  final String value;

  const _RowExtraFee({
    required this.title,
    required this.detail,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

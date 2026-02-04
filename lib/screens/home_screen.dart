import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/service_card.dart';
import '../widgets/staff_card.dart';
import '../widgets/salon_header.dart';
import '../routes/app_routes.dart' hide AppRoutes;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedServiceIndex = 0;

  final List<Map<String, dynamic>> salonInfo = [
    {
      'name': 'After8 Hair Salon',
      'rating': 4.8,
      'reviews': 246,
      'address': '123 Willows Street, Bloemfontein',
      'phone': '+27 (51) 123-4567',
      'hours': '9:00 AM - 8:00 PM',
      'image': 'assets/images/Fresh Fades.png',
      'description': 'Premium hair styling and beauty services',
    }
  ];

  final List<Map<String, dynamic>> featuredServices = [
    {
      'name': 'Hair Cutting',
      'category': 'Hair Services',
      'price': '\R45',
      'duration': '45 min',
      'icon': Icons.content_cut,
      'description': 'Professional haircut with styling',
      'image': 'assets/images/haircut.jpg',
    },
    {
      'name': 'Hair Coloring',
      'category': 'Hair Services',
      'price': '\R185',
      'duration': '90 min',
      'icon': Icons.palette,
      'description': 'Full color treatment with consultation',
      'image': 'assets/images/coloring.jpg',
    },
    {
      'name': 'Facial Treatment',
      'category': 'Skincare',
      'price': '\R165',
      'duration': '60 min',
      'icon': Icons.face,
      'description': 'Deep cleansing and rejuvenation',
      'image': 'assets/images/facial.jpg',
    },
    {
      'name': 'Manicure & Pedicure',
      'category': 'Nails',
      'price': '\R155',
      'duration': '60 min',
      'icon': Icons.brush,
      'description': 'Full nail care and polish',
      'image': 'assets/images/nails.jpg',
    },
  ];

  final List<Map<String, dynamic>> staffMembers = [
    {
      'name': 'Jabulile Mashibini',
      'title': 'Senior Stylist',
      'specialty': 'Hair Cutting & Coloring',
      'rating': 4.9,
      'reviews': 156,
      'image': 'assets/images/staff_sarah.jpg',
      'experience': '8 years',
    },
    {
      'name': 'Oscar Poco',
      'title': 'Beauty Specialist',
      'specialty': 'Facial & Skincare',
      'rating': 4.7,
      'reviews': 98,
      'image': 'assets/images/staff_emma.jpg',
      'experience': '6 years',
    },
    {
      'name': 'Sebabatso Molelle',
      'title': 'Nail Technician',
      'specialty': 'Manicure & Pedicure',
      'rating': 4.8,
      'reviews': 127,
      'image': 'assets/images/staff_lisa.jpg',
      'experience': '5 years',
    },
    {
      'name': 'Lwando Ndulula',
      'title': 'Makeup Artist',
      'specialty': 'Makeup & Bridal',
      'rating': 4.9,
      'reviews': 142,
      'image': 'assets/images/staff_jessica.jpg',
      'experience': '7 years',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToBooking() {
    Navigator.pushNamed(context, AppRoutes.booking);
  }

  void _navigateToServices() {
    Navigator.pushNamed(context, AppRoutes.services);
  }

  void _navigateToStaffDetail(Map<String, dynamic> staff) {
    Navigator.pushNamed(
      context,
      AppRoutes.staffDetail,
      arguments: staff,
    );
  }

  @override
  Widget build(BuildContext context) {
    final salon = salonInfo[0];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Salon Header
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                salon['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: SalonHeader(salonInfo: salon),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Salon Info Section
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating and reviews
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${salon['rating']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${salon['reviews']} reviews)',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Contact info
                      _buildInfoRow(
                        icon: Icons.location_on_outlined,
                        label: salon['address'],
                      ),
                      const SizedBox(height: 12),

                      _buildInfoRow(
                        icon: Icons.call_outlined,
                        label: salon['phone'],
                      ),
                      const SizedBox(height: 12),

                      _buildInfoRow(
                        icon: Icons.access_time_outlined,
                        label: salon['hours'],
                      ),

                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        salon['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // CTA Buttons Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildCTAButton(
                              label: 'Book Now',
                              onPressed: _navigateToBooking,
                              isPrimary: true,
                              icon: Icons.calendar_today_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildCTAButton(
                              label: 'View Services',
                              onPressed: _navigateToServices,
                              isPrimary: false,
                              icon: Icons.shopping_bag_outlined,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Featured Services Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Featured Services',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          GestureDetector(
                            onTap: _navigateToServices,
                            child: Text(
                              'See All',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Services Grid
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: featuredServices.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ServiceCard(
                            service: featuredServices[index],
                            onTap: () {
                              setState(() => _selectedServiceIndex = index);
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Staff Members Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Our Team',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to all staff
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Staff Horizontal Scroll
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: staffMembers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: index == 0
                                    ? AppSpacing.medium
                                    : AppSpacing.small,
                                right: index == staffMembers.length - 1
                                    ? AppSpacing.medium
                                    : 0,
                              ),
                              child: StaffCard(
                                staff: staffMembers[index],
                                onTap: () =>
                                    _navigateToStaffDetail(staffMembers[index]),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCTAButton({
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: isPrimary
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              )
            : null,
        border: isPrimary
            ? null
            : Border.all(
                color: AppColors.primary,
                width: 1.5,
              ),
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isPrimary ? Colors.white : AppColors.primary,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isPrimary ? Colors.white : AppColors.primary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

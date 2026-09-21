import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({Key? key}) : super(key: key);

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final List<Map<String, dynamic>> staffMembers = [
    {
      'name': 'Jabulile Mashibini',
      'title': 'Senior Stylist',
      'specialty': 'Hair Cutting & Coloring',
      'rating': 4.9,
      'reviews': 156,
      'experience': '8 years',
      'image': 'assets/images/staff_sarah.jpg',
    },
    {
      'name': 'Oscar Poco',
      'title': 'Beauty Specialist',
      'specialty': 'Facial & Skincare',
      'rating': 4.7,
      'reviews': 98,
      'experience': '6 years',
      'image': 'assets/images/staff_emma.jpg',
    },
    {
      'name': 'Sebabatso Molelle',
      'title': 'Nail Technician',
      'specialty': 'Manicure & Pedicure',
      'rating': 4.8,
      'reviews': 127,
      'experience': '5 years',
      'image': 'assets/images/staff_lisa.jpg',
    },
    {
      'name': 'Lwando Ndulula',
      'title': 'Makeup Artist',
      'specialty': 'Makeup & Bridal',
      'rating': 4.9,
      'reviews': 142,
      'experience': '7 years',
      'image': 'assets/images/staff_jessica.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Our Team'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.medium),
        itemCount: staffMembers.length,
        itemBuilder: (context, index) => _buildStaffCard(staffMembers[index]),
      ),
    );

  Widget _buildStaffCard(Map<String, dynamic> staff) => Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          children: [
            Row(
              children: [
                // Profile image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.6),
                        AppColors.primaryDark.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_outline,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                // Staff info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        staff['title'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        staff['specialty'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${staff['rating']}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${staff['reviews']} reviews)',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            // Experience
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.small,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppBorderRadius.small),
              ),
              child: Text(
                '${staff['experience']} of experience',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            // Book button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/booking',
                    arguments: {'staff': staff['name']},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.small,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                  ),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
}

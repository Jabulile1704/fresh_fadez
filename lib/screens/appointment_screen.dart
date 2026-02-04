import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final List<Map<String, dynamic>> appointments = [
    {
      'id': '1',
      'service': 'Hair Cutting',
      'staff': 'Jabulile Mashibini',
      'date': '2024-12-15',
      'time': '2:00 PM',
      'status': 'confirmed',
      'price': 'R45',
    },
    {
      'id': '2',
      'service': 'Facial Treatment',
      'staff': 'Oscar Poco',
      'date': '2024-12-20',
      'time': '3:30 PM',
      'status': 'pending',
      'price': 'R165',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Appointments'),
        centerTitle: true,
        elevation: 0,
      ),
      body: appointments.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.medium),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return _buildAppointmentCard(appointments[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Appointments Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book your first appointment to get started',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/booking');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.large,
                vertical: AppSpacing.medium,
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
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    Color statusColor = appointment['status'] == 'confirmed'
        ? AppColors.success
        : AppColors.warning;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appointment['service'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.small,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppBorderRadius.small),
                  ),
                  child: Text(
                    appointment['status'].toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Staff name
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  appointment['staff'],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Date and time
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  appointment['date'],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  appointment['time'],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price and action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appointment['price'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // Edit appointment
                      },
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // Cancel appointment
                      },
                      icon: const Icon(Icons.close_outlined, size: 16),
                      label: const Text('Cancel'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
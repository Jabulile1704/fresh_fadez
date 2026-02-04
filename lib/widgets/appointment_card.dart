import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../utils/constants.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onTap;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.onTap,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'confirmed':
        return AppColors.primary;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.serviceName,
                        style: TextStyle(
                          fontSize: AppFontSize.title,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.small),
                      Text(
                        'with ${appointment.stylistName}',
                        style: TextStyle(
                          fontSize: AppFontSize.small,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.medium,
                      vertical: AppSpacing.small,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(appointment.status)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Text(
                      appointment.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(appointment.status),
                        fontWeight: FontWeight.w600,
                        fontSize: AppFontSize.tiny,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.medium),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: AppSpacing.small),
                  Text(
                    appointment.formattedDate,
                    style: TextStyle(
                      fontSize: AppFontSize.small,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: AppSpacing.medium),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: AppSpacing.small),
                  Text(
                    appointment.appointmentTime,
                    style: TextStyle(
                      fontSize: AppFontSize.small,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.medium),
              Text(
                appointment.formattedPrice,
                style: TextStyle(
                  fontSize: AppFontSize.subtitle,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
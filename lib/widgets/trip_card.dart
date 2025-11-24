import 'package:flutter/material.dart';
import 'package:triptrack/theme/app_constants.dart';
import 'package:triptrack/theme/app_strings.dart';

class TripCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String budget;

  const TripCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppConstants.cardBorderRadius,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
            radius:
                AppConstants.avatarRadius *
                MediaQuery.of(context).textScaler.scale(1.0),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      // Added const here
                      width: 35, // Adjust as needed
                      height: 30, // Adjust as needed
                      child: PopupMenuButton<String>(
                        iconSize:
                            AppConstants.popupMenuIconSize, // Made smaller
                        onSelected: (String result) {
                          // Handle selection
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: AppStrings.edit,
                                child: Text(AppStrings.editTrip),
                              ),
                              const PopupMenuItem<String>(
                                value: AppStrings.delete,
                                child: Text(AppStrings.deleteTrip),
                              ),
                            ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: AppConstants.calendarIconSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Text(
                  budget,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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

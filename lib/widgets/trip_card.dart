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
        color: Colors.blueGrey[50],
        borderRadius: AppConstants.cardBorderRadius,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
            radius:
                AppConstants.avatarRadius *
                MediaQuery.of(context).textScaleFactor,
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
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
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
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: AppConstants.calendarIconSize,
                      color: AppConstants.greyColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppConstants.greyColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  budget,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppConstants.greyColor,
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

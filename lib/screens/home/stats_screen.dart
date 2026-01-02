import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triptrack/data/temp_data.dart';
import 'package:triptrack/models/entry.dart';
import 'package:triptrack/widgets/stats_summary_card.dart';
import 'package:intl/intl.dart';
import 'package:triptrack/providers/trip_provider.dart';
import 'package:triptrack/models/trip.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _selectedCategory = 'All';
  String _selectedCountry = 'All';
  String _selectedMonth = 'All';

  final List<String> _categories = [
    'All',
    'Food',
    'Transport',
    'Accommodation',
    'Entertainment',
    'Shopping',
  ];
  final List<String> _countries = ['All', 'USA', 'Canada', 'Mexico', 'Japan'];
  final List<String> _months = [
    'All',
    'January',
    'February',
    'March',
    'November',
    'December',
  ];

  late Map<String, Color> _categoryColors;

  // Data variables
  late List<Entry> _allEntries;
  double _totalSpending = 0;
  double _dailyAverage = 0;
  double _remainingDailyBudget = 0;
  double _surplus = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _allEntries = TempData.getDummyEntries();

    final List<Color> colors = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.tealAccent,
      Colors.pinkAccent,
    ];

    _categoryColors = {};
    final Set<String> uniqueCategories = _allEntries
        .map((entry) => entry.category?.name ?? 'General')
        .toSet();

    int colorIndex = 0;
    for (String category in uniqueCategories) {
      _categoryColors[category] = colors[colorIndex % colors.length];
      colorIndex++;
    }

    _totalSpending = _allEntries.fold(0, (sum, item) => sum + item.amount);
  }

  void _updateTripStats(Trip? activeTrip) {
    if (activeTrip != null) {
      final daysWithEntries = _allEntries
          .map((e) => DateFormat('yyyy-MM-dd').format(e.date))
          .toSet()
          .length;

      if (daysWithEntries > 0) {
        _dailyAverage = _totalSpending / daysWithEntries;
      } else {
        _dailyAverage = 0;
      }

      final today = DateTime.now();
      final todaySpending = _allEntries
          .where((e) => isSameDay(e.date, today))
          .fold(0.0, (sum, e) => sum + e.amount);

      _remainingDailyBudget = activeTrip.dailyBudget - todaySpending;
      _surplus = activeTrip.totalBudget - _totalSpending;
    } else {
      _dailyAverage = 0;
      _remainingDailyBudget = 0;
      _surplus = 0;
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final activeTripAsync = ref.watch(currentActiveTripProvider);

        return activeTripAsync.when(
          data: (activeTrip) {
            _updateTripStats(activeTrip);
            final currencySymbol = activeTrip?.homeCurrency ?? 'INR';

            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Daily Metrics',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryGrid(context, currencySymbol),
                      const SizedBox(height: 24),
                      _buildFilters(),
                      _buildPieChart(),
                      const SizedBox(height: 24),
                      _buildCategoryWiseSpendingList(),
                      const SizedBox(height: 24),
                      _buildExportButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        );
      },
    );
  }

  Widget _buildSummaryGrid(BuildContext context, String currencySymbol) {
    final currencyFormat = NumberFormat.simpleCurrency(name: currencySymbol);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        StatsSummaryCard(
          title: 'Daily Average',
          value: currencyFormat.format(_dailyAverage),
          onTap: () {},
        ),
        StatsSummaryCard(
          title: 'Remaining Daily Budget',
          value: currencyFormat.format(_remainingDailyBudget),
          onTap: () {},
        ),
        StatsSummaryCard(
          title: 'Total Spent',
          value: currencyFormat.format(_totalSpending),
          onTap: () {},
        ),
        StatsSummaryCard(
          title: 'Surplus',
          value: currencyFormat.format(_surplus),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildDropdown(
            _categories,
            _selectedCategory,
            'Category',
            (val) => setState(() => _selectedCategory = val!),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildDropdown(
            _countries,
            _selectedCountry,
            'Country',
            (val) => setState(() => _selectedCountry = val!),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildDropdown(
            _months,
            _selectedMonth,
            'Months',
            (val) => setState(() => _selectedMonth = val!),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String selectedValue,
    String placeholder,
    ValueChanged<String?> onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          hint: Text(
            placeholder,
            style: TextStyle(fontSize: 13, color: textColor),
          ),
          icon: Icon(Icons.keyboard_arrow_down, size: 20, color: textColor),
          onChanged: onChanged,
          borderRadius: BorderRadius.circular(16),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item == 'All' ? placeholder : item,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              );
            }).toList();
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final Map<String, double> categoryTotals = {};
    for (var entry in _allEntries) {
      final categoryName = entry.category?.name ?? 'General';
      categoryTotals[categoryName] =
          (categoryTotals[categoryName] ?? 0) + entry.amount;
    }

    if (categoryTotals.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text("No Data")));
    }

    final total = categoryTotals.values.fold(0.0, (sum, val) => sum + val);

    final List<PieChartSectionData> sections = [];

    categoryTotals.forEach((category, amount) {
      final percentage = (amount / total) * 100;
      final color = _categoryColors[category] ?? Colors.grey;

      IconData iconData = Icons.category;
      if (category == 'Flight') {
        iconData = Icons.flight;
      } else if (category == 'Accomodation') {
        iconData = Icons.hotel;
      } else if (category == 'Restaurant' || category == 'Food') {
        iconData = Icons.restaurant;
      } else if (category == 'Transportation' || category == 'Transport') {
        iconData = Icons.directions_bus;
      } else if (category == 'Shopping') {
        iconData = Icons.shopping_bag;
      }

      sections.add(
        PieChartSectionData(
          color: color,
          value: amount,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          titlePositionPercentageOffset: 2.2,
          badgeWidget: _Badge(iconData, size: 30, borderColor: color),
          badgePositionPercentageOffset: 1.6,
        ),
      );
    });

    return SizedBox(
      height: 340,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          CustomPaint(
            size: const Size(400, 400),
            painter: _PieChartConnectorPainter(
              sections: sections,
              centerSpaceRadius: 40,
            ),
          ),
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryWiseSpendingList() {
    final Map<String, double> categoryTotals = {};
    for (var entry in _allEntries) {
      final categoryName = entry.category?.name ?? 'General';
      categoryTotals[categoryName] =
          (categoryTotals[categoryName] ?? 0) + entry.amount;
    }

    final currencyFormat = NumberFormat.simpleCurrency(name: 'INR');

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryTotals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final category = categoryTotals.keys.elementAt(index);
        final amount = categoryTotals[category]!;

        IconData iconData = Icons.category;
        if (category == 'Flight') {
          iconData = Icons.flight;
        } else if (category == 'Accomodation') {
          iconData = Icons.hotel;
        } else if (category == 'Restaurant' || category == 'Food') {
          iconData = Icons.restaurant;
        } else if (category == 'Transportation' || category == 'Transport') {
          iconData = Icons.directions_bus;
        } else if (category == 'Shopping') {
          iconData = Icons.shopping_bag;
        }

        final categoryObj = _allEntries
            .firstWhere((e) => (e.category?.name ?? 'General') == category)
            .category;
        final color = categoryObj?.color != null
            ? Color(categoryObj!.color!)
            : (_categoryColors[category] ?? Colors.grey);

        return Container(
          decoration: BoxDecoration(
            color:
                Theme.of(context).cardTheme.color ??
                Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.05),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white, size: 20),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  currencyFormat.format(amount),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExportButton() {
    return Center(
      child: FilledButton.tonalIcon(
        onPressed: () {},
        icon: const Icon(Icons.download_rounded),
        label: const Text('Export CSV'),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.icon, {required this.size, required this.borderColor});
  final IconData icon;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Icon(icon, size: size * 0.6, color: Colors.black87),
      ),
    );
  }
}

class _PieChartConnectorPainter extends CustomPainter {
  final List<PieChartSectionData> sections;
  final double centerSpaceRadius;

  _PieChartConnectorPainter({
    required this.sections,
    required this.centerSpaceRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (sections.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    double totalValue = 0;
    for (var section in sections) {
      totalValue += section.value;
    }

    double startAngle = -90 * (math.pi / 180);

    for (var section in sections) {
      final sweepAngle = (section.value / totalValue) * 2 * math.pi;
      final midAngle = startAngle + (sweepAngle / 2);

      final sectionRadius = section.radius;
      final outerRadius = centerSpaceRadius + sectionRadius;
      final lineStartRadius = outerRadius;

      final badgePosition = section.badgePositionPercentageOffset;
      final lineEndRadius = centerSpaceRadius + (sectionRadius * badgePosition);

      final dxStart = center.dx + lineStartRadius * math.cos(midAngle);
      final dyStart = center.dy + lineStartRadius * math.sin(midAngle);

      final dxEnd = center.dx + lineEndRadius * math.cos(midAngle);
      final dyEnd = center.dy + lineEndRadius * math.sin(midAngle);

      final paint = Paint()
        ..color = section.color.withOpacity(0.5)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(dxStart, dyStart), Offset(dxEnd, dyEnd), paint);

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

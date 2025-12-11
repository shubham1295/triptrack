import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:triptrack/widgets/stats_summary_card.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _selectedCategory = 'All';
  String _selectedCountry = 'All';
  String _selectedMonth = 'All';

  final List<String> _categories = ['All', 'Food', 'Transport', 'Accommodation', 'Entertainment'];
  final List<String> _countries = ['All', 'USA', 'Canada', 'Mexico'];
  final List<String> _months = ['All', 'January', 'February', 'March'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryGrid(context),
            const SizedBox(height: 24),
            _buildFilters(),
            const SizedBox(height: 24),
            _buildPieChart(),
            const SizedBox(height: 24),
            _buildCategoryWiseSpending(),
            const SizedBox(height: 24),
            _buildExportButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        StatsSummaryCard(
          title: 'Daily Average',
          value: '\$120.50',
          onTap: () => _showInfoSheet(
            context,
            'Daily Average',
            'This is the average amount of money you have spent per day on your trip.',
          ),
        ),
        StatsSummaryCard(
          title: 'Remaining Daily Budget',
          value: '\$29.50',
          onTap: () => _showInfoSheet(
            context,
            'Remaining Daily Budget',
            'This is the remaining amount of your daily budget. It is calculated by subtracting your daily spending from your daily budget.',
          ),
        ),
        StatsSummaryCard(
          title: 'Total to Date',
          value: '\$1,446.00',
          onTap: () => _showInfoSheet(
            context,
            'Total to Date',
            'This is the total amount of money you have spent on your trip to date.',
          ),
        ),
        StatsSummaryCard(
          title: 'Surplus',
          value: '\$354.00',
          onTap: () => _showInfoSheet(
            context,
            'Surplus',
            'This is the amount of money you have saved from your budget. A positive value indicates a surplus, while a negative value indicates a deficit.',
          ),
        ),
      ],
    );
  }

  void _showInfoSheet(BuildContext context, String title, String info) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(info),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDropdown(_categories, _selectedCategory, (val) {
          setState(() {
            _selectedCategory = val!;
          });
        }),
        _buildDropdown(_countries, _selectedCountry, (val) {
          setState(() {
            _selectedCountry = val!;
          });
        }),
        _buildDropdown(_months, _selectedMonth, (val) {
          setState(() {
            _selectedMonth = val!;
          });
        }),
      ],
    );
  }

  Widget _buildDropdown(List<String> items, String selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildPieChart() {
    // Placeholder for Pie Chart
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(value: 40, title: 'Food', color: Colors.blue, radius: 50),
            PieChartSectionData(value: 30, title: 'Transport', color: Colors.green, radius: 50),
            PieChartSectionData(value: 15, title: 'Accommodation', color: Colors.orange, radius: 50),
            PieChartSectionData(value: 15, title: 'Entertainment', color: Colors.red, radius: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryWiseSpending() {
    // Placeholder for category wise spending list
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category-wise Spending',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            ListTile(
              leading: Icon(Icons.fastfood),
              title: Text('Food'),
              trailing: Text('\$482.00'),
            ),
            ListTile(
              leading: Icon(Icons.directions_bus),
              title: Text('Transport'),
              trailing: Text('\$361.50'),
            ),
            ListTile(
              leading: Icon(Icons.hotel),
              title: Text('Accommodation'),
              trailing: Text('\$180.75'),
            ),
            ListTile(
              leading: Icon(Icons.local_activity),
              title: Text('Entertainment'),
              trailing: Text('\$180.75'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExportButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement Export to CSV functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Export to CSV functionality coming soon!')),
          );
        },
        child: const Text('Export to CSV'),
      ),
    );
  }
}
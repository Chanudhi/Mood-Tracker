import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_theme.dart';
import '../services/data_service.dart';

class InsightsScreen extends StatefulWidget {
  @override
  _InsightsScreenState createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final DataService _dataService = DataService();
  late Future<Map<String, dynamic>> _weeklyStats;
  late Stream<List<Map<String, dynamic>>> _moodData;
  late Stream<List<Map<String, dynamic>>> _journalData;

  @override
  void initState() {
    super.initState();
    _weeklyStats = _dataService.getWeeklyStats();
    _moodData = _dataService.getMoodData();
    _journalData = _dataService.getJournalEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.mutedBlue.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Insights',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 24),
                _buildMoodTrendCard(),
                const SizedBox(height: 24),
                _buildJournalAnalysisCard(),
                const SizedBox(height: 24),
                _buildWeeklySummaryCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodTrendCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Trends',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _moodData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final moodData = snapshot.data!
                      .map((mood) => MoodData(
                            _formatDate(mood['date']),
                            mood['value'],
                          ))
                      .toList();
                  return SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 1,
                      interval: 0.2,
                    ),
                    series: <ChartSeries>[
                      SplineAreaSeries<MoodData, String>(
                        dataSource: moodData,
                        xValueMapper: (MoodData data, _) => data.date,
                        yValueMapper: (MoodData data, _) => data.mood,
                        color: AppTheme.sageGreen.withOpacity(0.3),
                        borderColor: AppTheme.sageGreen,
                        borderWidth: 2,
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalAnalysisCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Journal Analysis',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _journalData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final journalData = _analyzeJournalTopics(snapshot.data!);
                  return SfCircularChart(
                    series: <CircularSeries>[
                      DoughnutSeries<JournalData, String>(
                        dataSource: journalData,
                        xValueMapper: (JournalData data, _) => data.topic,
                        yValueMapper: (JournalData data, _) => data.count,
                        innerRadius: '60%',
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Summary',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          FutureBuilder<Map<String, dynamic>>(
            future: _weeklyStats,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final stats = snapshot.data!;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      'Mood',
                      _getMoodEmoji(stats['averageMood']),
                      '${(stats['averageMood'] * 100).toStringAsFixed(0)}%',
                    ),
                    _buildSummaryItem(
                      'Entries',
                      '📝',
                      stats['journalCount'].toString(),
                    ),
                    _buildSummaryItem(
                      'Streak',
                      '🔥',
                      '${stats['moodCount']} days',
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String emoji, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  String _getMoodEmoji(double value) {
    if (value < 0.3) return '😢';
    if (value < 0.6) return '😐';
    if (value < 0.8) return '🙂';
    return '😊';
  }

  List<JournalData> _analyzeJournalTopics(List<Map<String, dynamic>> entries) {
    final topics = <String, int>{};
    for (var entry in entries) {
      final content = entry['content'].toString().toLowerCase();
      if (content.contains('gratitude') || content.contains('thankful')) {
        topics['Gratitude'] = (topics['Gratitude'] ?? 0) + 1;
      }
      if (content.contains('challenge') || content.contains('difficult')) {
        topics['Challenges'] = (topics['Challenges'] ?? 0) + 1;
      }
      if (content.contains('goal') || content.contains('plan')) {
        topics['Goals'] = (topics['Goals'] ?? 0) + 1;
      }
      if (content.contains('reflect') || content.contains('learn')) {
        topics['Reflections'] = (topics['Reflections'] ?? 0) + 1;
      }
    }
    return topics.entries
        .map((e) => JournalData(e.key, e.value))
        .toList();
  }
}

class MoodData {
  final String date;
  final double mood;

  MoodData(this.date, this.mood);
}

class JournalData {
  final String topic;
  final int count;

  JournalData(this.topic, this.count);
} 
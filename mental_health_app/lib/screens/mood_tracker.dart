import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../theme/app_theme.dart';
import '../services/data_service.dart';

class MoodTrackerScreen extends StatefulWidget {
  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> with SingleTickerProviderStateMixin {
  int _selectedMood = 2; // 0-angry, 1-sad, 2-neutral, 3-happy, 4-excited
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final DataService _dataService = DataService();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, int> _moodData = {};
  List<MoodEntry> _recentMoods = [];

  final List<String> _moodEmojis = ['😡', '😢', '😐', '😊', '🤩'];
  final List<String> _moodLabels = ['Angry', 'Sad', 'Neutral', 'Happy', 'Excited'];
  final List<Color> _moodColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.grey,
    Colors.green,
    Colors.purpleAccent
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    _dataService.getMoodData().listen((moods) {
      setState(() {
        _moodData = {
          for (var mood in moods)
            DateTime(
              mood['date'].year,
              mood['date'].month,
              mood['date'].day,
            ): (mood['value'] is int ? mood['value'] : 2)
        };
        _recentMoods = moods
            .map((mood) => MoodEntry(
                  date: mood['date'],
                  moodIndex: (mood['value'] is int ? mood['value'] : 2),
                ))
            .toList()
            .reversed
            .take(7)
            .toList();
      });
    });
  }

  Future<void> _saveMood() async {
    _animationController.forward().then((_) => _animationController.reverse());
    _confettiController.play();
    await _dataService.saveMood(_selectedMood.toDouble(), _selectedDay ?? DateTime.now());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mood saved! ${_moodEmojis[_selectedMood]}'),
        backgroundColor: _moodColors[_selectedMood],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lavender.withOpacity(0.5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                // Mascot
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.1),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/mascot.png',
                          fit: BoxFit.cover,
                          width: 96,
                          height: 96,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'How are you feeling?',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
                const SizedBox(height: 8),
                // Mood faces row
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_moodEmojis.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMood = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _selectedMood == index ? _moodColors[index].withOpacity(0.2) : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: _selectedMood == index ? _moodColors[index] : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _moodEmojis[index],
                                  style: TextStyle(fontSize: _selectedMood == index ? 40 : 32),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _moodLabels[index],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _selectedMood == index ? _moodColors[index] : Colors.grey,
                                    fontWeight: _selectedMood == index ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Calendar
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.08),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        if (_moodData.containsKey(selectedDay)) {
                          _selectedMood = _moodData[selectedDay]!;
                        } else {
                          _selectedMood = 2;
                        }
                      });
                    },
                    calendarStyle: CalendarStyle(
                      markersMaxCount: 1,
                      markerDecoration: BoxDecoration(
                        color: _moodColors[_selectedMood],
                        shape: BoxShape.circle,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (_moodData.containsKey(date)) {
                          int moodIdx = _moodData[date]!;
                          return Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _moodColors[moodIdx],
                              shape: BoxShape.circle,
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                // Mood History
                if (_recentMoods.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.06),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mood History', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.deepPurple)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 56,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _recentMoods.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, idx) {
                              final entry = _recentMoods[idx];
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: _moodColors[entry.moodIndex].withOpacity(0.2),
                                    child: Text(_moodEmojis[entry.moodIndex], style: const TextStyle(fontSize: 20)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "${entry.date.month}/${entry.date.day}",
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Mood Trends Graph (always visible)
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.06),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mood Trends (Last 7 Days)', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.deepPurple)),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 120,
                        child: (_recentMoods.length > 1)
                            ? SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis: NumericAxis(
                                  minimum: 0,
                                  maximum: 4,
                                  interval: 1,
                                  isVisible: false,
                                ),
                                series: <ChartSeries<MoodEntry, String>>[
                                  SplineAreaSeries<MoodEntry, String>(
                                    dataSource: _recentMoods.reversed.take(7).toList(),
                                    xValueMapper: (MoodEntry entry, _) => "${entry.date.month}/${entry.date.day}",
                                    yValueMapper: (MoodEntry entry, _) => entry.moodIndex,
                                    color: Colors.deepPurple.withOpacity(0.2),
                                    borderColor: Colors.deepPurple,
                                    borderWidth: 2,
                                    markerSettings: const MarkerSettings(isVisible: true),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'Not enough data yet. Save more moods to see your weekly trend!',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_moodLabels.length, (i) => Text(_moodLabels[i], style: TextStyle(fontSize: 10, color: _moodColors[i]))),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _saveMood,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _moodColors[_selectedMood],
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Save Mood'),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: pi / 2,
                    maxBlastForce: 5,
                    minBlastForce: 2,
                    emissionFrequency: 0.05,
                    numberOfParticles: 50,
                    gravity: 0.1,
                    colors: _moodColors,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class MoodEntry {
  final DateTime date;
  final int moodIndex;
  MoodEntry({required this.date, required this.moodIndex});
}
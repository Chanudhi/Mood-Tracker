import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  // Mood Data Operations
  Future<void> saveMood(double moodValue, DateTime date) async {
    await _firestore.collection('users').doc(_userId).collection('moods').add({
      'value': moodValue,
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getMoodData() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('moods')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'value': doc['value'],
                  'date': (doc['date'] as Timestamp).toDate(),
                })
            .toList());
  }

  // Journal Data Operations
  Future<void> saveJournalEntry(String content, DateTime date) async {
    await _firestore.collection('users').doc(_userId).collection('journals').add({
      'content': content,
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getJournalEntries() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('journals')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'content': doc['content'],
                  'date': (doc['date'] as Timestamp).toDate(),
                })
            .toList());
  }

  // Analytics Data
  Future<Map<String, dynamic>> getWeeklyStats() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final moodsSnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('moods')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(weekAgo))
        .get();

    final journalsSnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('journals')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(weekAgo))
        .get();

    double averageMood = 0;
    if (moodsSnapshot.docs.isNotEmpty) {
      averageMood = moodsSnapshot.docs
              .map((doc) => doc['value'] as double)
              .reduce((a, b) => a + b) /
          moodsSnapshot.docs.length;
    }

    return {
      'averageMood': averageMood,
      'journalCount': journalsSnapshot.docs.length,
      'moodCount': moodsSnapshot.docs.length,
    };
  }
} 
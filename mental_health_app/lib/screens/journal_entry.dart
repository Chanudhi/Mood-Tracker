import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api_service.dart';
import '../services/encryption_service.dart';

class JournalEntryScreen extends StatefulWidget {
  @override
  _JournalEntryScreenState createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveEntry() async {
    final text = _controller.text;
    final encryptedText = await EncryptionService.encrypt(text);
    
    // Save to Firestore
    await _firestore.collection('journals').add({
      'text': encryptedText,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Analyze sentiment
    final sentiment = await ApiService.analyzeSentiment(text);
    
    // Save insights
    await _firestore.collection('insights').add({
      'sentiment': sentiment['sentiment'],
      'confidence': sentiment['confidence'],
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Journal Entry')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'How are you feeling today?',
                  border: InputBorder.none,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _saveEntry,
              child: Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
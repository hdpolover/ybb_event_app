import 'package:flutter/material.dart';

class PaperTab extends StatefulWidget {
  const PaperTab({super.key});

  @override
  State<PaperTab> createState() => _PaperTabState();
}

class _PaperTabState extends State<PaperTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paper',
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AbstractTab extends StatefulWidget {
  const AbstractTab({super.key});

  @override
  State<AbstractTab> createState() => _AbstractTabState();
}

class _AbstractTabState extends State<AbstractTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Abstract',
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

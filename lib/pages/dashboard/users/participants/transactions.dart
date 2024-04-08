import 'package:flutter/material.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonMethods().buildCommonAppBar("Transactions"),
      body: const Center(
        child: Text("Transactions"),
      ),
    );
  }
}

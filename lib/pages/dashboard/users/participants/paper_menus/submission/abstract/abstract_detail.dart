import 'package:flutter/material.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/paper_abstract_model.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

class AbstractDetail extends StatelessWidget {
  final PaperAbstractModel abstract;
  const AbstractDetail({super.key, required this.abstract});

  buildStatusChip() {
    String statusText = "";
    Color statusColor = Colors.grey;

    switch (abstract.status) {
      case "0":
        statusText = "Created";
        statusColor = Colors.grey;
        break;
      case "1":
        statusText = "In review";
        statusColor = Colors.orange;
        break;
      case "2":
        statusText = "Accepted";
        statusColor = Colors.green;
        break;
      default:
        statusText = "Unknown";
        statusColor = Colors.grey;
    }

    String formattedDate = CommonMethods().formatDate(abstract.updatedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Chip(
          label: Text(
            statusText,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: statusColor,
        ),
        const SizedBox(height: 10),
        // updated at
        Text(
          'Updated at: $formattedDate',
          style: bodyTextStyle.copyWith(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: buildStatusChip(),
          ),
          const SizedBox(height: 20),
          CommonMethods().buildItemDetail('Abstract Title', abstract.title!),
          CommonMethods()
              .buildItemDetail('Abstract Content', abstract.content!),
          CommonMethods().buildItemDetail('Keywords', abstract.keywords!),
        ],
      ),
    );
  }
}

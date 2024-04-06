import 'package:flutter/material.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/faq_model.dart';
import 'package:ybb_event_app/pages/landing_pages/faq/components/faq_category_list.dart';

class FaqList extends StatelessWidget {
  final List<FaqModel>? faqs;
  const FaqList({super.key, this.faqs});

  @override
  Widget build(BuildContext context) {
    // group faqs by category, category must be unique
    Map<String, List<FaqModel>> faqDataFromCategory = {};

    for (var faq in faqs!) {
      if (faqDataFromCategory.containsKey(faq.faqCategory)) {
        faqDataFromCategory[faq.faqCategory]!.add(faq);
      } else {
        faqDataFromCategory[faq.faqCategory!] = [faq];
      }
    }

    // return column for each category with faqCategoryList class
    return Padding(
      padding: blockPadding(context),
      child: Column(
        children: [
          for (var category in faqDataFromCategory.keys)
            FaqCategoryList(
              category: category,
              faqs: faqDataFromCategory[category]!,
            ),
        ],
      ),
    );
  }
}

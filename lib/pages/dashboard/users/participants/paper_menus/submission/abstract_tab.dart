import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ybb_event_app/utils/common_methods.dart';

class AbstractTab extends StatefulWidget {
  const AbstractTab({super.key});

  @override
  State<AbstractTab> createState() => _AbstractTabState();
}

class _AbstractTabState extends State<AbstractTab> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey _titleKey = GlobalKey<FormBuilderFieldState>();
  // content key, keywords key
  final GlobalKey _contentKey = GlobalKey<FormBuilderFieldState>();
  final GlobalKey _keywordsKey = GlobalKey<FormBuilderFieldState>();

  _buildAbstractForm() {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            CommonMethods().buildTextField(
              _titleKey,
              'title',
              'Title',
              [FormBuilderValidators.required()],
            ),
            CommonMethods().buildTextField(
              _contentKey,
              'content',
              'Content',
              [
                FormBuilderValidators.required(),
                // max words are 250, create a custom validator
                (val) {
                  if (val.split(' ').length > 2) {
                    return 'Content must be less than 250 words';
                  }
                  return null;
                }
              ],
              lines: 20,
            ),
            CommonMethods().buildTextField(
              _keywordsKey,
              'keywords',
              'Keywords',
              [
                FormBuilderValidators.required(),
                // keywords max words are 5, create a custom validator
                (val) {
                  if (val.split(',').length > 5 || val.split(',').length < 1) {
                    return 'Keywords must be less than 5 words';
                  }
                  return null;
                }
              ],
            ),
          ],
        ));
  }

  _buildRevisions() {
    return const Column(
      children: [
        Text(
          'Revisions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'You can make revisions to your abstract until the deadline.',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          'Deadline: 12/12/2021',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAbstractForm(),
            const SizedBox(height: 20),
            _buildRevisions(),
          ],
        ),
      ),
    );
  }
}

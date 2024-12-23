import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:package_rename/package_rename.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/typography.dart';
import 'package:ybb_event_app/models/paper_abstract_model.dart';
import 'package:ybb_event_app/pages/landing_pages/widgets/loading_widget.dart';
import 'package:ybb_event_app/providers/paper_provider.dart';
import 'package:ybb_event_app/providers/program_provider.dart';
import 'package:ybb_event_app/services/paper_abstract_service.dart';
import 'package:ybb_event_app/services/paper_detail_service.dart';
import 'package:ybb_event_app/services/paper_topic_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';

class AddEditAbstract extends StatefulWidget {
  final PaperAbstractModel? paperAbstract;
  const AddEditAbstract({super.key, this.paperAbstract});

  static const routeName = 'add-edit-abstract';
  static const pathName = '/add-edit-abstract';

  @override
  State<AddEditAbstract> createState() => _AddEditAbstractState();
}

class _AddEditAbstractState extends State<AddEditAbstract> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _titleKey = GlobalKey<FormBuilderFieldState>();
  final _contentKey = GlobalKey<FormBuilderFieldState>();
  final _keywordKey = GlobalKey<FormBuilderFieldState>();

  bool isLoading = false;

  String title = '';
  String content = '';
  String keyword = '';

  @override
  void initState() {
    super.initState();

    setData();
    getTopicData();
  }

  getTopicData() async {
    String programId = Provider.of<ProgramProvider>(context, listen: false)
        .currentProgram!
        .id!;
    // get the data
    await PaperTopicService().getAll(programId).then((value) {
      if (value != null || value!.isNotEmpty) {
        value.removeWhere((element) => element.topicName == "all");
      }

      Provider.of<PaperProvider>(context, listen: false).setPaperTopics(value);
    }).catchError((e) {
      print(e);
    });
  }

  buildTopicDropdown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Topic",
          style: bodyTextStyle.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          ("Select a topic for your abstract and paper"),
          style: bodyTextStyle.copyWith(color: Colors.red),
        ),
        const SizedBox(height: 15),
        Consumer<PaperProvider>(
          builder: (context, paperProv, child) {
            return FormBuilderDropdown(
              name: 'topic',
              hint: Text('Select Topic'),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: paperProv.paperTopics!
                  .map((topic) => DropdownMenuItem(
                        value: topic.id,
                        child: Text(topic.topicName!),
                      ))
                  .toList(),
              validator: FormBuilderValidators.required(),
              initialValue: Provider.of<PaperProvider>(context, listen: false)
                  .currentPaperDetail!
                  .paperTopicId,
            );
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  setData() {
    if (widget.paperAbstract != null) {
      title = widget.paperAbstract!.title!;
      content = widget.paperAbstract!.content!;
      keyword = widget.paperAbstract!.keywords!;

      setState(() {});
    }
  }

  updateData() {
    setState(() {
      isLoading = true;
    });

    // update the data
    Map<String, dynamic> data = {
      'title': _titleKey.currentState!.value,
      'content': _contentKey.currentState!.value,
      'keywords': _keywordKey.currentState!.value,
    };

    PaperAbstractService()
        .update(data, widget.paperAbstract!.id!)
        .then((value) {
      setState(() {
        isLoading = false;
      });

      Provider.of<PaperProvider>(context, listen: false)
          .setCurrentPaperAbstract(value);

      // show success dialog
      DialogManager.showAlertDialog(
          context, "Abstract has been updated successfully", pressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop(
            // return isLoading = false
            false);
      }, isGreen: true);
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });

      // show error dialog
      DialogManager.showAlertDialog(context, 'Failed to update the abstract',
          pressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    });
  }

  saveData() async {
    setState(() {
      isLoading = true;
    });

    // save the data
    Map<String, dynamic> data = {
      'title': _titleKey.currentState!.value,
      'content': _contentKey.currentState!.value,
      'keywords': _keywordKey.currentState!.value,
      'status': '0',
    };

    await PaperAbstractService().save(data).then((value) async {
      Provider.of<PaperProvider>(context, listen: false)
          .setCurrentPaperAbstract(value);

      String paperDetailId = Provider.of<PaperProvider>(context, listen: false)
          .currentPaperDetail!
          .id!;

      print(paperDetailId);

      String programId = Provider.of<PaperProvider>(context, listen: false)
          .currentPaperDetail!
          .programId!;

      Map<String, dynamic> paperData = {
        'paper_abstract_id': value.id,
        'paper_topic_id': _formKey.currentState!.value['topic'],
        'program_id': programId,
      };

      print(paperData);

      // update paper detail
      await PaperDetailService().update(paperData, paperDetailId).then((paper) {
        setState(() {
          isLoading = false;
        });

        Provider.of<PaperProvider>(context, listen: false)
            .setCurrentPaperDetail(paper);

        // show success dialog
        DialogManager.showAlertDialog(
            context, "Abstract has been saved successfully", pressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }, isGreen: true);
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });

        // show error dialog
        DialogManager.showAlertDialog(context, 'Failed to save the abstract',
            pressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      });
    }).catchError((e) {
      print(e);

      setState(() {
        isLoading = false;
      });

      // show error dialog
      DialogManager.showAlertDialog(context, 'Failed to save the abstract',
          pressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonMethods().buildCommonAppBar(context, 'Add Abstract'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTopicDropdown(),
                CommonMethods().buildTextField(
                    _titleKey,
                    'title',
                    'Title',
                    [
                      FormBuilderValidators.required(),
                      (value) {
                        // maks 15 words
                        if (value.toString().split(' ').length > 15) {
                          return 'Title must be less than 15 words';
                        }
                      }
                    ],
                    desc: "Maximum of 15 words",
                    initial: title),
                CommonMethods().buildTextField(
                  _contentKey,
                  'content',
                  'Content',
                  [
                    FormBuilderValidators.required(),
                    // maks 250 words
                    (value) {
                      if (value.toString().split(' ').length > 250) {
                        return 'Content must be less than 250 words';
                      }
                    }
                  ],
                  lines: 5,
                  desc: "Maximum of 250 words",
                  initial: content,
                ),
                CommonMethods().buildTextField(
                  _keywordKey,
                  'keyword',
                  'Keyword',
                  [
                    FormBuilderValidators.required(),
                    // maks 5 words, separated by comma
                    (value) {
                      if (value.toString().split(',').length > 5) {
                        return 'Keywords must be less than 5 words';
                      }
                    }
                  ],
                  desc:
                      'Separate the keywords by comma (Maximum of 5 words). Example: keyword1, keyword2',
                  initial: keyword,
                ),
                isLoading
                    ? const LoadingWidget()
                    : CommonMethods().buildCustomButton(
                        text: widget.paperAbstract == null ? 'Save' : 'Update',
                        color: widget.paperAbstract == null
                            ? Colors.blue
                            : Colors.orange,
                        onPressed: () {
                          if (_formKey.currentState!.saveAndValidate()) {
                            print(_formKey.currentState!.value);

                            if (widget.paperAbstract != null) {
                              // update the data
                              updateData();
                            } else {
                              // save the data
                              DialogManager.showConfirmationDialog(context,
                                  'Are you sure you want to save this abstract? You cannot edit it later unless you have some revisions.',
                                  () {
                                saveData();
                              });
                            }
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

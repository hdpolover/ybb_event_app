import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/models/paper_author_model.dart';
import 'package:ybb_event_app/pages/dashboard/components/menu_card.dart';
import 'package:ybb_event_app/pages/dashboard/users/participants/paper_menus/submission/author/add_edit_author.dart';
import 'package:ybb_event_app/providers/paper_provider.dart';
import 'package:ybb_event_app/services/paper_author_service.dart';
import 'package:ybb_event_app/utils/common_methods.dart';
import 'package:ybb_event_app/utils/dialog_manager.dart';
import 'package:ybb_event_app/utils/screen_size_helper.dart';

class AuthorItem extends StatelessWidget {
  final PaperAuthorModel paperAuthor;
  const AuthorItem({super.key, required this.paperAuthor});

  _buildButton(BuildContext context) {
    var paperProvider = Provider.of<PaperProvider>(context, listen: false);

    PaperAuthorModel currentAuthor = paperProvider.currentAuthor!;

    List<Widget> buttons = [
      CommonMethods().buildCustomButton(
        width: ScreenSizeHelper.responsiveValue(context,
            mobile: double.infinity, desktop: 100),
        color: Colors.orange,
        text: "Edit",
        onPressed: () {
          // update author
          context.pushNamed(
            AddEditAuthor.routeName,
            extra: paperAuthor,
          );
        },
      ),
      const SizedBox(width: 10),
      currentAuthor.id == paperAuthor.id
          ? Container()
          : CommonMethods().buildCustomButton(
              width: ScreenSizeHelper.responsiveValue(context,
                  mobile: double.infinity, desktop: 100),
              color: Colors.red,
              text: "Delete",
              onPressed: () {
                // delete author
                DialogManager.showConfirmationDialog(
                  context,
                  "Are you sure you want to delete this author? This action cannot be undone.",
                  () async {
                    await PaperAuthorService().delete(paperAuthor.id!).then(
                      (value) {
                        paperProvider.removeAuthor(paperAuthor.id!);
                      },
                    );
                  },
                );
              },
            )
    ];
    return ScreenSizeHelper.responsiveValue(context,
        desktop: Row(
          children: buttons,
        ),
        mobile: Column(
          children: buttons,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ScreenSizeHelper.responsiveValue(
          context,
          desktop: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paperAuthor.name!,
                    style: bodyTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    paperAuthor.institution!,
                    style: bodyTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    paperAuthor.email!,
                    style: bodyTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
              _buildButton(context),
            ],
          ),
          mobile: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                paperAuthor.name!,
                style: bodyTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                paperAuthor.institution!,
                style: bodyTextStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                paperAuthor.email!,
                style: bodyTextStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              _buildButton(context),
            ],
          ),
        ));
  }
}

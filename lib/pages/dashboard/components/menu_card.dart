import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ybb_event_app/components/components.dart';
import 'package:ybb_event_app/pages/dashboard/components/menu_card_model.dart';

class MenuCard extends StatelessWidget {
  final MenuCardModel menuCard;

  const MenuCard({super.key, required this.menuCard});

  @override
  Widget build(BuildContext context) {
    // make the container clickable
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: menuCard.isActive
            ? () {
                context.pushNamed(menuCard.route);
              }
            : null,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: menuCard.isActive ? Colors.white : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            // give a shadow effect to the card
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
            // add a border to the card
            border: Border.all(
              color: menuCard.isActive ? primary : Colors.grey,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FaIcon(
                menuCard.icon,
                size: 50,
                color: menuCard.isActive ? primary : Colors.grey,
              ),
              const SizedBox(height: 10),
              AutoSizeText(
                menuCard.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              AutoSizeText(
                menuCard.desc,
                softWrap: true,
                textAlign: TextAlign.center,
                style: bodyTextStyle.copyWith(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              Visibility(
                visible: menuCard.statusText != null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    AutoSizeText(menuCard.statusText ?? "",
                        textAlign: TextAlign.center,
                        style: bodyTextStyle.copyWith(
                          color: primary,
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ))
                  ],
                ),
              ),
              Visibility(
                visible: !menuCard.isActive,
                child: const Column(
                  children: [
                    SizedBox(height: 20),
                    Text("Currently unavailable",
                        style: TextStyle(color: Colors.red, fontSize: 12))
                  ],
                ),
              )
              // const SizedBox(height: 10),
              // // build a chip to show status
              // Chip(
              //   // remove chip border color
              //   shadowColor: Colors.transparent,
              //   label: Text(
              //     menuCard.isActive ? "Active" : "Inactive",
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 12,
              //     ),
              //   ),
              //   backgroundColor: menuCard.isActive ? Colors.green : Colors.red,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

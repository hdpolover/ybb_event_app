import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ybb_event_app/models/program_info_by_url_model.dart';
import 'package:ybb_event_app/models/program_photo_model.dart';
import 'package:ybb_event_app/utils/app_router_config.dart';

class AuthImageSection extends StatelessWidget {
  final ProgramPhotoModel? programPhoto;
  final ProgramInfoByUrlModel? programInfo;
  const AuthImageSection({super.key, this.programPhoto, this.programInfo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(homeRouteName);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(programPhoto!.imgUrl!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.9), BlendMode.darken),
              ),
            ),
          ),
          // position the image to center
          SizedBox(
            width: 200,
            height: 200,
            child: Image.network(
              programInfo!.logoUrl!,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

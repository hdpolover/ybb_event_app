// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late YoutubePlayerController _controller;

//   late PlayerState _playerState;
//   late YoutubeMetaData _videoMetaData;
//   double _volume = 100;
//   bool _muted = false;
//   bool _isPlayerReady = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: 'nPt8bK2gbaU',
//       flags: const YoutubePlayerFlags(
//         mute: false,
//         autoPlay: true,
//         disableDragSeek: false,
//         loop: false,
//         isLive: false,
//         forceHD: false,
//         enableCaption: true,
//       ),
//     )..addListener(listener);
//     _videoMetaData = const YoutubeMetaData();
//     _playerState = PlayerState.unknown;
//   }

//   void listener() {
//     if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
//       setState(() {
//         _playerState = _controller.value.playerState;
//         _videoMetaData = _controller.metadata;
//       });
//     }
//   }

//   @override
//   void deactivate() {
//     // Pauses video while navigating to next page.
//     _controller.pause();
//     super.deactivate();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: YoutubePlayer(
//         controller: _controller,
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: Colors.blueAccent,
//         topActions: <Widget>[
//           const SizedBox(width: 8.0),
//           Expanded(
//             child: Text(
//               _controller.metadata.title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18.0,
//               ),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 1,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.settings,
//               color: Colors.white,
//               size: 25.0,
//             ),
//             onPressed: () {
//               log('Settings Tapped!');
//             },
//           ),
//         ],
//         onReady: () {
//           _isPlayerReady = true;
//         },
//         onEnded: (data) {
//           // _controller
//           //     .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
//         },
//       ),
//     );
//   }
// }

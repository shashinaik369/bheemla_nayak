import 'package:flutter/material.dart';
import 'package:tiktok_tutorial/constants.dart';
import 'package:tiktok_tutorial/controllers/auth_controller.dart';
import 'package:tiktok_tutorial/controllers/profile_controller.dart';
import 'package:tiktok_tutorial/controllers/search_controller.dart';
import 'package:tiktok_tutorial/controllers/upload_video_controller.dart';

import 'package:tiktok_tutorial/controllers/video_controller.dart';
import 'package:tiktok_tutorial/models/user.dart';
import 'package:tiktok_tutorial/views/screens/comment_screen.dart';
import 'package:tiktok_tutorial/views/screens/profile_screen.dart';

import 'package:tiktok_tutorial/views/widgets/circle_animation.dart';
import 'package:tiktok_tutorial/views/widgets/video_player_iten.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class VideoScreen extends StatelessWidget {
  VideoScreen({Key? key}) : super(key: key);

  final VideoController videoController = Get.put(VideoController());
  final ProfileController profileController = Get.put(ProfileController());
  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 65,
      height: 65,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: videoController.videoList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videoController.videoList[index];
            return Stack(
              children: [
                VideoPlayerItem(
                  videoUrl: data.videoUrl,
                ),
                Positioned(
                  bottom: 50,
                  left: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (data.uid == authController.user.uid) {
                            uploadVideoController.deleteVideo(data.id);
                            uploadVideoController.deleteGif(data.gif);
                          }
                        },
                        child: Text(
                          data.uid == authController.user.uid
                              ? 'delete'
                              : 'you dont have rights',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(uid: data.uid),
                                ),
                              );
                            },
                            child: buildProfile(
                              data.profilePhoto,
                            ),
                          ),
                          SizedBox(
                            width: 06,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '@' + data.username,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 08,
                              ),
                              Container(
                                height: 20,
                                width: 100,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          data.caption,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 50,
                  right: 10,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () => videoController.likeVideo(data.id),
                            child: Icon(
                              Iconsax.heart5,
                              size: 35,
                              color:
                                  data.likes.contains(authController.user.uid)
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            data.likes.length.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CommentScreen(
                                  id: data.id,
                                ),
                              ),
                            ),
                            child: const Icon(
                              Iconsax.message5,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            data.commentCount.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Iconsax.share5,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            data.shareCount.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                // Column(
                //   children: [
                //     const SizedBox(
                //       height: 100,
                //     ),
                //     Expanded(
                //       child: Row(
                //         mainAxisSize: MainAxisSize.max,
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: [
                //           Expanded(
                //             child: Container(
                //               padding: const EdgeInsets.only(
                //                 left: 20,
                //               ),
                //               child: Column(
                //                 mainAxisSize: MainAxisSize.min,
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceEvenly,
                //                 children: [
                //                   Text(
                //                     data.username,
                //                     style: const TextStyle(
                //                       fontSize: 20,
                //                       color: Colors.white,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                   Text(
                //                     data.caption,
                //                     style: const TextStyle(
                //                       fontSize: 15,
                //                       color: Colors.white,
                //                     ),
                //                   ),
                //                   Row(
                //                     children: [
                //                       const Icon(
                //                         Icons.music_note,
                //                         size: 15,
                //                         color: Colors.white,
                //                       ),
                //                       Text(
                //                         data.songName,
                //                         style: const TextStyle(
                //                           fontSize: 15,
                //                           color: Colors.white,
                //                           fontWeight: FontWeight.bold,
                //                         ),
                //                       ),
                //                     ],
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ),
                //           Container(
                //             width: 100,
                //             margin: EdgeInsets.only(top: size.height / 5),
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //               children: [
                //                 buildProfile(
                //                   data.profilePhoto,
                //                 ),
                //                 Column(
                //                   children: [
                //     InkWell(
                //       onTap: () =>
                //           videoController.likeVideo(data.id),
                //       child: Icon(
                //         Icons.favorite,
                //         size: 40,
                //         color: data.likes.contains(
                //                 authController.user.uid)
                //             ? Colors.red
                //             : Colors.white,
                //       ),
                //     ),
                //     const SizedBox(height: 7),
                //     Text(
                //       data.likes.length.toString(),
                //       style: const TextStyle(
                //         fontSize: 20,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ],
                // ),
                //                     Column(
                //                       children: [
                //                         InkWell(
                //                           onTap: () => Navigator.of(context).push(
                //                             MaterialPageRoute(
                //                               builder: (context) => CommentScreen(
                //                                 id: data.id,
                //                               ),
                //                             ),
                //                           ),
                //                           child: const Icon(
                //                             Icons.comment,
                //                             size: 40,
                //                             color: Colors.white,
                //                           ),
                //                         ),
                //                         const SizedBox(height: 7),
                //                         Text(
                //                           data.commentCount.toString(),
                //                           style: const TextStyle(
                //                             fontSize: 20,
                //                             color: Colors.white,
                //                           ),
                //                         )
                //                       ],
                //                     ),
                //                     Column(
                //                       children: [
                //                         InkWell(
                //                           onTap: () {},
                //                           child: const Icon(
                //                             Icons.reply,
                //                             size: 40,
                //                             color: Colors.white,
                //                           ),
                //                         ),
                //                         const SizedBox(height: 7),
                //                         Text(
                //                           data.shareCount.toString(),
                //                           style: const TextStyle(
                //                             fontSize: 20,
                //                             color: Colors.white,
                //                           ),
                //                         )
                //                       ],
                //                     ),
                //                     CircleAnimation(
                //                       child: buildMusicAlbum(data.profilePhoto),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
              ],
            );
          },
        );
      }),
    );
  }
}

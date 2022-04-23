import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:get/get.dart';
import 'package:tiktok_tutorial/constants.dart';
import 'package:tiktok_tutorial/models/video.dart';

import 'package:video_compress/video_compress.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';

class UploadVideoController extends GetxController {
  // var isUploading = false.obs;
  // var progress = 0.0.obs;
  // var videoprogres = 0.0.obs;

  //uploading gif
  Future<String> _uploadFile(String filePath, String folderName) async {
    var file = File(filePath);
    var basename = p.basename(filePath);

    final downloadUrl = await FirebaseStorage.instance
        .ref()
        .child(folderName)
        .child(basename)
        .putFile(file)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());

    return downloadUrl;
  }

  Future<String> encodeGif(String videopath) async {
    var id = Uuid().v4();

    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final dir = _appDocDir.path;
    final outPath = "$dir/$id.gif";
    await _flutterFFmpeg
        .execute('-i ${videopath} -vf fps=5,scale=450:-1 -t 3 $outPath')
        .then((returnCode) => print("Return code $returnCode"));
    return outPath;
  }

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    // uploadTask.snapshotEvents.listen((event) {
    //   videoprogres.value =
    //       ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
    //               100)
    //           .roundToDouble();
    // });
    return downloadUrl;
  }

  // _getThumbnail(String videoPath) async {
  //   final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
  //   return thumbnail;
  // }

  // Future<String> _uploadImageToStorage(String id, String videoPath) async {
  //   Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
  //   UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
  //   TaskSnapshot snap = await uploadTask;
  //   String downloadUrl = await snap.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  // delete video

  deleteVideo(String id) async {
    await firestore.collection('videos').doc(id).delete();
    await firebaseStorage.ref().child('videos').child(id).delete();
    // await firebaseStorage.refFromURL(id).delete();
  }

  deleteGif(String url) async {
    await firebaseStorage.refFromURL(url).delete();
  }

  // upload video
  uploadVideo(
    String songName,
    String caption,
    String videoPath,
  ) async {
    // isUploading.value = true;

    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      String username = (userDoc.data()! as Map<String, dynamic>)['name'];
      String videoUrl = await _uploadVideoToStorage(
        "$username Video $len $timestamp",
        videoPath,
      );

      // String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

      var gifUrl = await _uploadFile(await encodeGif(videoPath), 'gif');

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "$username Video $len $timestamp",
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        // thumbnail: thumbnail,
        gif: gifUrl,
        timeStamp: DateFormat('yyyyMMddHHmmss').format(DateTime.now()),
      );

      await firestore
          .collection('videos')
          .doc(
            "$username Video $len $timestamp",
          )
          .set(
            video.toJson(),
          );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
    // isUploading.value = false;
  }
}

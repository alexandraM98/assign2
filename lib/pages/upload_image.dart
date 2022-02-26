import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TakePhoto extends StatefulWidget {
  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  File? imageFile;
  String firstButtonText = 'Take photo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Sharing',
            style: TextStyle(fontSize: 22, fontFamily: 'Lexend')),
        centerTitle: true,
        backgroundColor: Colors.indigo[600],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageFile != null)
              Container(
                width: 640,
                height: 480,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  image: DecorationImage(
                      image: FileImage(imageFile!), fit: BoxFit.cover),
                  border: Border.all(width: 2, color: Colors.indigo),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              )
            else
              Container(
                width: 640,
                height: 480,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.all(width: 2, color: Colors.indigo),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  'The image should appear here.',
                  style: TextStyle(fontSize: 20, fontFamily: 'Lexend'),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User notes go here...',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () => getImage(source: ImageSource.camera),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.indigo)),
                      child: const Text('Take a Photo',
                          style: TextStyle(fontSize: 14, fontFamily: 'Lexend'))),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Share From Gallery', style: TextStyle(fontSize: 14, fontFamily: 'Lexend')),
                    onPressed: () async {
                      //Letting users select an image from the phone's gallery
                      final imagePick = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (imagePick == null) {
                        return;
                      }
                      //Generating a pop-up screen for sharing a file from the gallery to different platforms
                      await Share.shareFiles([imagePick.path]);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.indigo)),
                  ),
                ),
              ],
            ),
              ],
            ),
        ),
      );
  }

  /// Getting the image selected by a user
  /// and saving the image to the phone's gallery
  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
        GallerySaver.saveImage(imageFile!.path);
      });
    }
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'string_key';
    final value = prefs.getString(key) ?? 0;
    print('read: $value');
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'string_key';
    final value = 'my value';
    prefs.setString(key, value);
    print('saved $value');
  }
}

// Replace these two methods in the examples that follow




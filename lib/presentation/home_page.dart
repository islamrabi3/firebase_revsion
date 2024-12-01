import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';

class ImageUploader extends StatefulWidget {
  const ImageUploader({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _downloadUrl;
  String pickedFileName = '';

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          pickedFileName = pickedFile.name;
        });
        await _uploadImageToFirebase(_imageFile!);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImageToFirebase(File image) async {
    if (_imageFile == null) return;

    try {
      // Generate a unique file name
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          FirebaseStorage.instance.ref().child('uploads/$pickedFileName');

      // Upload the file
      await storageRef.putFile(_imageFile!);

      // Get the download URL
      final url = await storageRef.getDownloadURL();
      setState(() {
        _downloadUrl = url;
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  deleteImageFromFirebaseStorage() async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('uploads/$pickedFileName');
      await storageRef.delete();
      setState(() {
        _downloadUrl = null;
      });
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Image to Firebase')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_downloadUrl != null)
              Image.network(_downloadUrl!)
            else
              const Text('No image selected.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick & Upload Image'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Delete Image'),
            ),
          ],
        ),
      ),
    );
  }
}

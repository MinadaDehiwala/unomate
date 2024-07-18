import 'package:flutter/material.dart';
import 'dart:io';
import 'image_picker_service.dart';

class NICPhotoScreen extends StatefulWidget {
  const NICPhotoScreen({super.key});

  @override
  _NICPhotoScreenState createState() => _NICPhotoScreenState();
}

class _NICPhotoScreenState extends State<NICPhotoScreen> {
  File? _image;
  final ImagePickerService _imagePickerService = ImagePickerService();

  Future<void> _pickImage(bool fromGallery) async {
    final pickedImage = fromGallery
        ? await _imagePickerService.pickImageFromGallery()
        : await _imagePickerService.pickImageFromCamera();
    setState(() {
      _image = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Black background
          Container(
            color: Colors.black,
          ),
          // Background image with transparency
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/selection_background.png'),
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), // Adjust the opacity here
                  BlendMode.dstATop,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upload a photo of your NIC\nYour data is secured',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Display the selected image
                if (_image != null)
                  Center(
                    child: Image.file(_image!),
                  )
                else
                  const Center(
                    child: Text(
                      'No image selected.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 20),
                // Take a picture button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.25), // 25% opacity white background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    onPressed: () => _pickImage(false),
                    child: const Text(
                      'Take a picture',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Upload NIC button
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.25), // 25% opacity white background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    onPressed: () => _pickImage(true),
                    icon: const Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: const Text(
                      'Upload 2 sides of the NIC',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Continue button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.25), // 25% opacity white background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    onPressed: () {
                      // Implement continue functionality
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                ),
                // Back button
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

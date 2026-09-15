import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_custom_image_cropper/flutter_custom_image_cropper.dart';

void main() {
  runApp(const CropperExampleApp());
}

class CropperExampleApp extends StatelessWidget {
  const CropperExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Image Cropper',
      theme: ThemeData(useMaterial3: true),
      home: const CropperHomePage(),
    );
  }
}

class CropperHomePage extends StatefulWidget {
  const CropperHomePage({super.key});

  @override
  State<CropperHomePage> createState() => CropperHomePageState();
}

class CropperHomePageState extends State<CropperHomePage> {
  File? selectedImage;


  void rotateLeft() {
    cropController.rotateLeft();
  }

  void rotateRight() {
    cropController.rotateRight();
  }


  Future<void> pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    setState(() {
      selectedImage = File(image.path);
    });
  }

  final CropController cropController = CropController();

  File? croppedImage;

  Future<void> cropImage() async {
    try {
      final result = await cropController.crop();

      setState(() {
        croppedImage = result;
      });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image cropped successfully')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Image Cropper')),
      body: selectedImage == null
          ? Center(
              child: ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Select Image'),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CustomImageCropper(
                      imageFile: selectedImage!,
                      controller: cropController,
                      config: const CropConfig(
                        aspectRatio: 1,
                        borderColor: Colors.white,
                        borderWidth: 2,
                        borderRadius: 12,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: rotateLeft,
                              icon: const Icon(Icons.rotate_left),
                              label: const Text('Rotate Left'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: rotateRight,
                              icon: const Icon(Icons.rotate_right),
                              label: const Text('Rotate Right'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: cropImage,
                          child: const Text('Crop Image'),
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

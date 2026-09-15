# Flutter Custom Image Cropper

A customizable Flutter image cropper package that allows users to select, zoom, move, rotate, and crop images with an interactive crop area and draggable resize handles.

## Features

* 📷 Interactive image cropping
* 🔍 Zoom in and zoom out
* ✋ Move/pan the image
* 🔄 Rotate image left and right
* ⬜ Resizable crop area
* 🎯 8 crop handles

    * Top-left
    * Top
    * Top-right
    * Left
    * Right
    * Bottom-left
    * Bottom
    * Bottom-right
* 📐 Optional aspect ratio support
* 🎨 Custom overlay color
* 🖌️ Custom border color and width
* 🔲 Custom crop border radius
* 🎮 External `CropController`
* 📁 Returns the cropped image as a `File`
* ⚡ Lightweight and easy to integrate

## Preview

Add your demo GIF here:

```text
![Flutter Custom Image Cropper Demo](example/assets/demo.gif)
```

## Installation

Add the package to your `pubspec.yaml`.

### Local package

```yaml
dependencies:
  flutter_custom_image_cropper:
    path: ../
```

### Dependencies

The package uses:

```yaml
dependencies:
  flutter:
    sdk: flutter

  image_picker: ^1.1.2
  image: ^4.5.4
```

Run:

```bash
flutter pub get
```

## Basic Usage

Import the package:

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_image_cropper/flutter_custom_image_cropper.dart';
```

Create a controller:

```dart
final CropController cropController = CropController();
```

Display the cropper:

```dart
CustomImageCropper(
  imageFile: selectedImage,
  controller: cropController,
)
```

Crop the image:

```dart
Future<void> cropImage() async {
  final File croppedFile = await cropController.crop();

  print(croppedFile.path);
}
```

The `crop()` method returns a `File` containing the cropped image.

## Complete Example

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_custom_image_cropper/flutter_custom_image_cropper.dart';

class CropperHomePage extends StatefulWidget {
  const CropperHomePage({super.key});

  @override
  State<CropperHomePage> createState() => CropperHomePageState();
}

class CropperHomePageState extends State<CropperHomePage> {
  final ImagePicker imagePicker = ImagePicker();
  final CropController cropController = CropController();

  File? selectedImage;
  File? croppedImage;

  Future<void> pickImage() async {
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      return;
    }

    setState(() {
      selectedImage = File(pickedFile.path);
      croppedImage = null;
    });
  }

  Future<void> cropImage() async {
    if (selectedImage == null) {
      return;
    }

    final result = await cropController.crop();

    setState(() {
      croppedImage = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Image Cropper'),
      ),
      body: selectedImage == null
          ? Center(
              child: ElevatedButton(
                onPressed: pickImage,
                child: const Text('Pick Image'),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: CustomImageCropper(
                    imageFile: selectedImage!,
                    controller: cropController,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: cropController.rotateLeft,
                      icon: const Icon(Icons.rotate_left),
                    ),
                    IconButton(
                      onPressed: cropController.rotateRight,
                      icon: const Icon(Icons.rotate_right),
                    ),
                    ElevatedButton(
                      onPressed: cropImage,
                      child: const Text('Crop Image'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
```

## Crop Configuration

You can customize the cropper using `CropConfig`.

```dart
CustomImageCropper(
  imageFile: selectedImage,
  controller: cropController,
  config: const CropConfig(
    overlayColor: Color(0x99000000),
    borderColor: Colors.white,
    borderWidth: 2,
    borderRadius: 12,
  ),
)
```

## Aspect Ratio

You can provide an aspect ratio for the crop area.

### Square crop

```dart
const CropConfig(
  aspectRatio: 1.0,
)
```

### 4:3 crop

```dart
const CropConfig(
  aspectRatio: 4 / 3,
)
```

### 16:9 crop

```dart
const CropConfig(
  aspectRatio: 16 / 9,
)
```

If no aspect ratio is provided, the crop area can be resized freely.

## CropController

`CropController` provides programmatic control over the cropper.

### Zoom

```dart
cropController.zoomIn();
```

```dart
cropController.zoomOut();
```

### Rotation

Rotate left:

```dart
cropController.rotateLeft();
```

Rotate right:

```dart
cropController.rotateRight();
```

### Reset

Reset the cropper:

```dart
cropController.reset();
```

### Crop

Get the final cropped image:

```dart
final File croppedFile = await cropController.crop();
```

## Controller Properties

The controller exposes the current crop state:

```dart
cropController.scale
cropController.rotation
cropController.position
cropController.cropRect
```

The crop rectangle is represented using Flutter's `Rect`.

## Crop Handles

The crop area contains eight draggable handles:

```text
┌───────────────┐
│ ●      ●     ●│
│               │
│ ●             ●│
│               │
│ ●      ●     ●│
└───────────────┘
```

The handles allow the user to resize the crop area from corners and edges.

## Output

The cropper does not automatically save the image to the device gallery.

Instead, `crop()` returns the resulting image as a `File`:

```dart
final File croppedFile = await cropController.crop();
```

Your application can then decide what to do with the file, such as:

* Upload it to a server
* Store it locally
* Display it
* Save it using a gallery/media plugin
* Send it to another service

## Project Structure

```text
flutter_custom_image_cropper/
│
├── lib/
│   ├── flutter_custom_image_cropper.dart
│   │
│   └── src/
│       ├── controllers/
│       │   └── crop_controller.dart
│       │
│       ├── models/
│       │   └── crop_config.dart
│       │
│       ├── utils/
│       │   └── image_crop_utils.dart
│       │
│       └── widgets/
│           ├── crop_handles.dart
│           └── image_cropper.dart
│
├── example/
│   ├── lib/
│   │   └── main.dart
│   │
│   └── assets/
│       └── demo.gif
│
├── pubspec.yaml
├── README.md
└── LICENSE
```

## Requirements

* Flutter 3.35.5 or compatible
* Dart 3.9.2 or compatible

## Running the Example

Clone the repository and enter the project:

```bash
git clone https://github.com/RuhanShaikh123/flutter_custom_image_cropper.git

cd flutter_custom_image_cropper
```

Get dependencies:

```bash
flutter pub get
```

Run the example:

```bash
cd example
flutter pub get
flutter run
```

## Contributing

Contributions, issues, and feature requests are welcome.

If you find a bug or have an idea for improvement, feel free to open an issue or submit a pull request.

## License

MIT License

Copyright (c) 2026 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 
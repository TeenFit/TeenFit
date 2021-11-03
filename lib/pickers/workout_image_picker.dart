import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WorkoutImagePicker extends StatefulWidget {
  WorkoutImagePicker(this.imagePickFn, this.pickedImageEdit);

  final void Function(File? pickedImage) imagePickFn;
  final File? pickedImageEdit;

  @override
  _WorkoutImagePickerState createState() => _WorkoutImagePickerState();
}

class _WorkoutImagePickerState extends State<WorkoutImagePicker> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    var pickedImageFile;

    if (widget.pickedImageEdit != null) {
      pickedImageFile = widget.pickedImageEdit;
    }

    pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage =
          pickedImageFile == null ? null : File(pickedImageFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: _mediaQuery.size.height * 0.28,
        width: _mediaQuery.size.width,
        child: InkWell(
          child: _pickedImage == null
              ? widget.pickedImageEdit == null
                  ? Image.asset(
                      'assets/images/UploadImage.png',
                      fit: BoxFit.contain,
                    )
                  : Image.file(
                      widget.pickedImageEdit!,
                      fit: BoxFit.contain,
                    )
              : Image.file(
                  _pickedImage!,
                  fit: BoxFit.contain,
                ),
          onTap: () async {
            await _pickImage().then((_) => widget.imagePickFn(_pickedImage));
          },
        ),
      ),
    );
  }
}

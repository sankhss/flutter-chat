import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File) onImageSelect;

  const UserImagePicker(this.onImageSelect);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImageFile;

  _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 150.0,
      imageQuality: 50,
    );

    _updateImage(pickedImage);
  }

  _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery,
      maxWidth: 150.0,
      imageQuality: 50,
    );

    _updateImage(pickedImage);
  }

  _updateImage(PickedFile pickedImage) {
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onImageSelect(_pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.grey,
            backgroundImage:
                _pickedImageFile != null ? FileImage(_pickedImageFile) : null,
          ),
          FractionallySizedBox(
            heightFactor: 0.5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.camera_alt,
              color: Colors.white.withOpacity(0.5),
            ),
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (ctx) {
                    return CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                          onPressed: () {
                            _pickImageFromCamera();
                            Navigator.of(ctx).pop();
                          },
                          child: Text('Tirar Foto'),
                          isDefaultAction: false,
                          isDestructiveAction: false,
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            _pickImageFromGallery();
                            Navigator.of(ctx).pop();
                          },
                          child: Text('Escolher da Galeria'),
                          isDefaultAction: false,
                          isDestructiveAction: false,
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('Cancelar'),
                        isDefaultAction: true,
                        isDestructiveAction: true,
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}

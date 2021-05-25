import 'dart:io';
import 'package:flutter/material.dart';
import 'package:greatplaces/helpers/messenger.helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function(File) onImageSaved;

  ImageInput({required this.onImageSaved});

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;
  final picker = ImagePicker();

  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      if (pickedFile == null) {
        Messenger.showSimpleMessage(context, "No image was selected");
        return;
      }

      setState(() {
        _storedImage = File(pickedFile.path);
      });
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');

      this.widget.onImageSaved(savedImage);
    } catch (e) {
      print(e);
      setState(() {
        _storedImage = null;
      });
      Messenger.showSimpleMessage(context, "Couldn't take image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 160,
          height: 100.0,
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  "No image selected",
                  textAlign: TextAlign.center,
                ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              getImage();
            },
            label: Text("Take Picture"),
            icon: Icon(Icons.camera),
          ),
        )
      ],
    );
  }
}

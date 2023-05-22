import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class AlzheimerModel extends StatefulWidget {
  const AlzheimerModel({Key? key}) : super(key: key);

  @override
  _AlzheimerModelState createState() => _AlzheimerModelState();
}

class _AlzheimerModelState extends State<AlzheimerModel> {
  final picker = ImagePicker();
  File? _image;
  bool _loading = false;
  List<dynamic>? _output;

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
      _loading = true;
    });
    classifyImage(_image!);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/the_alzheimer_model.tflite',
      labels: 'assets/alzheimer_labels.txt',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alzheimer Classification"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    buttonMinWidth: 150,
                    layoutBehavior: ButtonBarLayoutBehavior.padded,
                    buttonPadding: const EdgeInsets.symmetric(vertical: 10),
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: pickGalleryImage,
                        child: const Text('Gallery'),
                      ),
                    ],
                  )
                ],
              ),
              _SpaceLine(),
              // Image
              Center(
                child: _loading
                    ? Container(
                        width: 300,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 50),
                            Image.asset('assets/test_image.jpg'),
                          ],
                        ),
                      )
                    : _output != null && _output!.isNotEmpty
                        ? Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    '${_output?[0]['label']}',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 250,
                                  child: Image.file(_image!),
                                ),
                              ],
                            ),
                          )
                        : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpaceLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5,
      child: Container(
        color: Colors.grey,
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pomodoro/widgets/custom_button.dart';
import 'package:pomodoro/widgets/custom_text_form_field.dart';

class UpdateAccountPage extends StatefulWidget {
  static const routeName = '/update-account';
  const UpdateAccountPage({super.key});

  @override
  State<UpdateAccountPage> createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  String displayPictureUrl = 'https://via.placeholder.com/150';
  String displayName = 'Display Name';
  String email = 'email@example.com';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? imageFile;

  Future<File?> getFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    File? file = File(image!.path);
    return file;
  }

  Future<File> cropImage({required File imageFile}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    );
    return File(croppedFile!.path);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Account'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(displayPictureUrl),
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        File? file = await getFromGallery();
                        if (file == null) {
                          return;
                        }
                        File croppedFile = await cropImage(imageFile: file);
                        setState(() {
                          imageFile = croppedFile;
                        });
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        child: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              width: width,
              autofocus: true,
              controller: emailController,
              labelText: 'Email',
              hintText: 'Email Address',
              prefixIcon: Icons.email,
              textCapitalization: TextCapitalization.none,
              borderRadius: 10,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              width: width,
              autofocus: true,
              controller: emailController,
              labelText: 'Email',
              hintText: 'Email Address',
              prefixIcon: Icons.email,
              textCapitalization: TextCapitalization.none,
              borderRadius: 10,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Update Account',
              isLoading: false,
              isDisabled: false,
              onPressed: () {
                // if (_formKey.currentState!.validate()) {
                // handleLogin();
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;

import '../../additionals/additional.dart';

class UserDetailsUpdate extends StatefulWidget {
  const UserDetailsUpdate({Key? key, this.userModel}) : super(key: key);
  final UserModel? userModel;

  @override
  _UserDetailsUpdateState createState() => _UserDetailsUpdateState();
}

class _UserDetailsUpdateState extends State<UserDetailsUpdate> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String? photoUrl, locationError, nameError, emailError;
  XFile? _file;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.userModel != null) {
      photoUrl = widget.userModel!.photoUrl;
      nameController.text = widget.userModel!.name;
      emailController.text = widget.userModel!.email;
      locationController.text = widget.userModel!.location;
    }
  }

  Future<String?> _uploadImageGetUrl() async {
    if (_file != null) {
      setState(() {
        pleaseWaitDialog(
          context,
          msg: 'Adding Your Image',
          title: 'Please wait...',
        );
      });
      Reference reference = FirebaseStorage.instance
          .ref('Users')
          .child(FirebaseAuth.instance.currentUser!.uid);
      try {
        await reference.putFile(File(_file!.path));
        Navigator.pop(dialogContext);
      } catch (e) {
        Navigator.pop(dialogContext);
      }
      return await reference.getDownloadURL();
    } else {
      Navigator.pop(dialogContext);
      return null;
    }
  }

  void pickImage() async {
    var file = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);
    setState(() {
      _file = file;
    });
  }

  void submitData() async {
    setState(() {
      locationError = null;
      nameError = null;
      emailError = null;
    });
    if (nameController.text.isEmpty) {
      setState(() {
        nameError = 'Please enter your name*';
      });
    } else if (emailController.text.isEmpty) {
      emailError = 'Enter your email*';
    } else if (locationController.text.isEmpty) {
      locationError = 'Enter your location*';
    } else {
      try {
        photoUrl = await _uploadImageGetUrl();
        setState(() {
          _file = null;
        });
        UserModel.updateInDB(
          userModel: UserModel(
            name: nameController.text,
            location: locationController.text,
            email: emailController.text,
            photoUrl: photoUrl,
          ),
        );
        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(nameController.text);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            FocusManager.instance.primaryFocus!.unfocus();
          });
        },
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    photoUrl == null
                        ? _file == null
                            ? InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: pickImage,
                                splashColor: Colors.indigo,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Icon(Icons.photo_camera),
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(
                                              File(_file!.path),
                                            ),
                                            fit: BoxFit.cover)),
                                    height: 200,
                                    width: 200,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _file = null;
                                      });
                                    },
                                    icon: const Icon(Icons.close),
                                  )
                                ],
                              )
                        : Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        CachedNetworkImageProvider(photoUrl!),
                                    fit: BoxFit.cover)),
                            height: 200,
                            width: 200,
                          ),
                    textWidget(
                      errorText: nameError,
                        textEditingController: nameController,
                        labelText: 'Name',
                        helperText: 'Enter your name here'),
                    textWidget(
                      errorText: emailError,
                        textEditingController: emailController,
                        labelText: 'Email',
                        helperText: 'Enter your email here'),
                    textWidget(
                      errorText: locationError,
                      textEditingController: locationController,
                      labelText: 'Location',
                      helperText:
                          'Enter your current location here or tap the icon',
                      icon: IconButton(
                        onPressed: getLocation,
                        icon: const Icon(Icons.gps_fixed),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //todo submit
                        submitData();
                      },
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textWidget(
      {required String labelText,
      required String helperText,
      Widget? icon,
      String? errorText,
      required TextEditingController textEditingController}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (val) {
          setState(() {});
        },
        controller: textEditingController,
        decoration: InputDecoration(
          errorText: errorText,
          suffixIcon: icon,
          label: Text(
            labelText,
            textAlign: TextAlign.center,
          ),
          helperText: helperText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Future<void> getLocation() async {
    loc.Location userLocation = loc.Location();
    var _permissionGranted = await userLocation.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.granted) {
      loc.LocationData position =
          await userLocation.getLocation(); // todo not working on tab

      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude!, position.longitude!);
      setState(() {
        locationController.text =
            '${placemarks.first.name}, ${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
      });
    } else {
      await userLocation.requestService();
      await userLocation.requestPermission();
      await getLocation();
    }
  }
}

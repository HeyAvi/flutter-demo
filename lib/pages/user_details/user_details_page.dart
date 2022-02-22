import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo/models/user_model.dart';
import 'package:flutter/material.dart';

class UserDetailsUpdate extends StatefulWidget {
  const UserDetailsUpdate({Key? key}) : super(key: key);

  @override
  _UserDetailsUpdateState createState() => _UserDetailsUpdateState();
}

class _UserDetailsUpdateState extends State<UserDetailsUpdate> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String? photoUrl;
  Image? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  photoUrl == null
                      ? Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.photo_camera),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(photoUrl!),
                                  fit: BoxFit.cover)),
                          height: 200,
                          width: 200,
                        ),
                  textWidget(
                      textEditingController: nameController,
                      labelText: 'Name',
                      helperText: 'Enter your name here'),
                  textWidget(
                      textEditingController: emailController,
                      labelText: 'Email',
                      helperText: 'Enter your email here'),
                  textWidget(
                    textEditingController: locationController,
                    labelText: 'Location',
                    helperText: 'Enter your current location here',
                    icon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.gps_fixed),
                    ),
                  )
                ],
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
      required TextEditingController textEditingController}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (val) {
          setState(() {});
        },
        controller: textEditingController,
        decoration: InputDecoration(
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
}

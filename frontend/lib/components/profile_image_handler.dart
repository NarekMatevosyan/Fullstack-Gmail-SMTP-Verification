import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:bbb/utils/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageWidget extends StatefulWidget {
  final String ? name;
  final bool  showPickImageButton;
  final String avatarUrl;
  final Function(File? pickedImage) callBack;
  const ProfileImageWidget({super.key, this.name, required this.showPickImageButton, required this.avatarUrl, required this.callBack});


  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {


  File? image;

  Future<void> _pickAndUploadImage() async {
    try{
      final ImagePicker picker = ImagePicker();
      XFile? file = await picker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        image = File(file.path);

        widget.callBack(image);
        setState(() {
        });
        String fileName = path.basename(file.path);
        log("FILE NAME $fileName");
      }
    }catch(e){
      log("ERROR IN PICK IMAGE $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.horizontalScale(25),
      width: ScreenUtil.horizontalScale(25),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.9),
        borderRadius: BorderRadius.all(
          Radius.circular(ScreenUtil.horizontalScale(12.5)),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: ScreenUtil.horizontalScale(25),
            width: ScreenUtil.horizontalScale(25),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.9),
              borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil.horizontalScale(12.5)),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ScreenUtil.horizontalScale(12.5)),

              child: image != null ? Image.file(
                image!,
                fit: BoxFit.cover,
              ) : widget.avatarUrl != ''
                  ?  Image.network(
                widget.avatarUrl.startsWith(
                    'https://storage.cloud.google.com/')
                    ? widget.avatarUrl.replaceFirst(
                    'https://storage.cloud.google.com/',
                    'https://storage.googleapis.com/')
                    : widget.avatarUrl,
                fit: BoxFit.cover,
              ) : Center(
                child: Text(
                  widget.name==null?"":widget.name!.isNotEmpty?
                  widget.name![0]:"",  // First character of the name
                  style: TextStyle(
                    fontSize: ScreenUtil.horizontalScale(12),
                    color: Colors.white,// Adjust size as needed
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )

            ),
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: Visibility(
              visible: widget.showPickImageButton,
              child: GestureDetector(
                onTap: () {
                  _pickAndUploadImage();
                  // Handle camera icon action here
                },
                child: CircleAvatar(
                  radius: ScreenUtil.horizontalScale(4), // Adjust size as needed
                  backgroundColor: Colors.black.withOpacity(.7),
                  child: Icon(
                    Icons.camera_alt,
                    size: ScreenUtil.horizontalScale(5), // Adjust size as needed
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


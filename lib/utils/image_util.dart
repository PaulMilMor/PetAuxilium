import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:pet_auxilium/models/ImageUploadModel.dart';

class ImageUtil{
    final _picker = ImagePicker();
      File imageFile ;
    Future onAddImageClick() async {
    final _imageFile = await _picker.getImage(source: ImageSource.gallery);
     imageFile = File(_imageFile.path);

      if (imageFile != null) {
       return getFileImage();
      }
  }
  ImageUploadModel getFileImage(){
     ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = imageFile;
        imageUpload.imageUrl = '';
    return imageUpload;
  }
}
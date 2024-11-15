import 'package:image_picker/image_picker.dart';

 class CameraPlugin {
  final ImagePicker picker = ImagePicker();

  Future<String?> takePhoto()async{
     final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear
      );

      if(photo == null) return null;

      print('Imagen Capturada ${photo.path}');

    return photo.path;
  }
  Future<String?> selectPhoto() async {
     final XFile? photo = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      );

      if(photo == null) return null;

      print('Imagen Capturada ${photo.path}');

    return photo.path;
  }
  Future<List<String?>> multiplePhotos()async{
    return [''];
  }
}
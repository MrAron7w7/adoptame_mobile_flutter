import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_image_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileImageProvider extends _$ProfileImageProvider {
  final ImagePicker _picker = ImagePicker();

  @override
  String? build() => null;

  Future<void> selectProfilePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (photo != null) {
      state = photo.path;
    }
  }

  void reset() {
    state = null;
  }
}

import 'package:adoptme/core/enum/enums.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'enums_provider.g.dart';

@Riverpod(keepAlive: true)
class AnimalGnderProvider extends _$AnimalGnderProvider {
  @override
  AnimalGender build() {
    return AnimalGender.macho;
  }

  void setGender({required AnimalGender animalGender}) {
    state = animalGender;
  }
}

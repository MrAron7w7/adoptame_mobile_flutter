import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enum/enums.dart';

part 'seleted_dropdown_provider.g.dart';

@Riverpod(keepAlive: true)
class SeletedDropdown extends _$SeletedDropdown {
  @override
  FilterAnimal build() {
    return FilterAnimal.all;
  }

  void selecterFilter(FilterAnimal filter) {
    state = filter;
  }
}

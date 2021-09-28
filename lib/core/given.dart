import 'dart:async';

FutureOr<void> given(String description, void Function() body) {
  body();
}

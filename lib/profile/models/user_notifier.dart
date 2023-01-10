import 'package:dogly_front/profile/models/user.dart';
import 'package:flutter/material.dart';

class UserNotifier extends ValueNotifier<User> {
  UserNotifier({required User value}) : super(value);
}
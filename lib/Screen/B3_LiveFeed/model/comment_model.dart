import 'package:flutter/material.dart';
import 'package:tasty_cookpad/Screen/B3_LiveFeed/model/user_model.dart';


class CommentModel {
  final UserModel user;
  final String comment;
  final DateTime time;

  const CommentModel({
    @required this.user,
    @required this.comment,
    @required this.time,
  });
}

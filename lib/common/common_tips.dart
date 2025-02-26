
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonTips {
  static error(BuildContext context,String content){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static success(BuildContext context,String content){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}


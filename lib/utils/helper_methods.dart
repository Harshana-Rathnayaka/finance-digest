import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// show toast
showToast({required String msg, required Color backGroundColor}) => Fluttertoast.showToast(msg: msg, textColor: Colors.white, backgroundColor: backGroundColor, toastLength: Toast.LENGTH_LONG);

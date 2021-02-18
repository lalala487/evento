import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'Screen/Login/SplashScreen.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

//List<CameraDescription> cameras;

void main()
{
  // For play billing library 2.0 on Android, it is mandatory to call
  // [enablePendingPurchases](https://developer.android.com/reference/com/android/billingclient/api/BillingClient.Builder.html#enablependingpurchases)
  // as part of initializing the app.
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(Splash());
}
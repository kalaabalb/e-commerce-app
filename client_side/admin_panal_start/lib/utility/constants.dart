import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);
const defaultPadding = 16.0;

// Dynamic URL that works on all platforms
String getBaseUrl() {
  if (kIsWeb) {
    return 'http://localhost:3000';
  } else {
    // For mobile/desktop - use your machine's IP address
    return 'http://10.161.175.199:3000'; // Replace with your actual IP
  }
}

const MAIN_URL = 'http://10.161.175.199:3000'; // Your current IP from ip addr

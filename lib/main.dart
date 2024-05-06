import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/export.dart';

void main() {
  final sharedSecret = List.generate(32, (_) => 4);
  final message = "Hello, this is a secret message!";
  final encryptedMessage = encryptMessageOnServer(sharedSecret, message);

  runApp(MyApp(encryptedMessage: encryptedMessage));
}

Uint8List encryptMessageOnServer(List<int> sharedSecret, String message) {
  final key = Uint8List.fromList(sharedSecret);
  final iv = Uint8List.fromList(
      List.generate(16, (_) => 0)); // Initialization vector (IV) for AES
  final keyParam = KeyParameter(key);
  final params = ParametersWithIV(keyParam, iv);
  print(params);
  final cipher =
      PaddedBlockCipherImpl(PKCS7Padding(), CBCBlockCipher(AESFastEngine()));
  cipher.init(true, params);
  final paddedData = cipher.process(Uint8List.fromList(utf8.encode(message)));
  return paddedData;
}


class MyApp extends StatelessWidget {
  final Uint8List encryptedMessage;

  MyApp({required this.encryptedMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Encryption App'),
        ),
        body: Center(
          child: Text(
            "Encrypted Message (Base64): ${base64Encode(encryptedMessage)}",
          ),
        ),
      ),
    );
  }
}

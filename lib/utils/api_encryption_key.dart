import 'dart:convert';
import 'dart:developer';
import 'package:basic_utils/basic_utils.dart';
import 'package:conferance_application/config/constant/stringsutils.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/export.dart' as point;
import 'package:random_string/random_string.dart';

RSAPublicKey getPublicKeyFromBase64EncodedKey(String b64) {
  final pem =
      '-----BEGIN RSA PUBLIC KEY-----\n$b64\n-----END RSA PUBLIC KEY-----';
  return CryptoUtils.rsaPublicKeyFromPem(pem);
}

String encryptApiKey(String plainText) {
  final plainBytes = utf8.encode(plainText);
  const javaEncoded = rsaKey;

  final public = getPublicKeyFromBase64EncodedKey(javaEncoded);
  final cipher =  point.OAEPEncoding.withSHA1(point.RSAEngine())
    ..init(true, PublicKeyParameter<RSAPublicKey>(public));
  final cipherBytes = cipher.process(plainBytes);
  return base64Encode(cipherBytes);
}

String encryptsNSDL(String plainText) {
  final plainBytes = utf8.encode(plainText);
  const javaEncoded = rsaKey;
  final public = getPublicKeyFromBase64EncodedKey(javaEncoded);
  final cipher =  point.OAEPEncoding.withSHA1(point.RSAEngine())
    ..init(true, PublicKeyParameter<RSAPublicKey>(public));
  final cipherBytes = cipher.process(plainBytes);
  return base64Encode(cipherBytes);
}

Encrypted encryptRequestBody(String plainText,String rKey) {
  var key = rKey;
  final cipherKey =  Key.fromUtf8(key);
  final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(key.substring(0, 16));

  Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
  decryptWithAES(encryptedData, rKey);
  return encryptedData;
}

decryptWithAES(Encrypted encrypted, String eKey){
  var key = eKey;
  final cipherKey =  Key.fromUtf8(key);
  final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(key.substring(0, 16));

  final decrypted = encryptService.decrypt(encrypted,iv: initVector);

  log("Decrypted body $decrypted");
}

Encrypted encryptWithAESNSDL(String plainText,String rKey) {
  var key = rKey;
  final cipherKey =  Key.fromUtf8(key);
  final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
  final initVector = IV.fromUtf8(key.substring(0, 16));

  Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
  return encryptedData;
}


String generateRandomKey() {
  return randomAlphaNumeric(16);
}
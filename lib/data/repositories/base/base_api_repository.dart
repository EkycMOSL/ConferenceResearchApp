
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:conferance_application/config/appConfigUtils/local_storage_key.dart';
import 'package:conferance_application/config/appConfigUtils/localstorage.dart';
import 'package:conferance_application/config/constant/apiendpoints.dart';
import 'package:conferance_application/config/constant/stringsutils.dart';
import 'package:conferance_application/domain/api_state.dart';
import 'package:conferance_application/utils/api_encryption_key.dart';
import 'package:conferance_application/utils/constant_static.dart';
import 'package:conferance_application/utils/dio_client.dart';
import 'package:dio/dio.dart';

enum RequestType {
  GET, POST
}

class BaseApi {
  final dio =DioClient().dio;

  BaseApi._internal();

  static final _singleton = BaseApi._internal();

  factory BaseApi() => _singleton;

  Future<ApiDataState<T>> apiCall<T>({required String url,
    Map<String, dynamic>? queryParameters, dynamic body, required RequestType requestType,bool? isToken,String? straccessCode}) async {
    late  Response result;
    try {
      switch (requestType) {
        case RequestType.GET: {
          Options options = Options(headers: header(key: ""));
         // dio.options.baseUrl= ApiEndpoints.openCageAPi;
          result = await dio.get( url, queryParameters: queryParameters, options: options);
          break;
        }
        case RequestType.POST: {
          String _token = "";
          if(isToken == true) {
            _token = await _getToken() ?? "";
          }
          String apiEncryptionKey = generateRandomKey();
          Options options = Options(headers: header(key: encryptApiKey(apiEncryptionKey),token: _token,straccessCode: straccessCode));
          log("User Token: $_token");
          result = await dio.post( url, data: encryptedBodyData(data: body, key: apiEncryptionKey), options: options);
          break;
        }

      }
      if(requestType == RequestType.GET){
        dio.options.baseUrl= ConstantStatic.baseUrl;
        return DataSuccess(result.data);
      }
      if(result.data != null) {
        log("Response ${result}");
        Map response = result.data;
        if(response.containsKey("data"))
        {
          if(response["data"] is! Map){
            return DataSuccess(response as T);
          }

          if(response["data"]["Status"] == true){
            return DataSuccess(response["data"]);
          }else{
            return  DataError(response["data"]["Message"] ?? somethingWentWrong);
          }
        }
        else {
          return DataSuccess(response["data"]);
        }


      } else {
        return const DataError("Data is null");
      }
    }on DioException catch (error) {
      return DataError(error.toString());
    } catch (error) {
      return DataError(error.toString());
    }
  }

/*
  Future<ApiDataState<T>> fileUploadApiCall<T>({required String url,
    required File? objFile, required String strFileType,required String strBankProofType,
    required String strIncomeProofType, required String strExtension,
    required String strCmrCopy,required String CallBankOcr, bool? isToken}) async{
    late  Response result;
    try {
      String _token = "";
      if(isToken == true) {
        _token = await _getToken() ?? "";
      }
      String apiEncryptionKey = generateRandomKey();
      Options options = Options(headers: header(key: encryptApiKey(apiEncryptionKey),token: _token),contentType: 'multipart/form-data');
      var formData = FormData.fromMap({
        "ApplicationType":applicationType,
        "FileType":strFileType,
        "BANKPROOF_TYPE":strBankProofType,
        "IncomeProofType":strIncomeProofType,
        "Extension":strExtension,
        "CMRCOPYPROOF_TYPE":strCmrCopy,
        "CallBankOcr":CallBankOcr,
        "file": await MultipartFile.fromFile(objFile!.path.toString(),filename: "test.jpg"),
      });


      result=await dio.post(url, data: formData,options: options);
      if(result.data != null) {
        Map response = result.data;
        if(response["data"]["Status"] == true){
          return DataSuccess(response["data"]);
        }else{
          return  DataError(response["data"]["Message"] ?? somethingWentWrong);
        }

      } else {
        return const DataError("Data is null");
      }
    } on DioException catch (error) {
      return DataFailed(error);
    } catch (error) {
      return DataError(error.toString());
    }
  }

*/



}


Map<String, String> encryptedBodyData({required dynamic data,required String key}) {
  return {"body" : encryptRequestBody(json.encode(data), key).base64};
}


Map<String, String> header({required String key, String? token, String? straccessCode}) {
  return {
    'Content-type': 'application/json',
    'meta' : key,
    'token' : token ?? "",
    'X-Accesscode' : straccessCode ??""};
}

Future<String?> _getToken() async{
  return await LocalStorage.getString(LocalStorageKeyName.token);
}






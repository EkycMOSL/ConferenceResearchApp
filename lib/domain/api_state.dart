import 'dart:io';

import 'package:dio/dio.dart';

abstract class ApiDataState<T> {
  final T? data;
  final DioException? error;
  final String? errorMessage;

  const ApiDataState({this.data, this.error,this.errorMessage});
}

class DataSuccess<T> extends ApiDataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends ApiDataState<T> {
  const DataFailed(DioException error) : super(error: error);
}

class DataError<T> extends ApiDataState<T>{
  const DataError(String message): super(errorMessage: message);
}

class DataNotSet<T> extends ApiDataState<T> {
  const DataNotSet();
}



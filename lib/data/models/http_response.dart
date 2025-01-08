import 'dart:convert';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:equatable/equatable.dart';

@jsonSerializable
class HttpResponse extends Equatable {
  @JsonProperty(name: "message")
  final String? message;

  @JsonProperty(name: "status")
  final bool? status;

  @JsonProperty(name: "data")
  final dynamic data;

  const HttpResponse({this.message, this.status, this.data});

  HttpResponse copyWith({String? message, bool? status, dynamic data}) {
    return HttpResponse(
        message: this.message, status: this.status, data: this.data);
  }

  static HttpResponse? fromJson(Map<String, dynamic> json) {
    var result = JsonMapper.fromMap<HttpResponse>(json);
    if (result == null) {
      return null;
    }
    return result;
  }

  static HttpResponse? fromJsonString(String json) {
    var result = JsonMapper.deserialize<HttpResponse>(jsonDecode(json));
    if (result == null) {
      return null;
    }
    return result;
  }

  @override
  List<Object?> get props => [message, status, data];
}
